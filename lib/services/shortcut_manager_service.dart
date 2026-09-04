import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SidebarAutoMode { onHover, onHover2s, disabled }

class ShortcutManagerService extends ChangeNotifier {
  static final ShortcutManagerService instance = ShortcutManagerService._();
  ShortcutManagerService._();

  static const String _prefKey = 'custom_keybindings_v1';
  static const String _overlayVisibilityPrefKey = 'shortcut_overlay_visibility_v1';
  static const String _sidebarAutoModePrefKey = 'sidebar_auto_mode_v1';

  SidebarAutoMode _sidebarAutoMode = SidebarAutoMode.onHover2s;
  SidebarAutoMode get sidebarAutoMode => _sidebarAutoMode;

  bool _isKeyboardDetected = false;
  bool get isKeyboardDetected => _isKeyboardDetected;

  bool _isEditingKeybindings = false;
  bool get isEditingKeybindings => _isEditingKeybindings;

  void setIsEditingKeybindings(bool value) {
    _isEditingKeybindings = value;
    notifyListeners();
  }

  bool _isQuizActive = false;
  bool get isQuizActive => _isQuizActive;

  void setQuizActive(bool value) {
    _isQuizActive = value;
    notifyListeners();
  }

  // Per-screen overlay visibility map (screenId -> bool)
  final Map<String, bool> _screenOverlayVisibility = {};

  final ValueNotifier<String?> lastTriggeredAction = ValueNotifier<String?>(null);

  static final Map<String, String> _defaultKeybindings = {
    'Home': 'F1',
    'City': 'F2',
    'Money': 'F3',
    'Settings': 'F4',
    'Career [Tile]': '1',
    'Assets [Tile]': '2',
    'Liabilities [Tile]': '3',
    'Passive Income [Tile]': '4',
    'Quiz [Tile]': '5',
    'Build Menu': 'B',
    'Reset Camera': 'R',
    'Quiz Options': '1, 2, 3, 4',
    'Cheat Sheet': 'Ctrl+?',
    'Back / Pop': 'Esc',
    'Confirm / Close': 'Enter',
  };

  // Custom Keybindings dictionary (Action -> Display Label)
  Map<String, String> keybindings = Map.from(_defaultKeybindings);

  // KeyId dictionary for exact keyId matching (Action -> KeyId)
  Map<String, int> keyIdMap = {};

