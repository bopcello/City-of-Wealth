import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

/// Manages background music playback with simple infinite looping.
class MusicManager {
  final AudioPlayer _player = AudioPlayer();
  bool _isDisposed = false;
  String? _currentTrack;
  double _volume;

  MusicManager({double initialVolume = 0.7}) : _volume = initialVolume {
    // Apply saved volume immediately so the player never starts at 1.0
    _player.setVolume(_volume);

    // prefix is empty since we use lib/assets/...
    _player.audioCache.prefix = '';

    // Use native looping for background music.
    _player.setReleaseMode(ReleaseMode.loop);
    _player.setPlayerMode(PlayerMode.mediaPlayer);

    // Configure AudioContext safely to allow mixing Music and SFX
    try {
      AudioPlayer.global.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain, // Request focus for music
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: {AVAudioSessionOptions.mixWithOthers},
          ),
        ),
      );
    } catch (e) {
      debugPrint('[MUSIC_SYSTEM] AudioContext error: $e');
    }
  }

  /// Play home background music
  void playHomeMusic() {
    if (_isDisposed) return;
    _playTrack('lib/assets/music/Home_music.mp3');
  }

  /// Play quiz background music
  void playQuizMusic() {
    if (_isDisposed) return;
    _playTrack('lib/assets/music/Quiz_music.mp3');
  }

  /// Stop all music
  void stopAllMusic() {
    _player.stop();
    _currentTrack = null;
  }

  /// Pause music playback
  void pauseMusic() {
    if (_isDisposed) return;
    _player.pause();
    debugPrint('[MUSIC_SYSTEM] Playback paused');
  }

  /// Resume music playback
  void resumeMusic() {
    if (_isDisposed) return;
    if (_currentTrack != null) {
      _player.resume();
      debugPrint('[MUSIC_SYSTEM] Playback resumed');
    }
  }

  /// Set music volume (0.0 to 1.0)
  void setVolume(double volume) {
    _volume = volume;
    _player.setVolume(volume);
  }

  /// Internal method to play a track with infinite loop
  Future<void> _playTrack(String assetPath) async {
    if (_isDisposed) return;
    if (_currentTrack == assetPath) return;

    debugPrint('[MUSIC_SYSTEM] Switching to track: $assetPath');
    _currentTrack = assetPath;

    try {
      await _player.play(AssetSource(assetPath));
      // Re-apply volume after play — Android can reset it on track switch
      await _player.setVolume(_volume);
      debugPrint('[MUSIC_SYSTEM] Playback started (vol=$_volume)');
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
