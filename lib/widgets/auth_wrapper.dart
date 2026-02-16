import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../logic/game_manager.dart';
import '../services/music_manager.dart';
import '../services/sfx_manager.dart';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';

class AuthWrapper extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return MainScreen(game: game, music: music, sfx: sfx);
        }
        return const LoginScreen();
      },
    );
  }
}
