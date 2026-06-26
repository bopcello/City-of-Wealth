import 'package:flutter/material.dart';

import '../logic/game_manager.dart';
import '../logic/tutorial_keys.dart';
import '../services/sfx_manager.dart';
import '../widgets/icon_text.dart';
import '../screens/career_screen.dart';
import '../screens/passive_income_screen.dart';
import '../screens/assets_screen.dart';
import '../screens/liabilities_screen.dart';
import '../screens/quiz_screen.dart';

enum TutorialStepType { info, interactive, backNavigation }

class TutorialStep {
  final String title;
  final String description;
  final GlobalKey? targetKey;
  final TutorialStepType type;
  final Future<void> Function()? action;
  final bool allowDirectTap;
  final bool Function(GameManager)? canProgress;

  const TutorialStep({
    required this.title,
    required this.description,
    this.targetKey,
    this.type = TutorialStepType.info,
    this.action,
    this.allowDirectTap = false,
    this.canProgress,
  });

  bool get isInteractive => type == TutorialStepType.interactive;

  bool get isBackStep => type == TutorialStepType.backNavigation;

  bool get isFullScreenHighlight =>
      targetKey == TutorialKeys.cityBodyKey ||
      targetKey == TutorialKeys.settingsBodyKey ||
      targetKey == TutorialKeys.assetsBodyKey;
}

class TutorialOverlay extends StatefulWidget {
  final GameManager game;
  final SfxManager sfx;
  final VoidCallback onComplete;

