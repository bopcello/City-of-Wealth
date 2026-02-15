import 'package:flutter/material.dart';
import '../game_state.dart';

class SettingsTab extends StatelessWidget {
  final CareerState career;
  final bool isDarkMode;
  final double musicVolume;
  final double sfxVolume;
  final void Function(bool) onThemeToggle;
  final void Function(double) onMusicVolumeChanged;
  final void Function(double) onSfxVolumeChanged;

  const SettingsTab({
    super.key,
    required this.career,
    required this.isDarkMode,
    required this.musicVolume,
    required this.sfxVolume,
    required this.onThemeToggle,
    required this.onMusicVolumeChanged,
    required this.onSfxVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Settings",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text("Dark Theme"),
            subtitle: const Text("Switch between light and dark mode"),
            value: isDarkMode,
            onChanged: onThemeToggle,
            secondary: const Icon(Icons.brightness_4),
          ),
          const SizedBox(height: 16),
          const Text("Audio Settings", style: TextStyle(color: Colors.grey)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text("Music Volume"),
            subtitle: Slider(
              value: musicVolume,
              onChanged: onMusicVolumeChanged,
              min: 0.0,
              max: 1.0,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text("Sound Effects Volume"),
            subtitle: Slider(
              value: sfxVolume,
              onChanged: onSfxVolumeChanged,
              min: 0.0,
              max: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
