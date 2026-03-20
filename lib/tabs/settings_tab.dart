import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../game_state.dart';

class SettingsTab extends StatelessWidget {
  final CareerState career;
  final bool isDarkMode;
  final double musicVolume;
  final double sfxVolume;
  final void Function(bool) onThemeToggle;
  final void Function(double, {bool saveToDisk}) onMusicVolumeChanged;
  final void Function(double, {bool saveToDisk}) onSfxVolumeChanged;

  const SettingsTab({
    super.key,
    required this.career,
    required this.isDarkMode,
    required this.musicVolume,
    required this.sfxVolume,
    required this.onThemeToggle,
    required this.onMusicVolumeChanged,
    required this.onSfxVolumeChanged,
    required this.onCloudSync,
  });

  final VoidCallback onCloudSync;

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
              onChanged: (val) => onMusicVolumeChanged(val, saveToDisk: false),
              onChangeEnd: (val) => onMusicVolumeChanged(val, saveToDisk: true),
              min: 0.0,
              max: 1.0,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.volume_up),
            title: const Text("Sound Effects Volume"),
            subtitle: Slider(
              value: sfxVolume,
              onChanged: (val) => onSfxVolumeChanged(val, saveToDisk: false),
              onChangeEnd: (val) => onSfxVolumeChanged(val, saveToDisk: true),
              min: 0.0,
              max: 1.0,
            ),
          ),
          const SizedBox(height: 32),
          const Text("Cloud Progress", style: TextStyle(color: Colors.grey)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cloud_sync, color: Colors.blue),
            title: const Text("Sync with Cloud"),
            subtitle: const Text("Manually sync your progress with the cloud"),
            onTap: onCloudSync,
          ),
          const SizedBox(height: 32),
          const Text("Account", style: TextStyle(color: Colors.grey)),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red.shade400),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            subtitle: const Text("Sign out of your account"),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      child: const Text("Logout"),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await AuthService().signOut();
              }
            },
          ),
        ],
      ),
    );
  }
}
