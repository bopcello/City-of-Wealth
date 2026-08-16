import '../logic/game_manager.dart';

class CitySessionManager {
  static final CitySessionManager _instance = CitySessionManager._internal();
  factory CitySessionManager() => _instance;
  CitySessionManager._internal();

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

    await game.syncWithCloud(force: true);
  }
}