  const TutorialOverlay({
    super.key,
    required this.game,
    required this.sfx,
    required this.onComplete,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _arrowController;
  late final List<TutorialStep> _steps;
  late final Animation<double> _arrowAnimation;

  int _currentStep = 0;
  Rect? _targetRect;
  bool _showExitDialog = false;

  TutorialStep get currentStep => _steps[_currentStep];

  @override
  void initState() {
    super.initState();

    widget.game.addListener(_onGameStateChanged);

    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _arrowAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    _steps = [
      TutorialStep(
        title: "Welcome to City of Wealth!",
        description:
            "This game will help you master personal finance while building a city! Let's start with your stats at the top.",
      ),
      TutorialStep(
        title: "Knowledge Points (KP)",
        description:
            "Your [KP] represents your financial literacy and determines your career path and promotion opportunities.",
        targetKey: TutorialKeys.kpKey,
      ),
      TutorialStep(
        title: "Earning KP",
        description:
            "You earn [KP] by answering daily quizzes. High [KP] is required for promotions to higher-paying careers.",
        targetKey: TutorialKeys.kpKey,
      ),
      TutorialStep(
        title: "Gems Balance",
        description:
            "Your Gems represent your liquidity. Use them to buy assets, construct buildings, and pay daily expenses.",
        targetKey: TutorialKeys.gemsKey,
      ),
      TutorialStep(
        title: "Managing Cash Flow",
        description:
            "Keep a close eye on your Gems! If your lifestyle liabilities or building maintenance exceed your earnings, you might run out of Gems and face bankruptcy.",
        targetKey: TutorialKeys.gemsKey,
      ),
      TutorialStep(
        title: "Daily Streak",
        description:
            "Answering the Daily Quiz builds your streak. Higher streaks offer asset discounts and passive income boosts!",
        targetKey: TutorialKeys.streakKey,
      ),
      TutorialStep(
        title: "Streak Revivals",
        description:
            "Revivals protect your streak if you miss a day. You start with 3 and can earn more at milestones.",
        targetKey: TutorialKeys.revivalsKey,
      ),
      TutorialStep(
        title: "City View",
        description:
            "Let's check out your City tab. Tap the City icon below to switch tabs.",
        targetKey: TutorialKeys.tabCityKey,
        type: TutorialStepType.interactive,
        action: () async {
          widget.game.selectedIndex = 1;
        },
      ),
      TutorialStep(
        title: "Your City Skyline",
        description:
            "This is your City view. Every asset you buy will appear as a beautiful building here in real time.",
        targetKey: TutorialKeys.cityBodyKey,
      ),
      TutorialStep(
        title: "City Defenses",
        description:
            "You can place, move, or remove buildings. Protect them from natural disasters by building a defensive City Wall or buying insurance.",
        targetKey: TutorialKeys.cityBodyKey,
      ),
      TutorialStep(
        title: "HQ Hub",
        description:
            "Let's visit the Money tab where your financial controls are located. Tap the Money icon below.",
        targetKey: TutorialKeys.tabMoneyKey,
        type: TutorialStepType.interactive,
        action: () async {
          widget.game.selectedIndex = 2;
        },
      ),
      TutorialStep(
        title: "Career HQ",
        description:
            "First, let's explore your Career. Tap the Career tile to check your job status.",
        targetKey: TutorialKeys.careerTileKey,
        type: TutorialStepType.interactive,
        action: () async {
          final BuildContext? currentCtx =
              TutorialKeys.careerTileKey.currentContext;
          if (currentCtx != null && currentCtx.mounted) {
            Navigator.push(
              currentCtx,
              MaterialPageRoute(
                builder: (_) =>
                    CareerScreen(game: widget.game, sfx: widget.sfx),
              ),
            );
          }
        },
      ),
      TutorialStep(
        title: "Your Job Card",
        description:
            "This card shows your current job title, level, active salary, and promotion requirements.",
        targetKey: TutorialKeys.careerHeroCardKey,
      ),
      TutorialStep(
        title: "Working Overtime",
        description:
            "You can work overtime to earn extra Gems immediately, but it drains your health and costs KP if done too often.",
        targetKey: TutorialKeys.careerOvertimeKey,
      ),
      TutorialStep(
        title: "Return to HQ",
        description: "Tap the Back button to return to the Money tab.",
        targetKey: TutorialKeys.careerBackKey,
        type: TutorialStepType.backNavigation,
        action: () async {
          final BuildContext? currentCtx =
              TutorialKeys.careerBackKey.currentContext;
          if (currentCtx != null && currentCtx.mounted) {
            Navigator.pop(currentCtx);
          }
        },
      ),
      TutorialStep(
        title: "Passive Income",
        description:
            "Passive income lets you earn Gems automatically. Tap the Passive Income tile.",
        targetKey: TutorialKeys.passiveIncomeTileKey,
        type: TutorialStepType.interactive,
        action: () async {
          final BuildContext? currentCtx =
              TutorialKeys.passiveIncomeTileKey.currentContext;
          if (currentCtx != null && currentCtx.mounted) {
            Navigator.push(
              currentCtx,
              MaterialPageRoute(
                builder: (_) =>
                    PassiveIncomeScreen(game: widget.game, sfx: widget.sfx),
              ),
            );
          }
        },
      ),
      TutorialStep(
        title: "Dividends & Assets",
        description:
            "Passive income investments (like Index Funds or Bonds) pay you automatic dividends for each asset of that type you own.",
      ),
      TutorialStep(
        title: "Return to HQ",
        description: "Tap the Back button to go back to the Money tab.",
        targetKey: TutorialKeys.passiveIncomeBackKey,
        type: TutorialStepType.backNavigation,
        action: () async {
          final BuildContext? currentCtx =
              TutorialKeys.passiveIncomeBackKey.currentContext;
          if (currentCtx != null && currentCtx.mounted) {
            Navigator.pop(currentCtx);
          }
        },
      ),
      TutorialStep(
        title: "Asset Management",
        description:
            "Real estate assets grow your net worth and unlock passive income. Tap the Assets tile.",
        targetKey: TutorialKeys.assetsTileKey,
        type: TutorialStepType.interactive,
        action: () async {
          final BuildContext? currentCtx =
              TutorialKeys.assetsTileKey.currentContext;
          if (currentCtx != null && currentCtx.mounted) {
            Navigator.push(
              currentCtx,
              MaterialPageRoute(
                builder: (_) => AssetsScreen(
                  assets: widget.game.assets,
                  gems: widget.game.gems,
                  streak: widget.game.dailyQuizStreak,
                  onBuyAsset: (type) =>
                      widget.game.buyAsset(type, 1, currentCtx),
                  onSellAsset: (type) => widget.game.sellAsset(type),
                  sfx: widget.sfx,
                  game: widget.game,
                ),
              ),
            );
          }
        },
      ),
      TutorialStep(
        title: "Assets Screen",
        description:
            "Here you can buy properties (like Residential, Commercial, or Industrial). They can also be sold for quick Gems.",
        targetKey: TutorialKeys.assetsBodyKey,
      ),
      TutorialStep(
        title: "Return to HQ",
        description: "Tap the Back button to return to the Money tab.",
        targetKey: TutorialKeys.assetsBackKey,
        type: TutorialStepType.backNavigation,
        action: () async {
          final BuildContext? currentCtx =
              TutorialKeys.assetsBackKey.currentContext;
          if (currentCtx != null && currentCtx.mounted) {
            Navigator.pop(currentCtx);
          }
        },
      ),
      TutorialStep(
        title: "Liabilities & Lifestyle",
        description:
            "Liabilities are your daily expenses. Tap the Liabilities tile to open it.",
        targetKey: TutorialKeys.liabilitiesTileKey,
        type: TutorialStepType.interactive,
        action: () async {
          final BuildContext? currentCtx =
              TutorialKeys.liabilitiesTileKey.currentContext;
          if (currentCtx != null && currentCtx.mounted) {
            Navigator.push(
              currentCtx,
              MaterialPageRoute(
                builder: (_) => LiabilitiesScreen(
                  game: widget.game,
                  currentRent: widget.game.rentChoice,
                  currentFood: widget.game.foodChoice,
                  currentTransport: widget.game.transportChoice,
                  onSelectionChanged: widget.game.updateLiabilities,
                  sfx: widget.sfx,
                ),
              ),
            );
          }
        },
      ),
      TutorialStep(
        title: "Choose Your Rent",
        description:
            "You must choose a Rent option first. Select a Rent plan directly from the card below to continue.",
        targetKey: TutorialKeys.liabilitiesRentKey,
        type: TutorialStepType.interactive,
        allowDirectTap: true,
        canProgress: (game) => game.rentChoice != null,
      ),
      TutorialStep(
        title: "Choose Your Food",
        description:
            "Next, select a Food plan from the options below. Food choice affects daily KP gains and Gem expenses.",
        targetKey: TutorialKeys.liabilitiesFoodKey,
        type: TutorialStepType.interactive,
        allowDirectTap: true,
        canProgress: (game) => game.foodChoice != null,
      ),
      TutorialStep(
        title: "Choose Your Transport",
        description:
            "Finally, select a Transport option. Better transport options yield KP but cost more Gems daily.",
        targetKey: TutorialKeys.liabilitiesTransportKey,
        type: TutorialStepType.interactive,
        allowDirectTap: true,
        canProgress: (game) => game.transportChoice != null,
      ),
      TutorialStep(
        title: "Return to HQ",
        description:
            "Now that your lifestyle settings are configured, tap the Back button.",
        targetKey: TutorialKeys.liabilitiesBackKey,
        type: TutorialStepType.backNavigation,
        action: () async {
          final BuildContext? currentCtx =
              TutorialKeys.liabilitiesBackKey.currentContext;
          if (currentCtx != null && currentCtx.mounted) {
            Navigator.pop(currentCtx);
          }
        },
      ),
      TutorialStep(
        title: "Financial Quizzes",
        description:
            "Quizzes test your knowledge. Tap the Quiz tile to open the Quiz Menu.",
        targetKey: TutorialKeys.quizTileKey,
        type: TutorialStepType.interactive,
        action: () async {
          final BuildContext? currentCtx =
              TutorialKeys.quizTileKey.currentContext;
          if (currentCtx != null && currentCtx.mounted) {
            Navigator.push(
              currentCtx,
              MaterialPageRoute(
                builder: (_) => QuizMenuScreen(
                  game: widget.game,
                  music: widget.game.musicManager!,
                  sfx: widget.sfx,
                ),
              ),
            );
          }
        },
      ),
      TutorialStep(
        title: "Daily Challenge",
        description:
            "Complete the daily quiz challenge to earn KP and maintain your daily streak!",
        targetKey: TutorialKeys.quizDailyPanelKey,
      ),
      TutorialStep(
        title: "Return to HQ",
        description: "Tap the Back button to return to the Money tab.",
        targetKey: TutorialKeys.quizBackKey,
        type: TutorialStepType.backNavigation,
        action: () async {
          final BuildContext? currentCtx =
              TutorialKeys.quizBackKey.currentContext;
          if (currentCtx != null && currentCtx.mounted) {
            Navigator.pop(currentCtx);
          }
        },
      ),
      TutorialStep(
        title: "App Settings",
        description:
            "Let's view the Settings tab. Tap the Settings icon below.",
        targetKey: TutorialKeys.tabSettingsKey,
        type: TutorialStepType.interactive,
        action: () async {
          widget.game.selectedIndex = 3;
        },
      ),
      TutorialStep(
        title: "Settings Menu",
        description:
            "Here you can customize your player name, set the time for your daily quiz reminders, toggle dark mode, or adjust volume.",
        targetKey: TutorialKeys.settingsBodyKey,
      ),
      TutorialStep(
        title: "Ready to Build Wealth!",
        description:
            "Congratulations! You have completed the tutorial. You can read the 'Player Manual' in settings to understand the game better. Make wise choices and enjoy your journey!",
      ),
    ];

    widget.game.onTutorialBackStepTriggered = () {
      if (mounted && currentStep.isBackStep) {
        _handleInteractiveStep();
      }
    };

    widget.game.onBackGestureIntercepted = () {
      if (mounted) {
        _showExitConfirmationDialog();
      }
    };

    _updateBackNavigationPermission();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshTargetRect();
    });
  }