  void initializeOnAppOpen() {
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _isKeyboardDetected = true;
    } else {
      try {
        _isKeyboardDetected =
            HardwareKeyboard.instance.physicalKeysPressed.isNotEmpty;
      } catch (e) {
        _isKeyboardDetected = false;
      }
    }
    loadKeybindings();
    loadOverlayVisibility();
    loadSidebarAutoMode();
  }

  Future<void> setSidebarAutoMode(SidebarAutoMode mode) async {
    _sidebarAutoMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_sidebarAutoModePrefKey, mode.name);
    } catch (e) {
      debugPrint("Error saving sidebar auto mode: $e");
    }
  }

  Future<void> loadSidebarAutoMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeName = prefs.getString(_sidebarAutoModePrefKey);
      if (modeName != null) {
        for (final val in SidebarAutoMode.values) {
          if (val.name == modeName) {
            _sidebarAutoMode = val;
            notifyListeners();
            break;
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading sidebar auto mode: $e");
    }
  }

  void triggerAction(String action) {
    lastTriggeredAction.value = action;
    Future.microtask(() {
      lastTriggeredAction.value = null;
    });
  }

  Future<void> loadKeybindings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefKey);
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        decoded.forEach((key, value) {
          if (value is String) {
            keybindings[key] = value;
          }
        });
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading keybindings: $e");
    }
  }

  Future<void> saveKeybindings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, jsonEncode(keybindings));
    } catch (e) {
      debugPrint("Error saving keybindings: $e");
    }
  }

  Future<void> loadOverlayVisibility() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_overlayVisibilityPrefKey);
      if (jsonStr != null) {
        final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
        _screenOverlayVisibility.clear();
        decoded.forEach((key, value) {
          if (value is bool) {
            _screenOverlayVisibility[key] = value;
          }
        });
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading overlay visibility: $e");
    }
  }

  Future<void> saveOverlayVisibility() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _overlayVisibilityPrefKey,
        jsonEncode(_screenOverlayVisibility),
      );
    } catch (e) {
      debugPrint("Error saving overlay visibility: $e");
    }
  }

  bool shouldShowOverlay(String screenId) {
    if (!_isKeyboardDetected) return false;
    if (_screenOverlayVisibility['__all__'] == false) return false;
    return _screenOverlayVisibility[screenId] ?? true;
  }

  void hideOverlay(String screenId) {
    _screenOverlayVisibility[screenId] = false;
    _screenOverlayVisibility['__all__'] = false;
    saveOverlayVisibility();
    notifyListeners();
  }

  void unhideAllOverlays() {
    _screenOverlayVisibility.clear();
    saveOverlayVisibility();
    notifyListeners();
  }

  String? getActionBoundToKey(String keyLabel, int? keyId, String currentAction) {
    final upperKey = keyLabel.toUpperCase();
    for (final entry in keybindings.entries) {
      if (entry.key == currentAction) continue;
      if (entry.value.toUpperCase() == upperKey) {
        return entry.key;
      }
      if (keyId != null && keyIdMap[entry.key] == keyId) {
        return entry.key;
      }
    }
    return null;
  }

  void updateKeybinding(String action, String keyLabel, [int? keyId]) {
    keybindings[action] = keyLabel;
    if (keyId != null) {
      keyIdMap[action] = keyId;
    } else {
      keyIdMap.remove(action);
    }
    saveKeybindings();
    notifyListeners();
  }

  void resetToDefaults() {
    keybindings = Map.from(_defaultKeybindings);
    keyIdMap.clear();
    saveKeybindings();
    notifyListeners();
  }

  static String formatLogicalKey(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.escape) return 'Esc';
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) return 'Enter';
    if (key == LogicalKeyboardKey.space) return 'Space';
    if (key == LogicalKeyboardKey.tab) return 'Tab';
    if (key == LogicalKeyboardKey.backspace) return 'Backspace';
    if (key == LogicalKeyboardKey.delete) return 'Delete';
    if (key == LogicalKeyboardKey.arrowUp) return 'Up';
    if (key == LogicalKeyboardKey.arrowDown) return 'Down';
    if (key == LogicalKeyboardKey.arrowLeft) return 'Left';
    if (key == LogicalKeyboardKey.arrowRight) return 'Right';
    if (key == LogicalKeyboardKey.digit0 || key == LogicalKeyboardKey.numpad0) return '0';
    if (key == LogicalKeyboardKey.digit1 || key == LogicalKeyboardKey.numpad1) return '1';
    if (key == LogicalKeyboardKey.digit2 || key == LogicalKeyboardKey.numpad2) return '2';
    if (key == LogicalKeyboardKey.digit3 || key == LogicalKeyboardKey.numpad3) return '3';
    if (key == LogicalKeyboardKey.digit4 || key == LogicalKeyboardKey.numpad4) return '4';
    if (key == LogicalKeyboardKey.digit5 || key == LogicalKeyboardKey.numpad5) return '5';
    if (key == LogicalKeyboardKey.digit6 || key == LogicalKeyboardKey.numpad6) return '6';
    if (key == LogicalKeyboardKey.digit7 || key == LogicalKeyboardKey.numpad7) return '7';
    if (key == LogicalKeyboardKey.digit8 || key == LogicalKeyboardKey.numpad8) return '8';
    if (key == LogicalKeyboardKey.digit9 || key == LogicalKeyboardKey.numpad9) return '9';
    if (key.keyLabel.isNotEmpty) return key.keyLabel.toUpperCase();
    return key.debugName ?? 'Key';
  }

  bool isActionKey(String action, LogicalKeyboardKey key) {
    final boundLabel = keybindings[action];
    if (boundLabel == null) return false;

    if (keyIdMap.containsKey(action) && keyIdMap[action] == key.keyId) {
      return true;
    }

    final formatted = formatLogicalKey(key);
    if (formatted.toUpperCase() == boundLabel.toUpperCase()) {
      return true;
    }

    // Default aliases
    if (action == 'Back / Pop' && boundLabel == 'Esc' && key == LogicalKeyboardKey.escape) return true;
    if (action == 'Confirm / Close' && boundLabel == 'Enter' && (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter)) return true;

    return false;
  }
}
