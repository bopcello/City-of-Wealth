import 'dart:async';
import 'package:flutter/material.dart';

import 'game_state.dart';
import 'tabs/home_tab.dart';
import 'tabs/city_tab.dart';
import 'tabs/money_tab.dart';
import 'tabs/settings_tab.dart';

void main() {
  runApp(const CityOfWealthApp());
}

class CityOfWealthApp extends StatelessWidget {
  const CityOfWealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.amber, useMaterial3: true),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  Timer? _cycleTimer;

  late int kp;
  late int gems;
  late CareerState career;
  late DateTime lastIncomeTime;
  late AssetInventory assets;
  List<PlacedBuilding> cityLayout = [];

  RentType? rentChoice;
  FoodType? foodChoice;
  TransportType? transportChoice;
  Set<AssetType> insurances = {};
  int bankruptcyCount = 0;

  bool _loaded = false;
  bool _incomePaused = false; // [DEBUG: PAUSE_INCOME]
  final List<String> _pendingEvents = [];

  @override
  void initState() {
    super.initState();
    _loadGame();
    // Start debug timer for 10s cycles
    _cycleTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_loaded) _checkDailyCycle();
    });
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadGame() async {
    final (
      savedKp,
      savedGems,
      savedCareer,
      savedIncomeTime,
      savedLayout,
      savedAssets,
      savedRent,
      savedFood,
      savedTransport,
      savedInsurances,
      savedBankruptcyCount,
    ) = await loadGameState();

    setState(() {
      kp = savedKp;
      gems = savedGems;
      career = savedCareer;
      lastIncomeTime = savedIncomeTime;
      cityLayout = savedLayout;
      assets = savedAssets;
      rentChoice = savedRent;
      foodChoice = savedFood;
      transportChoice = savedTransport;
      insurances = savedInsurances;
      bankruptcyCount = savedBankruptcyCount;
      _loaded = true;
    });

    _checkDailyCycle();
  }

  void _save() {
    saveGameState(
      kp: kp,
      gems: gems,
      career: career,
      lastIncomeTime: lastIncomeTime,
      layout: cityLayout,
      assets: assets,
      rent: rentChoice,
      food: foodChoice,
      transport: transportChoice,
      insurances: insurances,
      bankruptcyCount: bankruptcyCount,
    );
  }

  void _checkDailyCycle() {
    final now = DateTime.now();
    final difference = now.difference(lastIncomeTime);

    const int cycleSeconds = 10; // DEBUG: Changed from 24h to 10s
    if (difference.inSeconds >= cycleSeconds) {
      // [DEBUG: PAUSE_INCOME] check if income is paused
      if (_incomePaused) {
        lastIncomeTime = now; // Slide time forward without applying income
        return;
      }
      final cycles = difference.inSeconds ~/ cycleSeconds;
      _applyCycles(cycles);
    }
  }

  void _applyCycles(int cycles) {
    int totalKpChange = 0;
    int totalGemChange = 0;
    List<String> events = [];

    final hasAllEssentials =
        rentChoice != null && foodChoice != null && transportChoice != null;
    final income = dailyIncome(career.track, career.level);

    // Check for unnecessary assets (recurring penalty)
    bool hasWaste = false;
    int wastePenalty = 100;
    if (career.level == 1) {
      if (assets.items.isNotEmpty) {
        hasWaste = true;
        wastePenalty = 50;
      }
    } else {
      for (var type in AssetType.values) {
        if (assets.count(type) >
            getMaxRequirementForType(career.track, career.level, type)) {
          hasWaste = true;
          break;
        }
      }
    }

    for (int i = 0; i < cycles; i++) {
      int dayKp = 0;
      int dayGems = 0;
      final dayNumber = _pendingEvents.length + i + 1;

      if (hasAllEssentials) {
        dayGems += income;
      }

      // Liabilities
      int rCost = rentChoice != null
          ? getRentCost(career.track, career.level, rentChoice!)
          : 0;
      int fCost = foodChoice != null
          ? getFoodCost(career.track, career.level, foodChoice!)
          : 0;
      int tCost = transportChoice != null
          ? getTransportCost(career.track, career.level, transportChoice!)
          : 0;

      int insuranceCost = insurances.length * 5;
      int insuranceKp = insurances.length * 20;

      int maintenanceCost = 0;
      if (dayNumber % 10 == 0) {
        for (var b in cityLayout) {
          maintenanceCost += getBuildingLevel(b.name);
        }
      }

      // Debt Interest Calculation
      int interestCost = 0;
      if (gems < 0) {
        double rate = 0.05;
        int debtFactor = gems.abs();
        if (debtFactor >= 2000) {
          rate = 0.20;
        } else if (debtFactor >= 1500) {
          rate = 0.10;
        } else if (debtFactor >= 1000) {
          rate = 0.05;
        }
        interestCost = (debtFactor * rate).round();
      }

      dayKp +=
          (rentChoice != null
              ? getRentKp(career.track, career.level, rentChoice!)
              : 0) +
          (foodChoice != null
              ? getFoodKp(career.track, career.level, foodChoice!)
              : 0) +
          (transportChoice != null
              ? getTransportKp(career.track, career.level, transportChoice!)
              : 0) +
          insuranceKp;

      if (hasWaste) {
        dayKp -= wastePenalty;
      }

      dayGems -=
          (rCost +
          fCost +
          tCost +
          insuranceCost +
          maintenanceCost +
          interestCost);

      totalKpChange += dayKp;
      totalGemChange += dayGems;

      String event =
          "Day $dayNumber: Kp=${dayKp > 0 ? '+' : ''}$dayKp, Gems=${dayGems > 0 ? '+' : ''}$dayGems";
      if (interestCost > 0) event += " (Interest: -$interestCost Gems)";
      if (maintenanceCost > 0) {
        event += " (Maintenance: -$maintenanceCost Gems)";
      }
      if (insuranceCost > 0) event += " (Insurance: -$insuranceCost Gems)";
      if (!hasAllEssentials)
        event +=
            " (No income: Go to liabilities to select rent, food and transport to begin receiving income)";
      if (hasWaste) event += " (Waste penalty: -$wastePenalty KP)";
      events.add(event);
    }

    setState(() {
      kp += totalKpChange;
      gems += totalGemChange;
      lastIncomeTime = DateTime.now();

      _pendingEvents.addAll(events);
      // Popup removed as per request, events now shown on HomeTab
    });
    _save();
  }

  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        return HomeTab(
          kp: kp,
          gems: gems,
          career: career,
          events: _pendingEvents,
          rentChoice: rentChoice,
          foodChoice: foodChoice,
          transportChoice: transportChoice,
          assets: assets,
          onClearEvents: () {
            setState(() {
              _pendingEvents.clear();
            });
          },
          // [DEBUG: PAUSE_INCOME] pause toggle callback
          incomePaused: _incomePaused,
          onPauseToggled: (val) {
            setState(() => _incomePaused = val);
          },
        );
      case 1:
        return CityTab(
          career: career,
          gems: gems,
          assets: assets,
          cityLayout: cityLayout,
          onBuyAsset: (AssetType type, int amount) {
            _handleBuyAsset(type, amount);
          },
          onPlaceBuilding: (building) {
            setState(() {
              cityLayout.add(building);
            });
            _save();
          },
        );
      case 2:
        return MoneyTab(
          currentKp: kp,
          career: career,
          gems: gems,
          assets: assets,
          rent: rentChoice,
          food: foodChoice,
          transport: transportChoice,
          cityLayout: cityLayout,
          insurances: insurances,
          bankruptcyCount: bankruptcyCount,
          onKpChange: (delta) {
            setState(() => kp += delta);
            _save();
          },
          onInsuranceToggle: _handleToggleInsurance,
          onSellAsset: _handleSellAsset,
          onBankruptcy: _handleBankruptcy,
          onCareerChange: (newCareer) {
            setState(() {
              if (newCareer.level > career.level) {
                // Reset liabilities on level up
                rentChoice = null;
                foodChoice = null;
                transportChoice = null;
                debugPrint("🚀 Level up! Liabilities reset to defaults.");
              }
              career = newCareer;
            });
            _save();
          },
          onBuyAsset: (type, amount) {
            _handleBuyAsset(type, amount);
          },
          onLiabilitiesChange: (r, f, t) {
            setState(() {
              // Calculate immediate KP change for moving from 'None' to a selection
              int kpDelta = 0;
              if (rentChoice == null && r != null) {
                kpDelta += getRentKp(career.track, career.level, r);
              }
              if (foodChoice == null && f != null) {
                kpDelta += getFoodKp(career.track, career.level, f);
              }
              if (transportChoice == null && t != null) {
                kpDelta += getTransportKp(career.track, career.level, t);
              }

              rentChoice = r;
              foodChoice = f;
              transportChoice = t;
              kp += kpDelta;
            });
            _save();
          },
        );
      case 3:
        return SettingsTab(
          onDebugAdd: () {
            setState(() {
              kp += 1000;
              gems += 1000;
            });
            _save();
          },
          onDebugReset: () {
            setState(() {
              career = const CareerState(track: CareerTrack.student, level: 1);
              cityLayout = [];
              assets = const AssetInventory({});
              rentChoice = null;
              foodChoice = null;
              transportChoice = null;
              _pendingEvents.clear();
            });
            _save();
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _handleToggleInsurance(AssetType type) {
    setState(() {
      if (insurances.contains(type)) {
        insurances.remove(type);
      } else {
        insurances.add(type);
        kp += 100; // Immediate bonus as requested
      }
    });
    _save();
  }

  void _handleBuyAsset(AssetType type, int amount) {
    final cost = assetCost(type) * amount;

    int kpBonus = 10 * amount;
    String message = "Purchasing necessary assets: +$kpBonus KP";

    final currentAssetsOfThisType = assets.count(type);
    final maxAllowedForThisType = getMaxRequirementForType(
      career.track,
      career.level,
      type,
    );

    if (currentAssetsOfThisType + amount > maxAllowedForThisType) {
      kpBonus = -100;
      message =
          "Over-purchasing ${assetLabel(type)} for your level is a bad decision: -100 KP";
    }

    setState(() {
      gems -= cost;
      assets = assets.add(type, amount);
      kp += kpBonus;
    });
    _save();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Asset Purchased"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Great!"),
          ),
        ],
      ),
    );
  }

  void _handleSellAsset(AssetType type) {
    if (assets.count(type) <= 0) return;
    final sellPrice = assetSellPrice(type);
    setState(() {
      gems += sellPrice;
      assets = assets.add(type, -1);
    });
    _save();
  }

  void _handleBankruptcy() {
    if (bankruptcyCount >= 3) return;

    int totalLiquidationValue = 0;
    for (var type in AssetType.values) {
      totalLiquidationValue += assets.count(type) * assetSellPrice(type);
    }

    final gemsRecovered = (totalLiquidationValue * 0.2).round();

    setState(() {
      bankruptcyCount++;
      kp = 0;
      gems = gemsRecovered;
      career = const CareerState(track: CareerTrack.student, level: 1);
      cityLayout = [];
      assets = const AssetInventory({});
      insurances = {};
      rentChoice = null;
      foodChoice = null;
      transportChoice = null;
    });
    _save();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Bankruptcy Declared"),
        content: Text(
          "All your assets were auctioned off and your debt was waived. "
          "Thankfully, the bank recovered $gemsRecovered gems more than your debt.\n\n"
          "You are now back to being a Level 1 Student. Good luck starting over!",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("I understand"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("City of Wealth"),
        actions: [
          _CounterChip(label: "KP", value: kp, icon: Icons.school),
          const SizedBox(width: 8),
          _CounterChip(label: "Gems", value: gems, icon: Icons.diamond),
          const SizedBox(width: 12),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() => selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.amber.shade700,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: "City",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Money"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class _CounterChip extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const _CounterChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 18), label: Text("$label: $value"));
  }
}
