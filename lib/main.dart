import 'package:flutter/material.dart';

import 'game_state.dart';
import 'logic/game_manager.dart';
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
  final GameManager game = GameManager();

  @override
  void dispose() {
    game.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    switch (selectedIndex) {
      case 0:
        return HomeTab(
          kp: game.kp,
          gems: game.gems,
          career: game.career,
          events: game.pendingEvents,
          rentChoice: game.rentChoice,
          foodChoice: game.foodChoice,
          transportChoice: game.transportChoice,
          assets: game.assets,
          onClearEvents: game.clearEvents,
          incomePaused: game.incomePaused,
          onPauseToggled: game.togglePause,
        );
      case 1:
        return CityTab(
          career: game.career,
          gems: game.gems,
          assets: game.assets,
          cityLayout: game.cityLayout,
          insurances: game.insurances,
          hasWall: game.hasWall,
          onBuyAsset: (AssetType type, int amount) {
            game.buyAsset(type, amount, context);
          },
          onPlaceBuilding: game.placeBuilding,
          onRemoveBuilding: game.removeBuilding,
          onBuyWall: game.buyWall,
        );
      case 2:
        return MoneyTab(
          currentKp: game.kp,
          career: game.career,
          gems: game.gems,
          assets: game.assets,
          rent: game.rentChoice,
          food: game.foodChoice,
          transport: game.transportChoice,
          cityLayout: game.cityLayout,
          insurances: game.insurances,
          bankruptcyCount: game.bankruptcyCount,
          completedQuizzes: game.completedQuizzes,
          onKpChange: game.updateKp,
          onInsuranceToggle: game.toggleInsurance,
          onSellAsset: game.sellAsset,
          onBankruptcy: () => game.declareBankruptcy(context),
          onCareerChange: game.updateCareer,
          onBuyAsset: (type, amount) {
            game.buyAsset(type, amount, context);
          },
          onLiabilitiesChange: game.updateLiabilities,
          onQuizComplete: game.markQuizCompleted,
          gameListenable: game,
        );
      case 3:
        return SettingsTab(
          onDebugAdd: game.debugAdd,
          onDebugLevelUp: game.debugLevelUp,
          onDebugReset: game.debugReset,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: game,
      builder: (context, child) {
        if (!game.loaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Handle Disaster Results
        if (game.pendingDisasterResults.isNotEmpty) {
          final results = List<DisasterResult>.from(
            game.pendingDisasterResults,
          );
          game.clearDisasterResults();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            for (var result in results) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => DisasterReportDialog(result: result),
              );
            }
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("City of Wealth"),
            actions: [
              _CounterChip(label: "KP", value: game.kp, icon: Icons.school),
              const SizedBox(width: 8),
              _CounterChip(
                label: "Gems",
                value: game.gems,
                icon: Icons.diamond,
              ),
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
      },
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

class DisasterReportDialog extends StatelessWidget {
  final DisasterResult result;

  const DisasterReportDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    String title = "";
    IconData icon = Icons.warning;
    Color color = Colors.orange;

    switch (result.type) {
      case DisasterType.flood:
        title = "Flood Alert!";
        icon = Icons.water;
        color = Colors.blue;
        break;
      case DisasterType.fire:
        title = "Fire Outbreak!";
        icon = Icons.local_fire_department;
        color = Colors.red;
        break;
      case DisasterType.earthquake:
        title = "Earthquake!";
        icon = Icons.landscape;
        color = Colors.brown;
        break;
      case DisasterType.economyCrash:
        title = "Economy Crash!";
        icon = Icons.trending_down;
        color = Colors.purple;
        break;
    }

    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Flexible(child: Text(title)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "A disaster has struck your city! Here is the impact report:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (result.destroyedBuildings.isNotEmpty) ...[
              const Text(
                "Buildings Destroyed:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...result.destroyedBuildings.map((b) => Text("• $b")),
              const SizedBox(height: 12),
            ],
            if (result.lostAssets.isNotEmpty) ...[
              const Text(
                "Assets Lost:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...result.lostAssets.entries.map(
                (e) => Text("• ${assetLabel(e.key)}: ${e.value}"),
              ),
              const SizedBox(height: 12),
            ],
            if (result.insurancePayouts.isNotEmpty) ...[
              const Divider(),
              const Text(
                "Insurance Protection Applied! ✅",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...result.insurancePayouts.entries.map(
                (e) => Text(
                  "• ${assetLabel(e.key)} payout: ${e.value} Gems",
                  style: const TextStyle(color: Colors.green),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (result.kpPenalty > 0) ...[
              const Divider(),
              Text(
                "NO INSURANCE PENALTY! ❌",
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "• Deducted ${result.kpPenalty} KP for lack of insurance.",
                style: TextStyle(color: Colors.red.shade700),
              ),
              const SizedBox(height: 12),
            ],
            if (!result.protected && result.kpPenalty == 0)
              const Text(
                "Luckily, no major assets were lost or you were partially covered.",
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("I understand"),
        ),
      ],
    );
  }
}
