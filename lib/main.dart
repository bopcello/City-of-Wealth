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
    ) = await loadGameState();

    setState(() {
      kp = savedKp;
      gems = savedGems;
      career = savedCareer;
      lastIncomeTime = savedIncomeTime;
      cityLayout = savedLayout;
      assets = savedAssets;
      _loaded = true;
    });
  }

  void _save() {
    saveGameState(
      kp: kp,
      gems: gems,
      career: career,
      lastIncomeTime: lastIncomeTime,
      layout: cityLayout,
      assets: assets,
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
              gems += 10;
            });
            _save();
          },
          onDebugReset: () {
            setState(() {
              career = const CareerState(track: CareerTrack.student, level: 1);
              cityLayout = [];
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
            final cost = assetCost(type) * amount;
            if (gems < cost) return;

            setState(() {
              gems -= cost;
              assets = assets.add(type, amount);
            });
            _save();
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
          onKpChange: (delta) {
            setState(() => kp += delta);
            _save();
          },
          onCareerChange: (newCareer) {
            setState(() => career = newCareer);
            _save();
          },
          onBuyAsset: (type, amount) {
            final cost = assetCost(type) * amount;
            if (gems < cost) return;
            setState(() {
              gems -= cost;
              assets = assets.add(type, amount);
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
