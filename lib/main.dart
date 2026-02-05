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

  @override
  void initState() {
    super.initState();
    _loadGame();
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

    if (difference.inHours >= 24) {
      final cycles = difference.inHours ~/ 24;
      _applyCycles(cycles);
    }
  }

  void _applyCycles(int cycles) {
    int totalKpChange = 0;
    int totalGemChange = 0;

    final income = dailyIncome(career.track, career.level);

    for (int i = 0; i < cycles; i++) {
      totalGemChange += income;

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

      totalKpChange +=
          (rentChoice != null ? rentData[rentChoice!]!.kp : 0) +
          (foodChoice != null ? foodData[foodChoice!]!.kp : 0) +
          (transportChoice != null ? transportData[transportChoice!]!.kp : 0);

      totalGemChange -= (rCost + fCost + tCost);
    }

    setState(() {
      kp += totalKpChange;
      gems += totalGemChange;
      lastIncomeTime = DateTime.now();
    });
    _save();

    if (totalKpChange != 0 || totalGemChange != 0) {
      _showCyclePopup(totalKpChange, totalGemChange, cycles);
    }
  }

  void _showCyclePopup(int kpDelta, int gemDelta, int cycles) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("$cycles Day Cycle Summary"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("KP Change: ${kpDelta > 0 ? '+' : ''}$kpDelta"),
            Text("Gems Change: ${gemDelta > 0 ? '+' : ''}$gemDelta"),
            const SizedBox(height: 8),
            const Text(
              "Based on your current lifestyle choices in Liabilities.",
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        return HomeTab(
          kp: kp,
          gems: gems,
          career: career,
          onDebugAdd: () {
            setState(() {
              kp += 1000;
              gems += 100;
            });
            _save();
          },
          onDebugReset: () {
            setState(() {
              career = const CareerState(track: CareerTrack.student, level: 1);
              cityLayout = [];
              rentChoice = null;
              foodChoice = null;
              transportChoice = null;
            });
            _save();
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
              if (rentChoice == null && r != null) kpDelta += rentData[r]!.kp;
              if (foodChoice == null && f != null) kpDelta += foodData[f]!.kp;
              if (transportChoice == null && t != null)
                kpDelta += transportData[t]!.kp;

              rentChoice = r;
              foodChoice = f;
              transportChoice = t;
              kp += kpDelta;
            });
            _save();
          },
        );
      case 3:
        return const SettingsTab();
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
      kpBonus -= 100;
      message =
          "Over-purchasing ${assetLabel(type)} for your level is a bad decision: -100 KP (Total: $kpBonus)";
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
