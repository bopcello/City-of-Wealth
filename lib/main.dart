import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'logic/game_manager.dart';
import 'logic/background_tasks.dart';
import 'services/music_manager.dart';
import 'services/sfx_manager.dart';
import 'services/sfx_navigator_observer.dart';
import 'services/notification_service.dart';
import 'widgets/auth_wrapper.dart';
import 'theme/app_colors.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initialize();

  // Load volume preferences early before starting the app
  final prefs = await SharedPreferences.getInstance();
  final initialMusicVolume = prefs.getDouble('musicVolume') ?? 0.7;
  final initialSfxVolume = prefs.getDouble('sfxVolume') ?? 1.0;

  // Initialize and schedule background tasks
  await BackgroundTaskManager.initialize();
  await BackgroundTaskManager.scheduleTasks();

  runApp(CityOfWealthApp(
    initialMusicVolume: initialMusicVolume,
    initialSfxVolume: initialSfxVolume,
  ));
}

class CityOfWealthApp extends StatefulWidget {
  final double initialMusicVolume;
  final double initialSfxVolume;

  const CityOfWealthApp({
    super.key,
    required this.initialMusicVolume,
    required this.initialSfxVolume,
  });

  @override
  State<CityOfWealthApp> createState() => _CityOfWealthAppState();
}

class _CityOfWealthAppState extends State<CityOfWealthApp> {
  final GameManager game = GameManager();
  late final MusicManager music;
  final SfxManager sfx = SfxManager();
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = game.isDarkMode;

    // Create MusicManager with the saved volume baked in from the start
    music = MusicManager(initialVolume: widget.initialMusicVolume);

    // Apply preloaded volume settings immediately
    music.setVolume(widget.initialMusicVolume);
    sfx.setVolume(widget.initialSfxVolume);

    // Start music after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      music.playHomeMusic();
      NotificationService().scheduleInactivityNotification(game.playerName);
    });

    // Attach music manager to game manager for unified lifecycle handling
    game.attachMusicManager(music);

    // Initial volume apply after load
    game.addListener(_syncVolume);
    game.addListener(_handleGameThemeChange);
  }

  void _syncVolume() {
    music.setVolume(game.musicVolume);
    sfx.setVolume(game.sfxVolume);
  }

  void _handleGameThemeChange() {
    if (_isDarkMode != game.isDarkMode) {
      setState(() {
        _isDarkMode = game.isDarkMode;
      });
    }
  }

  @override
  void dispose() {
    game.removeListener(_syncVolume);
    game.removeListener(_handleGameThemeChange);
    game.dispose();
    music.dispose();
    sfx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      navigatorObservers: [SfxNavigatorObserver(sfx)],
      home: AuthWrapper(game: game, music: music, sfx: sfx),
    );
  }
}
