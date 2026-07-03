import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'game_state.dart';
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

  final launchPrefs = await _LaunchPreferences.load();

  runApp(
    CityOfWealthApp(
      initialMusicVolume: launchPrefs.musicVolume,
      initialSfxVolume: launchPrefs.sfxVolume,
      initialIsDarkMode: launchPrefs.isDarkMode,
    ),
  );
}

class _LaunchPreferences {
  const _LaunchPreferences({
    required this.musicVolume,
    required this.sfxVolume,
    required this.isDarkMode,
  });

  final double musicVolume;
  final double sfxVolume;
  final bool isDarkMode;

  static Future<_LaunchPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    final latestScopedPrefix = _findLatestScopedPrefix(prefs);

    double readDouble(String key, double fallback) {
      return prefs.getDouble(key) ??
          (latestScopedPrefix != null
              ? prefs.getDouble('${latestScopedPrefix}_$key')
              : null) ??
          fallback;
    }

    bool readBool(String key, bool fallback) {
      return prefs.getBool(key) ??
          (latestScopedPrefix != null
              ? prefs.getBool('${latestScopedPrefix}_$key')
              : null) ??
          fallback;
    }

    return _LaunchPreferences(
      musicVolume: readDouble(musicVolumeKey, 0.7),
      sfxVolume: readDouble(sfxVolumeKey, 1.0),
      isDarkMode: readBool(isDarkModeKey, false),
    );
  }

  static String? _findLatestScopedPrefix(SharedPreferences prefs) {
    final suffix = '_$lastUpdatedKey';
    String? latestPrefix;
    var latestUpdated = -1;

    for (final key in prefs.getKeys()) {
      if (!key.endsWith(suffix)) continue;
      final updatedAt = prefs.getInt(key);
      if (updatedAt == null || updatedAt <= latestUpdated) continue;
      latestUpdated = updatedAt;
      latestPrefix = key.substring(0, key.length - suffix.length);
    }

    return latestPrefix;
  }
}

class CityOfWealthApp extends StatefulWidget {
  final double initialMusicVolume;
  final double initialSfxVolume;
  final bool initialIsDarkMode;

  const CityOfWealthApp({
    super.key,
    required this.initialMusicVolume,
    required this.initialSfxVolume,
    required this.initialIsDarkMode,
  });

  @override
  State<CityOfWealthApp> createState() => _CityOfWealthAppState();
}

class _CityOfWealthAppState extends State<CityOfWealthApp> {
  GameManager? _game;
  late final MusicManager _music;
  final SfxManager _sfx = SfxManager();
  // Initialised from SharedPreferences before runApp — correct on first frame
  late bool _isDarkMode;
  Object? _bootstrapError;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialIsDarkMode;

    _music = MusicManager(initialVolume: widget.initialMusicVolume);
    _music.setVolume(widget.initialMusicVolume);
    _sfx.setVolume(widget.initialSfxVolume);
    _bootstrapApp();
  }

  void _syncVolume() {
    final game = _game;
    if (game == null) return;
    _music.setVolume(game.musicVolume);
    _sfx.setVolume(game.sfxVolume);
  }

  void _handleGameThemeChange() {
    final game = _game;
    if (game != null && _isDarkMode != game.isDarkMode) {
      setState(() {
        _isDarkMode = game.isDarkMode;
      });
    }
  }

  Future<void> _bootstrapApp() async {
    if (mounted) {
      setState(() {
        _bootstrapError = null;
      });
    }

    try {
      await Future.wait([
        Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
        BackgroundTaskManager.initialize(),
      ]);

      BackgroundTaskManager.scheduleTasks().ignore();
      NotificationService().initialize().ignore();

      final game = GameManager();
      game.attachMusicManager(_music);
      game.addListener(_syncVolume);
      game.addListener(_handleGameThemeChange);

      if (!mounted) {
        game.removeListener(_syncVolume);
        game.removeListener(_handleGameThemeChange);
        game.dispose();
        return;
      }

      setState(() {
        _game = game;
        _bootstrapError = null;
      });

      _music.playHomeMusic();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _bootstrapError = error;
      });
    }
  }

  @override
  void dispose() {
    _game?.removeListener(_syncVolume);
    _game?.removeListener(_handleGameThemeChange);
    _game?.dispose();
    _music.dispose();
    _sfx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      navigatorObservers: [SfxNavigatorObserver(_sfx)],
      home: _buildHome(),
    );
  }

  Widget _buildHome() {
    if (_bootstrapError != null) {
      return BootstrapErrorScreen(onRetry: _bootstrapApp);
    }

    final game = _game;
    if (game == null) {
      return const LoadingScreen(progress: 0.05);
    }

    return AuthWrapper(game: game, music: _music, sfx: _sfx);
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
            final authWaiting =
                snapshot.connectionState == ConnectionState.waiting;
            final hasUser = snapshot.hasData;
            final showOverlay = (hasUser && _showLoader) || authWaiting;

            return Stack(
              children: [
                // Underlying UI (Loaded in the background)
                if (!authWaiting)
                  hasUser
                      ? (widget.game.onboardingComplete
                            ? MainScreen(
                                game: widget.game,
                                music: widget.music,
                                sfx: widget.sfx,
                              )
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

class BootstrapErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const BootstrapErrorScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.of(context, 'background'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Unable to start City of Wealth',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.of(context, 'onBackground'),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Please check your connection and try again.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.of(context, 'onSurfaceVariant'),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}