  @override
  void dispose() {
    widget.game.removeListener(_onGameStateChanged);
    widget.game.onTutorialBackStepTriggered = null;
    widget.game.onBackGestureIntercepted = null;
    widget.game.isTutorialBackAllowed = false;
    _arrowController.dispose();
    super.dispose();
  }

  void _onGameStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _updateBackNavigationPermission() {
    widget.game.isTutorialBackAllowed = currentStep.isBackStep;
  }

  Future<void> _refreshTargetRect() async {
    final key = currentStep.targetKey;

    if (key == null) {
      if (mounted) {
        setState(() {
          _targetRect = null;
        });
      }
      return;
    }

    await Future.delayed(const Duration(milliseconds: 120));

    if (!mounted) return;

    final ctx = key.currentContext;
    if (ctx == null || !ctx.mounted) return;

    final renderObject = ctx.findRenderObject();
    if (renderObject is! RenderBox) return;

    if (!renderObject.attached || !renderObject.hasSize) return;

    final offset = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;

    if (!mounted) return;

    setState(() {
      _targetRect = Rect.fromLTWH(
        offset.dx - 6,
        offset.dy - 6,
        size.width + 12,
        size.height + 12,
      );
    });
  }

  Future<void> _nextStep() async {
    // Back-navigation steps need to pop first, then advance.
    if (currentStep.isBackStep) {
      await _handleInteractiveStep();
      return;
    }

    // Pure interactive steps (tap target) are driven by the target itself.
    if (currentStep.isInteractive && !currentStep.allowDirectTap) {
      return;
    }

    widget.sfx.playClick();

    if (_currentStep >= _steps.length - 1) {
      _finishTutorial();
      return;
    }

    setState(() {
      _currentStep++;
      _updateBackNavigationPermission();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshTargetRect();
    });
  }

