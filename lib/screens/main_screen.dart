import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../game_state.dart';
import '../logic/game_manager.dart';
import '../logic/tutorial_keys.dart';
import '../services/music_manager.dart';
import '../services/sfx_manager.dart';
import '../widgets/counter_chip.dart';
import '../widgets/name_entry_dialog.dart';
import '../widgets/disaster_report_dialog.dart';
import '../widgets/tutorial_overlay.dart';
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
  OverlayEntry? _tutorialOverlayEntry;
  bool _overlayInserted = false;

  @override
  void initState() {
    super.initState();
    widget.game.addListener(_handleGameStateChange);
    // Check immediately in case it's already loaded
    _handleGameStateChange();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTutorialOverlay();
    });
  }

  @override
  void dispose() {
    widget.game.removeListener(_handleGameStateChange);
    if (_tutorialOverlayEntry != null && _overlayInserted) {
      _tutorialOverlayEntry?.remove();
    }
    _tutorialOverlayEntry = null;
    _overlayInserted = false;
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

  void _updateTutorialOverlay() {
    if (!mounted) return;
    if (widget.game.isTutorialActive) {
      if (_tutorialOverlayEntry == null) {
        _overlayInserted = false;
        _tutorialOverlayEntry = OverlayEntry(
          builder: (context) => TutorialOverlay(
            game: widget.game,
            sfx: widget.sfx,
            onComplete: () {
              _updateTutorialOverlay();
            },
          ),
        );
        // Small delay to ensure underlying widgets are fully rendered
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted && _tutorialOverlayEntry != null && !_overlayInserted) {
            try {
              final overlay = Overlay.maybeOf(context);
              if (overlay != null) {
                overlay.insert(_tutorialOverlayEntry!);
                _overlayInserted = true;
              }
            } catch (e) {
              debugPrint("❌ Error inserting tutorial overlay: $e");
            }
          }
        });
      } else {
        if (_overlayInserted) {
          try {
            _tutorialOverlayEntry!.markNeedsBuild();
          } catch (e) {
            debugPrint("⚠️ Failed to markNeedsBuild overlay: $e");
          }
        }
      }
    } else {
      if (_tutorialOverlayEntry != null) {
        if (_overlayInserted) {
          try {
            _tutorialOverlayEntry?.remove();
          } catch (e) {
            debugPrint("⚠️ Failed to remove overlay: $e");
          }
        }
        _tutorialOverlayEntry = null;
        _overlayInserted = false;
      }
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

    _updateTutorialOverlay();

    // Rebuild to reflect latest game state in AppBar chips and tabs
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    if (!game.loaded) {
      return const LoadingScreen();
    }

    final bool canPop = !game.isTutorialActive && game.selectedIndex == 0;

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (game.isTutorialActive) {
          game.onBackGestureIntercepted?.call();
          return;
        }
        widget.sfx.playBack();
        if (game.selectedIndex != 0) {
          game.selectedIndex = 0;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              KeyedSubtree(
                key: TutorialKeys.kpKey,
                child: CounterChip(label: "[KP]", value: game.kp, prefix: "KP"),
              ),
              KeyedSubtree(
                key: TutorialKeys.gemsKey,
                child: CounterChip(
                  label: "[GEM]",
                  value: game.gems,
                  prefix: "Gems",
                ),
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            KeyedSubtree(
              key: TutorialKeys.streakKey,
              child: CounterChip(
                label: "[STREAK]",
                value: game.dailyQuizStreak,
                prefix: "Streak",
              ),
            ),
            KeyedSubtree(
              key: TutorialKeys.revivalsKey,
              child: CounterChip(
                label: "[REVIVAL]",
                value: game.streakRevivals,
                prefix: "Revivals",
              ),
            ),
            const SizedBox(width: 8),
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
              dailyQuizAvailable:
                  game.lastDailyQuizDate !=
                  DateFormat('yyyy-MM-dd').format(DateTime.now()),
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
              game: game,
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
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_city, key: TutorialKeys.tabCityKey),
              label: "City",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work, key: TutorialKeys.tabMoneyKey),
              label: "Money",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, key: TutorialKeys.tabSettingsKey),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
