import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'logic/game_manager.dart';
import 'services/music_manager.dart';
import 'services/sfx_manager.dart';
import 'services/sfx_navigator_observer.dart';
import 'services/notification_service.dart';
import 'widgets/auth_wrapper.dart';
import 'theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().initialize();
  runApp(const CityOfWealthApp());
}

class CityOfWealthApp extends StatefulWidget {
  const CityOfWealthApp({super.key});

  @override
  State<CityOfWealthApp> createState() => _CityOfWealthAppState();
}

class _CityOfWealthAppState extends State<CityOfWealthApp> {
  final GameManager game = GameManager();
  final MusicManager music = MusicManager();
  final SfxManager sfx = SfxManager();
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();

    // Start music after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      music.playHomeMusic();
      NotificationService().scheduleInactivityNotification();
    });

    // Listen to app lifecycle to stop/resume music and sync cloud
    _lifecycleListener = AppLifecycleListener(
      onStateChange: (AppLifecycleState state) {
        if (state == AppLifecycleState.paused ||
            state == AppLifecycleState.detached) {
          music.pauseMusic();
          game.syncWithCloud();
        } else if (state == AppLifecycleState.resumed) {
          music.resumeMusic();
        }
      },
    );

    // Initial volume apply after load
    game.addListener(_syncVolume);
  }

  void _syncVolume() {
    music.setVolume(game.musicVolume);
    sfx.setVolume(game.sfxVolume);
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    game.syncWithCloud();
    game.removeListener(_syncVolume);
    game.dispose();
    music.dispose();
    sfx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: game,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppColors.lightTheme,
          darkTheme: AppColors.darkTheme,
          themeMode: game.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          navigatorObservers: [SfxNavigatorObserver(sfx)],
          home: AuthWrapper(game: game, music: music, sfx: sfx),
        );
      },
    );
  }
}
