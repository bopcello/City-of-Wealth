import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Manages sound effects (SFX) playback.
class SfxManager {
  final List<AudioPlayer> _pool = [];
  final int _poolSize = 4;
  int _poolIndex = 0;
  double _volume = 1.0;
  bool _isDisposed = false;

  SfxManager() {
    // Initialize a pool of players with low latency mode
    for (int i = 0; i < _poolSize; i++) {
      final player = AudioPlayer();
      player.audioCache.prefix = '';
      // lowLatency mode is crucial for Windows/Desktop performance and mixability
      player.setPlayerMode(PlayerMode.lowLatency);
      _pool.add(player);
    }
  }

  /// Update SFX volume (0.0 to 1.0)
  void setVolume(double volume) {
    _volume = volume;
    for (final player in _pool) {
      player.setVolume(volume);
    }
  }

  Future<void> playClick() => _playSound('lib/assets/music/Click.mp3');
  Future<void> playBack() => _playSound('lib/assets/music/Back.mp3');
  Future<void> playCorrect() => _playSound('lib/assets/music/Correct.mp3');
  Future<void> playIncorrect() => _playSound('lib/assets/music/Incorrect.mp3');
  Future<void> playBuy() => _playSound('lib/assets/music/Buy.mp3');
  Future<void> playSell() => _playSound('lib/assets/music/Sell.mp3');
  Future<void> playLevelUp() => _playSound('lib/assets/music/Level_up.mp3');
  Future<void> playDisaster() => _playSound('lib/assets/music/Disaster.mp3');

  Future<void> _playSound(String assetPath) async {
    if (_isDisposed) return;
    try {
      // Rotate through the pool to allow overlapping sounds
      final player = _pool[_poolIndex];
      _poolIndex = (_poolIndex + 1) % _poolSize;

      // Ensure volume is synced
      await player.setVolume(_volume);
      // Reset player to ensure it can play again (crucial for some platforms in lowLatency mode)
      await player.stop();
      // Play source
      await player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('[SFX_SYSTEM] Error playing $assetPath: $e');
    }
  }

  void dispose() {
    _isDisposed = true;
    for (final player in _pool) {
      player.dispose();
    }
    _pool.clear();
  }
}
