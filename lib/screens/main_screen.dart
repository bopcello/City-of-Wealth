import 'package:flutter/material.dart';
import '../game_state.dart';
import '../logic/game_manager.dart';
import '../services/music_manager.dart';
import '../services/sfx_manager.dart';
import '../theme/app_colors.dart';
import '../widgets/counter_chip.dart';
import '../widgets/name_entry_dialog.dart';
import '../widgets/disaster_report_dialog.dart';
import '../screens/loading_screen.dart';
import '../tabs/home_tab.dart';
import '../tabs/city_tab.dart';
import '../tabs/money_tab.dart';
import '../tabs/settings_tab.dart';

class MainScreen extends StatefulWidget {
  final GameManager game;
  final MusicManager music;
  final SfxManager sfx;
  const MainScreen({
    super.key,
    required this.game,
    required this.music,
    required this.sfx,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _nameDialogShown = false;

  @override
  void initState() {
    super.initState();
    widget.game.addListener(_handleGameStateChange);
    // Check immediately in case it's already loaded
    _handleGameStateChange();
  }

  @override
  void dispose() {
    widget.game.removeListener(_handleGameStateChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.game != widget.game) {
      oldWidget.game.removeListener(_handleGameStateChange);
      widget.game.addListener(_handleGameStateChange);
    }
  }

  void _handleGameStateChange() {
    if (!mounted) return;

    // Handle Name Dialog
    if (widget.game.loaded &&
        widget.game.playerName == "User" &&
        !_nameDialogShown) {
      _nameDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => NameEntryDialog(
            onConfirm: (name) {
              widget.game.setPlayerName(name);
            },
          ),
        );
      });
    }

    // Handle Disaster Results - Moved out of build to prevent navigation bugs
    if (widget.game.pendingDisasterResults.isNotEmpty) {
      final results = List<DisasterResult>.from(
        widget.game.pendingDisasterResults,
      );
      widget.game.clearDisasterResults();
      widget.sfx.playDisaster();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => DisasterReportDialog(results: results),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    if (!game.loaded) {
      return const LoadingScreen();
    }

    return PopScope(
      canPop: game.selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        widget.sfx.playBack();
        if (game.selectedIndex != 0) {
          game.selectedIndex = 0;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("City of Wealth"),
          actions: [
            CounterChip(
              label: "KP",
              value: game.kp,
              icon: Icons.school,
              color: AppColors.of(context, 'kp'),
            ),
            const SizedBox(width: 8),
            CounterChip(
              label: "Gems",
              value: game.gems,
              icon: Icons.diamond,
              color: AppColors.of(context, 'gem'),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: IndexedStack(
          index: game.selectedIndex,
          children: [
            HomeTab(
              kp: game.kp,
              gems: game.gems,
              career: game.career,
              events: game.pendingEvents,
              rentChoice: game.rentChoice,
              foodChoice: game.foodChoice,
              transportChoice: game.transportChoice,
              assets: game.assets,
              onClearEvents: game.clearEvents,
              sfx: widget.sfx,
            ),
            CityTab(
              career: game.career,
              gems: game.gems,
              assets: game.assets,
              cityLayout: game.cityLayout,
              insurances: game.insurances,
              activePassiveIncomes: game.activePassiveIncomes,
              hasWall: game.hasWall,
              sfx: widget.sfx,
              onBuyAsset: (AssetType type, int amount) {
                game.buyAsset(type, amount, context);
              },
              onPlaceBuilding: game.placeBuilding,
              onRemoveBuilding: game.removeBuilding,
              onBuyWall: game.buyWall,
              game: game,
            ),
            MoneyTab(
              game: game,
              music: widget.music,
              sfx: widget.sfx,
              currentKp: game.kp,
              playerName: game.playerName,
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
            ),
            SettingsTab(
              career: game.career,
              isDarkMode: game.isDarkMode,
              musicVolume: game.musicVolume,
              sfxVolume: game.sfxVolume,
              onThemeToggle: game.toggleTheme,
              onMusicVolumeChanged: game.updateMusicVolume,
              onSfxVolumeChanged: game.updateSfxVolume,
              onCloudSync: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Cloud Sync"),
                    content: const Text(
                      "Do you want to reload your progress from the cloud? This will overwrite your current local session data.",
                    ),
                    actions: [
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      TextButton(
                        child: const Text("Reload from Cloud"),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await game.forceCloudLoad();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cloud progress loaded!")),
                    );
                  }
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: game.selectedIndex,
          onTap: (index) {
            widget.sfx.playClick();
            game.selectedIndex = index;
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
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
      ),
    );
  }
}
