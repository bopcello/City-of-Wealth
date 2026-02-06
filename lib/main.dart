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

  bool _loaded = false;
  // bool _incomePaused = false; // DEBUG: income pause flag
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
    );
  }

  void _checkDailyCycle() {
    final now = DateTime.now();
    final difference = now.difference(lastIncomeTime);

    const int cycleSeconds = 10; // DEBUG: Changed from 24h to 10s
    if (difference.inSeconds >= cycleSeconds) {
      /* 
      // DEBUG: check if income is paused
      if (_incomePaused) {
        lastIncomeTime = now; // Slide time forward without applying income
        return;
      }
      */
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
    for (var type in AssetType.values) {
      if (assets.count(type) >
          getMaxRequirementForType(career.track, career.level, type)) {
        hasWaste = true;
        break;
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

      dayKp +=
          (rentChoice != null ? rentData[rentChoice!]!.kp : 0) +
          (foodChoice != null ? foodData[foodChoice!]!.kp : 0) +
          (transportChoice != null ? transportData[transportChoice!]!.kp : 0);

      if (hasWaste) {
        dayKp -= 100;
      }

      dayGems -= (rCost + fCost + tCost);

      totalKpChange += dayKp;
      totalGemChange += dayGems;

      String event =
          "Day $dayNumber: Kp=${dayKp > 0 ? '+' : ''}$dayKp, Gems=${dayGems > 0 ? '+' : ''}$dayGems";
      if (!hasAllEssentials) event += " (No income: missing essentials)";
      if (hasWaste) event += " (Waste penalty: -100 KP)";
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
          /*
          // DEBUG: pause toggle callback
          incomePaused: _incomePaused,
          onPauseToggled: (val) {
            setState(() => _incomePaused = val);
          },
          */
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
          onKpChange: (delta) {
            setState(() => kp += delta);
            _save();
          },
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
                kpDelta += rentData[r]!.kp;
              }
              if (foodChoice == null && f != null) {
                kpDelta += foodData[f]!.kp;
              }
              if (transportChoice == null && t != null) {
                kpDelta += transportData[t]!.kp;
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

  void _handleBuyAsset(AssetType type, int amount) {
    final cost = assetCost(type) * amount;
    if (gems < cost) return;

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
