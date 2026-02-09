import 'package:flutter/material.dart';

import 'game_state.dart';
import 'logic/game_manager.dart';
import 'tabs/home_tab.dart';
import 'tabs/city_tab.dart';
import 'tabs/money_tab.dart';
import 'tabs/settings_tab.dart';
import 'widgets/counter_chip.dart';

void main() {
  runApp(const CityOfWealthApp());
}

class CityOfWealthApp extends StatefulWidget {
  const CityOfWealthApp({super.key});

  @override
  State<CityOfWealthApp> createState() => _CityOfWealthAppState();
}

class _CityOfWealthAppState extends State<CityOfWealthApp> {
  final GameManager game = GameManager();

  @override
  void dispose() {
    game.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: game,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: Colors.amber,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.amber,
              brightness: Brightness.dark,
              surface: const Color(0xFF1A1C1E),
              onSurface: Colors.white,
              surfaceVariant: const Color(0xFF2C2E33),
              onSurfaceVariant: Colors.white,
            ),
          ),
          themeMode: game.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MainScreen(game: game),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final GameManager game;
  const MainScreen({super.key, required this.game});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  Widget _buildBody() {
    final game = widget.game;
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
          activePassiveIncomes: game.activePassiveIncomes,
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
          game: game,
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
          isWorkingOvertime: game.isWorkingOvertime,
          onWorkOvertime: game.workOvertime,
          activePassiveIncomes: game.activePassiveIncomes,
          onInvestInPassiveIncome: game.investInPassiveIncome,
          gameListenable: game,
        );
      case 3:
        return SettingsTab(
          career: game.career,
          isDarkMode: game.isDarkMode,
          onThemeToggle: game.toggleTheme,
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
    final game = widget.game;
    if (!game.loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Handle Disaster Results
    if (game.pendingDisasterResults.isNotEmpty) {
      final results = List<DisasterResult>.from(game.pendingDisasterResults);
      game.clearDisasterResults();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => DisasterReportDialog(results: results),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("City of Wealth"),
        actions: [
          CounterChip(label: "KP", value: game.kp, icon: Icons.school),
          const SizedBox(width: 8),
          CounterChip(
            label: "Gems",
            value: game.gems,
            icon: Icons.diamond,
            color: Colors.blue,
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
        backgroundColor: game.isDarkMode ? Colors.grey.shade900 : Colors.white,
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

class DisasterReportDialog extends StatelessWidget {
  final List<DisasterResult> results;

  const DisasterReportDialog({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Icon(Icons.warning, color: Colors.orange),
          SizedBox(width: 8),
          Flexible(child: Text("City Disaster Report")),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: results.length,
          separatorBuilder: (context, index) => const Divider(height: 32),
          itemBuilder: (context, index) {
            final result = results[index];
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
              case DisasterType.drought:
                title = "Severe Drought!";
                icon = Icons.wb_sunny;
                color = Colors.orange;
                break;
              case DisasterType.landslide:
                title = "Landslide!";
                icon = Icons.terrain;
                color = Colors.deepOrange;
                break;
              case DisasterType.massEmigration:
                title = "Mass Emigration!";
                icon = Icons.people_outline;
                color = Colors.blueGrey;
                break;
              case DisasterType.pandemic:
                title = "Pandemic!";
                icon = Icons.health_and_safety;
                color = Colors.teal;
                break;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (result.destroyedBuildings.isNotEmpty) ...[
                  const Text(
                    "Buildings Destroyed:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...result.destroyedBuildings.map((b) => Text("• $b")),
                  const SizedBox(height: 8),
                ],
                if (result.lostAssets.isNotEmpty) ...[
                  const Text(
                    "Assets Lost:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...result.lostAssets.entries.map(
                    (e) => Text("• ${assetLabel(e.key)}: ${e.value}"),
                  ),
                  const SizedBox(height: 8),
                ],
                if (result.insurancePayouts.isNotEmpty) ...[
                  Text(
                    "Insurance Protection Applied! ✅",
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...result.insurancePayouts.entries.map(
                    (e) => Text(
                      "• ${assetLabel(e.key)} payout: ${e.value} Gems",
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (result.kpPenalty > 0) ...[
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
                  const SizedBox(height: 8),
                ],
                if (result.passiveIncomeReduction != null) ...[
                  Text(
                    "Passive Income Impact:",
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "• ${result.passiveIncomeReduction}",
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                  const SizedBox(height: 8),
                ],
                if (result.deactivatedPassiveIncomes.isNotEmpty) ...[
                  Text(
                    "Passive Incomes Deactivated (Reinvest required):",
                    style: TextStyle(
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...result.deactivatedPassiveIncomes.entries.map(
                    (e) => Text("• ${assetLabel(e.key)}: ${e.value} units"),
                  ),
                  const SizedBox(height: 8),
                ],
                if (!result.protected &&
                    result.kpPenalty == 0 &&
                    result.lostAssets.isEmpty &&
                    result.destroyedBuildings.isEmpty &&
                    result.deactivatedPassiveIncomes.isEmpty)
                  const Text(
                    "Luckily, no assets or passive income sources were lost.",
                  ),
              ],
            );
          },
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