  Future<void> _handleInteractiveStep() async {
    final action = currentStep.action;

    if (action != null) {
      widget.sfx.playClick();
      await action();
      await Future.delayed(const Duration(milliseconds: 350));
    }

    if (!mounted) return;

    if (_currentStep >= _steps.length - 1) {
      _finishTutorial();
      return;
    }

    setState(() {
      _currentStep++;
      _updateBackNavigationPermission();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshTargetRect();
    });
  }

  void _finishTutorial() {
    widget.sfx.playLevelUp();
    widget.game.completeTutorial();
    widget.onComplete();
  }

  void _showExitConfirmationDialog() {
    widget.sfx.playClick();
    setState(() {
      _showExitDialog = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = currentStep;
    final rect = _targetRect;
    final screenSize = MediaQuery.of(context).size;
    final bool canProgress =
        step.canProgress == null || step.canProgress!(widget.game);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: step.isInteractive ? null : _nextStep,
            child: ClipPath(
              clipper: SpotlightClipper(rect),
              child: Container(color: Colors.black.withValues(alpha: 0.78)),
            ),
          ),

          // Spotlight rect — transparent cutout, no border/glow.
          if (rect != null && step.isInteractive && !step.allowDirectTap)
            Positioned.fromRect(
              rect: rect,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _handleInteractiveStep,
                child: Container(color: Colors.transparent),
              ),
            ),

          if (rect != null && !step.isFullScreenHighlight)
            AnimatedBuilder(
              animation: _arrowAnimation,
              builder: (_, __) {
                final isTopHalf = rect.top < screenSize.height / 2;
                final top = isTopHalf
                    ? rect.bottom + 12 + _arrowAnimation.value
                    : rect.top - 56 - _arrowAnimation.value;

                return Positioned(
                  left: rect.center.dx - 20,
                  top: top,
                  child: IgnorePointer(
                    child: Icon(
                      isTopHalf
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 42,
                      color: Colors.amberAccent,
                      shadows: const [
                        Shadow(blurRadius: 10, color: Colors.black87),
                      ],
                    ),
                  ),
                );
              },
            ),

          Positioned(
            left: 20,
            right: 20,
            top: rect != null && rect.top > screenSize.height / 2 ? 80 : null,
            bottom: rect == null || rect.top <= screenSize.height / 2
                ? 100
                : null,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Container(
                key: ValueKey(_currentStep),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.amber, width: 1.4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Step ${_currentStep + 1}/${_steps.length}",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            step.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    IconText(
                      step.description,
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.45,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep == 0)
                          TextButton(
                            onPressed: _showExitConfirmationDialog,
                            child: Text(
                              "Skip Tutorial",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Text(
                            step.isInteractive
                                ? (step.allowDirectTap
                                      ? (canProgress
                                            ? "Tap Next to "
                                            : "Make selection below")
                                      : "Tap highlighted area")
                                : "Tap anywhere to continue",
                            style: TextStyle(
                              fontSize: 11.5,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ElevatedButton(
                          onPressed: canProgress
                              ? ((step.isInteractive && !step.allowDirectTap)
                                    ? _handleInteractiveStep
                                    : _nextStep)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _currentStep == _steps.length - 1
                                ? "Finish"
                                : (step.isInteractive && !step.allowDirectTap)
                                ? "Guide Me"
                                : "Next",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_showExitDialog)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 28),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.amber,
                          size: 40,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Exit Tutorial?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "You can restart the tutorial later from settings.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _showExitDialog = false;
                                });
                              },
                              child: const Text("Resume"),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _finishTutorial,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black87,
                              ),
                              child: const Text("Exit"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SpotlightClipper extends CustomClipper<Path> {
  final Rect? rect;

  SpotlightClipper(this.rect);

  @override
  Path getClip(Size size) {
    final background = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (rect == null) {
      return background;
    }

    final hole = Path()
      ..addRRect(RRect.fromRectAndRadius(rect!, const Radius.circular(16)));

    return Path.combine(PathOperation.difference, background, hole);
  }

  @override
  bool shouldReclip(covariant SpotlightClipper oldClipper) {
    return rect != oldClipper.rect;
  }
}
