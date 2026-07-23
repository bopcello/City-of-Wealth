import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../game_state.dart';
import '../logic/game_manager.dart';
import '../logic/tutorial_keys.dart';
import '../services/music_manager.dart';
import '../services/sfx_manager.dart';
import '../widgets/icon_text.dart';
import '../widgets/tutorial_overlay.dart';
import '../tabs/home_tab.dart';
import '../tabs/city_tab.dart';
import '../tabs/money_tab.dart';
import '../tabs/settings_tab.dart';
import '../theme/app_colors.dart';
import 'quiz_screen.dart';
import 'career_screen.dart';
import 'assets_screen.dart';
import 'liabilities_screen.dart';
import 'passive_income_screen.dart';
import '../services/notification_service.dart';

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
    NotificationService.notificationPayloadNotifier.addListener(_handleNotificationPayload);
    // Trigger initial check in case app launched via notification click
    _handleNotificationPayload();
  }

  @override
  void dispose() {
    widget.game.removeListener(_handleGameStateChange);
    NotificationService.notificationPayloadNotifier.removeListener(_handleNotificationPayload);
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

  void _handleNotificationPayload() {
    final payload = NotificationService.notificationPayloadNotifier.value;
    if (payload == 'quiz') {
      NotificationService.notificationPayloadNotifier.value = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToQuizScreen();
      });
    }
  }

  void _navigateToQuizScreen() {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizMenuScreen(
          game: widget.game,
          music: widget.music,
          sfx: widget.sfx,
        ),
      ),
    );
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
              recentVisitedMoneyTiles: game.recentVisitedMoneyTiles,
              playerName: game.playerName,
              dailyQuoteText: game.todayQuoteText,
              dailyQuoteAuthor: game.todayQuoteAuthor,
              onMoneyTileTap: (title) {
                if (title == "Quiz") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizMenuScreen(
                        game: game,
                        music: widget.music,
                        sfx: widget.sfx,
                      ),
                    ),
                  );
                }
                if (title == "Career") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CareerScreen(game: game, sfx: widget.sfx),
                    ),
                  );
                }
                if (title == "Assets") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AssetsScreen(
                        assets: game.assets,
                        gems: game.gems,
                        streak: game.dailyQuizStreak,
                        onBuyAsset: (type) => game.buyAsset(type, 1, context),
                        onSellAsset: (type) => game.sellAsset(type),
                        sfx: widget.sfx,
                        game: game,
                      ),
                    ),
                  );
                }
                if (title == "Liabilities") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiabilitiesScreen(
                        game: game,
                        currentRent: game.rentChoice,
                        currentFood: game.foodChoice,
                        currentTransport: game.transportChoice,
                        onSelectionChanged: game.updateLiabilities,
                        sfx: widget.sfx,
                      ),
                    ),
                  );
                }
                if (title == "Passive Income") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PassiveIncomeScreen(game: game, sfx: widget.sfx),
                    ),
                  );
                }
              },
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
              isActive: game.selectedIndex == 3,
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

// =============================================================================
// Merged Widgets (< 200 lines) from consolidated files
// =============================================================================

class NameEntryDialog extends StatefulWidget {
  final void Function(String) onConfirm;

  const NameEntryDialog({super.key, required this.onConfirm});

  @override
  State<NameEntryDialog> createState() => _NameEntryDialogState();
}

class _NameEntryDialogState extends State<NameEntryDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  void _handleSubmit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() {
        _errorText = "Name cannot be empty";
      });
      return;
    }
    if (name.length > 20) {
      setState(() {
        _errorText = "Name too long (max 20 chars)";
      });
      return;
    }
    widget.onConfirm(name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Welcome to City of Wealth!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Please enter your name to begin your journey:"),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Player Name",
              errorText: _errorText,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _handleSubmit(),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _handleSubmit,
          child: const Text("Begin Game"),
        ),
      ],
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
                    "Insurance Protection Applied!",
                    style: TextStyle(
                      color: AppColors.of(context, 'success'),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...result.insurancePayouts.entries.map(
                    (e) => Text(
                      "• ${assetLabel(e.key)} payout: ${e.value} Gems",
                      style: TextStyle(color: AppColors.of(context, 'success')),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (result.kpPenalty > 0) ...[
                  Text(
                    "NO INSURANCE PENALTY!",
                    style: TextStyle(
                      color: AppColors.of(context, 'error'),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "• Deducted ${result.kpPenalty} KP for lack of insurance.",
                    style: TextStyle(color: AppColors.of(context, 'error')),
                  ),
                  const SizedBox(height: 8),
                ],
                if (result.passiveIncomeReduction != null) ...[
                  Text(
                    "Passive Income Impact:",
                    style: TextStyle(
                      color: AppColors.of(context, 'error'),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "• ${result.passiveIncomeReduction}",
                    style: TextStyle(color: AppColors.of(context, 'error')),
                  ),
                  const SizedBox(height: 8),
                ],
                if (result.deactivatedPassiveIncomes.isNotEmpty) ...[
                  Text(
                    "Passive Incomes Deactivated (Reinvest required):",
                    style: TextStyle(
                      color: AppColors.of(context, 'warning'),
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

class LoadingScreen extends StatefulWidget {
  final double progress; // 0.0 to 1.0 (Kept for compatibility)

  const LoadingScreen({super.key, this.progress = 1.0});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gemColor = AppColors.of(context, 'gem');

    return Scaffold(
      backgroundColor: AppColors.of(context, 'background'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bigger Logo
            Image.asset('lib/assets/app_icon.png', height: 120),
            const SizedBox(height: 24),
            // Bigger Title
            Text(
              "City of Wealth",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.of(context, 'onBackground'),
              ),
            ),
            const SizedBox(height: 80),
            // Spinning Gem Indicator
            RotationTransition(
              turns: _rotationController,
              child: Icon(
                Icons.diamond_outlined,
                color: gemColor,
                size: 80,
                shadows: [
                  Shadow(
                    color: gemColor.withValues(alpha: 0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            // Subtext
            Text(
              "Master your Money",
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.of(context, 'onSurfaceVariant'),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
