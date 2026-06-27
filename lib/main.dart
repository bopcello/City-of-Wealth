import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'logic/game_manager.dart';
import 'logic/background_tasks.dart';
import 'services/music_manager.dart';
import 'services/sfx_manager.dart';
import 'services/notification_service.dart';
import 'theme/app_colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/onboarding_screen.dart';
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

// =============================================================================
// Merged Widgets (< 200 lines) from consolidated files
// =============================================================================

class AuthWrapper extends StatefulWidget {
  final GameManager game;
  final MusicManager music;
  final SfxManager sfx;

  const AuthWrapper({
    super.key,
    required this.game,
    required this.music,
    required this.sfx,
  });

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showLoader = true;

  @override
  void initState() {
    super.initState();
    widget.game.addListener(_checkLoading);
  }

  @override
  void dispose() {
    widget.game.removeListener(_checkLoading);
    super.dispose();
  }

  void _checkLoading() {
    if (widget.game.loaded && _showLoader) {
      // Small delay to ensure the underlying UI has a frame to render with the correct theme
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _showLoader = false;
          });
        }
      });
    } else if (!widget.game.loaded && !_showLoader) {
      // Re-show loader if game is re-loading (e.g. cloud force sync)
      setState(() {
        _showLoader = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.game,
      builder: (context, _) {
        return StreamBuilder<User?>(
          stream: AuthService().authStateChanges,
          builder: (context, snapshot) {
            final authWaiting = snapshot.connectionState == ConnectionState.waiting;
            final hasUser = snapshot.hasData;
            final showOverlay = (hasUser && _showLoader) || authWaiting;
    
            return Stack(
              children: [
                // Underlying UI (Loaded in the background)
                if (!authWaiting)
                  hasUser 
                    ? (widget.game.onboardingComplete 
                        ? MainScreen(game: widget.game, music: widget.music, sfx: widget.sfx)
                        : OnboardingScreen(game: widget.game))
                    : const LoginScreen(),
    
                // Loading Screen Overlay
                IgnorePointer(
                  ignoring: !showOverlay,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: showOverlay ? 1.0 : 0.0,
                    child: ListenableBuilder(
                      listenable: widget.game,
                      builder: (context, _) {
                        // Simulate progress line for the coins
                        // 0.2 when just auth waiting, 0.2 to 1.0 when game loading
                        double p = 0.2;
                        if (!authWaiting && widget.game.loaded) p = 1.0;
                        // We can interpolate if we wanted real progress check, 
                        // but for now, we'll keep it fast as requested.
                        return LoadingScreen(progress: p);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
