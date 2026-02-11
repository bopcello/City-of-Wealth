import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

/// Manages background music playback with simple infinite looping.
class MusicManager {
  final AudioPlayer _player = AudioPlayer();
  bool _isDisposed = false;
  String? _currentTrack;

  MusicManager() {
    // audioplayers 6.x defaults prefix to 'assets/'.
    // Since our assets are in 'lib/assets/', we set prefix to empty.
    _player.audioCache.prefix = '';

    // Enable infinite looping and set appropriate mode for music
    _player.setReleaseMode(ReleaseMode.loop);
    _player.setPlayerMode(PlayerMode.mediaPlayer);

    // Configure AudioContext safely to allow mixing Music and SFX
    try {
      AudioPlayer.global.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.none, // Allow parallel playback
          ),
          iOS: AudioContextIOS(
            category:
                AVAudioSessionCategory.playback, // Required for mixWithOthers
            options: {
              AVAudioSessionOptions.mixWithOthers,
              AVAudioSessionOptions.duckOthers,
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint('[MUSIC_SYSTEM] AudioContext error: $e');
    }
  }

  /// Play home background music
  Future<void> playHomeMusic() async {
    if (_isDisposed) return;
    await _playTrack('lib/assets/music/Home_music.mp3');
  }

  /// Play quiz background music
  Future<void> playQuizMusic() async {
    if (_isDisposed) return;
    await _playTrack('lib/assets/music/Quiz_music.mp3');
  }

  /// Stop all music
  Future<void> stopAllMusic() async {
    await _player.stop();
    _currentTrack = null;
  }

  /// Pause music playback
  Future<void> pauseMusic() async {
    if (_isDisposed) return;
    await _player.pause();
    debugPrint('[MUSIC_SYSTEM] Playback paused');
  }

  /// Resume music playback
  Future<void> resumeMusic() async {
    if (_isDisposed) return;
    if (_currentTrack != null) {
      await _player.resume();
      debugPrint('[MUSIC_SYSTEM] Playback resumed');
    }
  }

  /// Set music volume (0.0 to 1.0)
  void setVolume(double volume) {
    _player.setVolume(volume);
  }

  /// Internal method to play a track with infinite loop
  Future<void> _playTrack(String assetPath) async {
    if (_isDisposed) return;
    if (_currentTrack == assetPath) return;

    debugPrint('[MUSIC_SYSTEM] Switching to track: $assetPath');
    _currentTrack = assetPath;

    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
      debugPrint('[MUSIC_SYSTEM] Playback started');
    } catch (e) {
      debugPrint('[MUSIC_SYSTEM] Playback error: $e');
    }
  }

  /// Dispose of the audio player
  Future<void> dispose() async {
    _isDisposed = true;
    await _player.dispose();
  }
}
