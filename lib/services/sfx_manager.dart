import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

/// Manages sound effects (SFX) playback using dedicated players to prevent decoder churn.
class SfxManager {
  static final SfxManager _instance = SfxManager._internal();
  factory SfxManager() => _instance;

  final Map<String, AudioPlayer> _players = {};
  double _volume = 1.0;
  bool _isDisposed = false;

  final Map<String, Source> _cachedSources = {};

  SfxManager._internal() {
    final sfxFiles = [
      'lib/assets/music/Click.mp3',
      'lib/assets/music/Back.mp3',
      'lib/assets/music/Correct.mp3',
      'lib/assets/music/Incorrect.mp3',
      'lib/assets/music/Buy.mp3',
      'lib/assets/music/Sell.mp3',
      'lib/assets/music/Level_up.mp3',
      'lib/assets/music/Disaster.mp3',
    ];
    for (final path in sfxFiles) {
      final player = AudioPlayer();
      player.audioCache.prefix = '';
      player.setPlayerMode(PlayerMode.lowLatency);
      player.setReleaseMode(ReleaseMode.stop);
      _players[path] = player;
    }
    _preloadSfx();
  }

  Future<void> _preloadSfx() async {
    final cache = AudioCache(prefix: '');
    for (final path in _players.keys) {
      try {
        final uri = await cache.load(path);
        final source = DeviceFileSource(uri.path);
        _cachedSources[path] = source;
        await _players[path]?.setSource(source);
      } catch (e) {
        debugPrint('[SFX_SYSTEM] Error preloading $path: $e');
        final source = AssetSource(path);
        _cachedSources[path] = source;
        await _players[path]?.setSource(source).catchError((_) {});
      }
    }
  }

  /// Update SFX volume (0.0 to 1.0)
  void setVolume(double volume) {
    _volume = volume;
    for (final player in _players.values) {
      player.setVolume(volume);
    }
  }

  void playClick() => _playSound('lib/assets/music/Click.mp3');
  void playBack() => _playSound('lib/assets/music/Back.mp3');
  void playCorrect() => _playSound('lib/assets/music/Correct.mp3');
  void playIncorrect() => _playSound('lib/assets/music/Incorrect.mp3');
  void playBuy() => _playSound('lib/assets/music/Buy.mp3');
  void playSell() => _playSound('lib/assets/music/Sell.mp3');
  void playLevelUp() => _playSound('lib/assets/music/Level_up.mp3');
  void playDisaster() => _playSound('lib/assets/music/Disaster.mp3');

  Future<void> _playSound(String assetPath) async {
    if (_isDisposed) return;
    try {
      final player = _players[assetPath];
      if (player == null) return;

      player.setVolume(_volume);

      if (player.state == PlayerState.playing) {
        await player.stop();
      }

      final source = _cachedSources[assetPath] ?? AssetSource(assetPath);
      await player.play(source);
    } catch (e) {
      debugPrint('[SFX_SYSTEM] Error playing $assetPath: $e');
    }
  }

  void dispose() {
    _isDisposed = true;
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}

/// A NavigatorObserver that plays a 'back' sound whenever a route is popped.
class SfxNavigatorObserver extends NavigatorObserver {
  final SfxManager sfx;

  SfxNavigatorObserver(this.sfx);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name != 'mute_back_sound') {
      sfx.playBack();
    }
  }
}
