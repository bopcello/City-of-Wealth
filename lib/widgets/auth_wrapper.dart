import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../logic/game_manager.dart';
import '../services/music_manager.dart';
import '../services/sfx_manager.dart';
import '../services/auth_service.dart';
import '../screens/loading_screen.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/onboarding_screen.dart';

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
                if (_showLoader || authWaiting)
                  IgnorePointer(
                    ignoring: !_showLoader && !authWaiting,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: (_showLoader || authWaiting) ? 1.0 : 0.0,
                      onEnd: () {
                        // Fully remove if needed, but Stack with if is cleaner
                      },
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
