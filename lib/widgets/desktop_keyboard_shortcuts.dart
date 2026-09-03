import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logic/game_manager.dart';
import '../services/shortcut_manager_service.dart';
import '../services/sfx_manager.dart';
import '../services/music_manager.dart';
import '../theme/app_colors.dart';
import '../screens/career_screen.dart';
import '../screens/assets_screen.dart';
import '../screens/liabilities_screen.dart';
import '../screens/passive_income_screen.dart';
import '../screens/quiz_screen.dart';
import 'key_bindings_dialog.dart';

class DesktopKeyboardShortcuts extends StatefulWidget {
  final Widget child;
  final GameManager game;
  final SfxManager sfx;
  final MusicManager music;

  const DesktopKeyboardShortcuts({
    super.key,
    required this.child,
    required this.game,
    required this.sfx,
    required this.music,
  });

  @override
  State<DesktopKeyboardShortcuts> createState() =>
      _DesktopKeyboardShortcutsState();
}

class _DesktopKeyboardShortcutsState extends State<DesktopKeyboardShortcuts> {
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    ShortcutManagerService.instance.initializeOnAppOpen();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _navigateToSubScreen(Widget screen) {
    final rootNav = Navigator.of(context, rootNavigator: true);
    if (rootNav.canPop()) {
      rootNav.pushReplacement(
        MaterialPageRoute(builder: (_) => screen),
      );
    } else {
      rootNav.push(
        MaterialPageRoute(builder: (_) => screen),
      );
    }
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (!mounted) return false;
    if (ShortcutManagerService.instance.isEditingKeybindings) return false;
    if (event is! KeyDownEvent) return false;

    final key = event.logicalKey;
    final isControlPressed = HardwareKeyboard.instance.isControlPressed;
    final shortcuts = ShortcutManagerService.instance;

    // Back / Pop across all screens (works globally regardless of focused widget)
    if (shortcuts.isActionKey('Back / Pop', key)) {
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        widget.sfx.playBack();
        navigator.maybePop();
        return true;
      } else if (widget.game.selectedIndex != 0) {
        widget.sfx.playBack();
        widget.game.selectedIndex = 0;
        return true;
      }
      return false;
    }

    // Check if focused element is a text input field (ignore other shortcuts when typing)
    final primaryFocus = FocusManager.instance.primaryFocus;
    if (primaryFocus != null && primaryFocus.context != null) {
      final widgetType = primaryFocus.context!.widget.runtimeType.toString();
      if (widgetType.contains('EditableText') || widgetType.contains('TextField')) {
        return false;
      }
    }

    // Cheat Sheet
    if (shortcuts.isActionKey('Cheat Sheet', key) ||
        (isControlPressed && key == LogicalKeyboardKey.slash)) {
      _showCheatSheetModal(context);
      return true;
    }

    // Confirm / Close
    if (shortcuts.isActionKey('Confirm / Close', key)) {
      final rootNav = Navigator.of(context, rootNavigator: true);
      if (rootNav.canPop()) {
        widget.sfx.playClick();
        rootNav.maybePop();
        return true;
      }
    }

    // Navigation Tabs
    if (shortcuts.isActionKey('Home', key)) {
      widget.sfx.playClick();
      widget.game.selectedIndex = 0;
      return true;
    }
    if (shortcuts.isActionKey('City', key)) {
      widget.sfx.playClick();
      widget.game.selectedIndex = 1;
      return true;
    }
    if (shortcuts.isActionKey('Money', key)) {
      widget.sfx.playClick();
      widget.game.selectedIndex = 2;
      return true;
    }
    if (shortcuts.isActionKey('Settings', key)) {
      widget.sfx.playClick();
      widget.game.selectedIndex = 3;
      return true;
    }

    // Money Hub Tiles (Only 1 subscreen open at a time above MainScreen)
    if (shortcuts.isActionKey('Career [Tile]', key)) {
      widget.sfx.playClick();
      _navigateToSubScreen(CareerScreen(game: widget.game, sfx: widget.sfx));
      return true;
    }
    if (shortcuts.isActionKey('Assets [Tile]', key)) {
      widget.sfx.playClick();
      _navigateToSubScreen(AssetsScreen(
        assets: widget.game.assets,
        gems: widget.game.gems,
        streak: widget.game.dailyQuizStreak,
        onBuyAsset: (type) => widget.game.buyAsset(type, 1, context),
        onSellAsset: (type) => widget.game.sellAsset(type),
        sfx: widget.sfx,
        game: widget.game,
      ));
      return true;
    }
    if (shortcuts.isActionKey('Liabilities [Tile]', key)) {
      widget.sfx.playClick();
      _navigateToSubScreen(LiabilitiesScreen(
        game: widget.game,
        currentRent: widget.game.rentChoice,
        currentFood: widget.game.foodChoice,
        currentTransport: widget.game.transportChoice,
        onSelectionChanged: widget.game.updateLiabilities,
        sfx: widget.sfx,
      ));
      return true;
    }
    if (shortcuts.isActionKey('Passive Income [Tile]', key)) {
      widget.sfx.playClick();
      _navigateToSubScreen(PassiveIncomeScreen(game: widget.game, sfx: widget.sfx));
      return true;
    }
    if (shortcuts.isActionKey('Quiz [Tile]', key)) {
      widget.sfx.playClick();
      _navigateToSubScreen(QuizMenuScreen(game: widget.game, music: widget.music, sfx: widget.sfx));
      return true;
    }

    // Build Menu
    if (shortcuts.isActionKey('Build Menu', key)) {
      widget.sfx.playClick();
      shortcuts.triggerAction('Build Menu');
      return true;
    }

    // Reset Camera
    if (shortcuts.isActionKey('Reset Camera', key)) {
      widget.sfx.playClick();
      shortcuts.triggerAction('Reset Camera');
      return true;
    }

    // Pause Time
    if (shortcuts.isActionKey('Pause Time', key)) {
      widget.sfx.playClick();
      shortcuts.triggerAction('Pause Time');
      return true;
    }

    return false;
  }

  void _showCheatSheetModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ListenableBuilder(
          listenable: ShortcutManagerService.instance,
          builder: (context, _) {
            final bindings = ShortcutManagerService.instance.keybindings;
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.keyboard, color: Colors.amber),
                  const SizedBox(width: 10),
                  const Text("Keyboard Shortcuts Cheat Sheet"),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    tooltip: "Edit Keybindings",
                    onPressed: () {
                      _showEditBindingsDialog(context);
                    },
                  ),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: bindings.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.of(context, 'outline')
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.of(context, 'outline'),
                                ),
                              ),
                              child: Text(
                                entry.value,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditBindingsDialog(BuildContext context) {
    KeyBindingsDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
