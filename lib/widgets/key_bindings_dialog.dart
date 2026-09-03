import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/shortcut_manager_service.dart';
import '../theme/app_colors.dart';

class KeyBindingsDialog extends StatefulWidget {
  final bool isEditable;

  const KeyBindingsDialog({super.key, this.isEditable = true});

  static Future<void> show(BuildContext context, {bool isEditable = true}) {
    return showDialog(
      context: context,
      builder: (context) => KeyBindingsDialog(isEditable: isEditable),
    );
  }

  @override
  State<KeyBindingsDialog> createState() => _KeyBindingsDialogState();
}

class _KeyBindingsDialogState extends State<KeyBindingsDialog> {
  String? _listeningAction;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKeyEvent);
    ShortcutManagerService.instance.setIsEditingKeybindings(false);
    super.dispose();
  }

  void _setListeningAction(String? action) {
    setState(() {
      _listeningAction = action;
      _errorMessage = null;
    });
    ShortcutManagerService.instance.setIsEditingKeybindings(action != null);
  }

  bool _onKeyEvent(KeyEvent event) {
    if (_listeningAction == null) return false;
    if (event is! KeyDownEvent) return false;

    final action = _listeningAction!;
    final key = event.logicalKey;
    final formattedKey = ShortcutManagerService.formatLogicalKey(key);

    // Check for duplicate keybindings
    final conflictAction = ShortcutManagerService.instance.getActionBoundToKey(
      formattedKey,
      key.keyId,
      action,
    );

    if (conflictAction != null) {
      setState(() {
        _errorMessage = "Key \"$formattedKey\" is already assigned to \"$conflictAction\".";
        _listeningAction = null;
      });
      ShortcutManagerService.instance.setIsEditingKeybindings(false);
      return true;
    }

    // Update shortcut binding
    ShortcutManagerService.instance.updateKeybinding(
      action,
      formattedKey,
      key.keyId,
    );

    setState(() {
      _errorMessage = null;
      _listeningAction = null;
    });
    ShortcutManagerService.instance.setIsEditingKeybindings(false);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ShortcutManagerService.instance,
      builder: (context, _) {
        final bindings = ShortcutManagerService.instance.keybindings;

        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.keyboard, color: Colors.amber),
              const SizedBox(width: 10),
              const Text("Key Bindings"),
              const Spacer(),
              if (widget.isEditable)
                TextButton.icon(
                  onPressed: () {
                    ShortcutManagerService.instance.resetToDefaults();
                    _setListeningAction(null);
                  },
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text("Reset Defaults"),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.65,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_errorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.of(context, 'error').withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.of(context, 'error'),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.of(context, 'error'),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.of(context, 'error'),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                size: 18,
                                color: AppColors.of(context, 'error'),
                              ),
                              onPressed: () {
                                setState(() {
                                  _errorMessage = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    if (_listeningAction != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Press any key on your keyboard to bind for \"$_listeningAction\"...",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _setListeningAction(null);
                              },
                              child: const Text("Cancel"),
                            ),
                          ],
                        ),
                      ),
                    ...bindings.entries.map((entry) {
                      final action = entry.key;
                      final keyLabel = entry.value;
                      final isListeningThis = _listeningAction == action;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isListeningThis
                              ? Colors.amber.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isListeningThis
                              ? Border.all(color: Colors.amber, width: 1.5)
                              : null,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 0,
                          ),
                          dense: true,
                          title: Text(
                            action,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isListeningThis
                                  ? Colors.amber
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          trailing: InkWell(
                            onTap: widget.isEditable
                                ? () {
                                    _setListeningAction(action);
                                  }
                                : null,
                            borderRadius: BorderRadius.circular(6),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isListeningThis
                                    ? Colors.amber
                                    : AppColors.of(context, 'outline')
                                        .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isListeningThis
                                      ? Colors.amber
                                      : AppColors.of(context, 'outline'),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                isListeningThis ? "Press Key..." : keyLabel,
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  color: isListeningThis
                                      ? Colors.black
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Done"),
            ),
          ],
        );
      },
    );
  }
}
