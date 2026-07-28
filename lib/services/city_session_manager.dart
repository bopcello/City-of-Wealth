import 'package:flutter/foundation.dart';

import '../game_state.dart';
import '../logic/game_manager.dart';
import '../models/city_sharing_models.dart';
import 'firestore_service.dart';

class CitySessionManager {
  static final CitySessionManager _instance = CitySessionManager._internal();
  factory CitySessionManager() => _instance;
  CitySessionManager._internal();

  final FirestoreService _firestoreService = FirestoreService();
  bool _isSessionActive = false;

  bool get isSessionActive => _isSessionActive;

  void notifyEdit(GameManager game) {
    _isSessionActive = game.currentUid != null;
  }

  Future<void> closeSession(GameManager game) async {
    if (!_isSessionActive) return;
    _isSessionActive = false;

    final uid = game.currentUid;
    if (uid == null) return;

    try {
      await _firestoreService.savePublicCitySnapshot(PublicCitySnapshot(
        playerId: uid,
        playerName: game.playerName,
        friendCode: game.friendCode,
        track: game.career.track.name,
        level: game.career.level,
        title: levelName(game.career.track, game.career.level),
        streak: game.dailyQuizStreak,
        kp: game.kp,
        bankruptcyCount: game.bankruptcyCount,
        buildings: game.cityLayout,
        buildingCount: game.cityLayout.length,
        lastUpdatedAt: DateTime.now(),
      ));
    } catch (error) {
      debugPrint('Error saving public city snapshot: $error');
    }
  }
}
