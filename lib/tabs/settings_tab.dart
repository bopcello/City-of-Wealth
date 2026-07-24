import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/sfx_manager.dart';
import '../game_state.dart';
import '../logic/game_manager.dart';
import '../services/notification_service.dart';
import '../theme/app_colors.dart';
import '../screens/user_manual_screen.dart';
import '../screens/stats_screen.dart';
import '../logic/tutorial_keys.dart';

class SettingsTab extends StatelessWidget {
  final bool isActive;
  final GameManager game;
  final CareerState career;
  final bool isDarkMode;
  final double musicVolume;
  final double sfxVolume;
  final SfxManager sfx;
  final void Function(bool) onThemeToggle;
  final void Function(double, {bool saveToDisk}) onMusicVolumeChanged;
  final void Function(double, {bool saveToDisk}) onSfxVolumeChanged;
  final VoidCallback onCloudSync;

  const SettingsTab({
    super.key,
    required this.isActive,
    required this.game,
    required this.career,
    required this.isDarkMode,
    required this.musicVolume,
    required this.sfxVolume,
    required this.sfx,
    required this.onThemeToggle,
    required this.onMusicVolumeChanged,
    required this.onSfxVolumeChanged,
    required this.onCloudSync,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColor = AppColors.of(context, 'kp');
    final surfaceVariant = theme.colorScheme.surfaceContainerHighest;
    final outlineColor = theme.colorScheme.outline;

    return SingleChildScrollView(
      key: TutorialKeys.settingsBodyKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, size: 28, color: brandColor),
                const SizedBox(width: 12),
                Text(
                  "Settings",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, "PREFERENCES"),
            Container(
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: outlineColor),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text("Dark Theme"),
                    subtitle: const Text("Easier on the eyes at night"),
                    value: isDarkMode,
                    onChanged: onThemeToggle,
                    secondary: Icon(Icons.brightness_4, color: brandColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, "AUDIO"),
            Container(
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: outlineColor),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.music_note, color: brandColor),
                    title: const Text("Music Volume"),
                    subtitle: Slider(
                      value: musicVolume,
                      activeColor: brandColor,
                      onChanged: (val) =>
                          onMusicVolumeChanged(val, saveToDisk: false),
                      onChangeEnd: (val) =>
                          onMusicVolumeChanged(val, saveToDisk: true),
                      min: 0.0,
                      max: 1.0,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.volume_up, color: brandColor),
                    title: const Text("Sound Effects"),
                    subtitle: Slider(
                      value: sfxVolume,
                      activeColor: brandColor,
                      onChanged: (val) =>
                          onSfxVolumeChanged(val, saveToDisk: false),
                      onChangeEnd: (val) =>
                          onSfxVolumeChanged(val, saveToDisk: true),
                      min: 0.0,
                      max: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, "DATA & BACKUP"),
            Container(
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: outlineColor),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.cloud_done, color: brandColor),
                    title: const Text("Backup Data"),
                    subtitle: const Text("Save progress to your account"),
                    onTap: () {
                      sfx.playClick();
                      onCloudSync();
                    },
                    trailing: Icon(Icons.sync, color: brandColor, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, "NOTIFICATIONS"),
            Container(
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: outlineColor),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.alarm, color: brandColor),
                    title: const Text("Daily Reminder"),
                    subtitle: Text(
                      "Alert at ${TimeOfDay(hour: game.wakeUpHour, minute: game.wakeUpMinute).format(context)}",
                    ),
                    trailing: Icon(Icons.edit, color: brandColor, size: 20),
                    onTap: () async {
                      sfx.playClick();
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: game.wakeUpHour,
                          minute: game.wakeUpMinute,
                        ),
                      );
                      if (picked != null) {
                        game.updateWakeUpTime(picked.hour, picked.minute);
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.notifications_active,
                      color: brandColor,
                    ),
                    title: const Text("Manage Alerts"),
                    subtitle: const Text("Customize system notifications"),
                    onTap: () {
                      sfx.playClick();
                      NotificationService().openSettings();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, "HELP & SUPPORT"),
            Container(
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: outlineColor),
              ),
              child: Column(
                children: [
                  ListTile(
                    key: TutorialKeys.settingsManualKey,
                    leading: Icon(Icons.menu_book, color: brandColor),
                    title: const Text("Player Manual"),
                    subtitle: const Text("Read manual, mechanics & tips"),
                    onTap: () {
                      sfx.playClick();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserManualScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(Icons.replay, color: brandColor),
                    title: const Text("Redo Tutorial"),
                    subtitle: const Text("Replay the interactive onboarding"),
                    onTap: () async {
                      sfx.playClick();
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Replay Tutorial"),
                          content: const Text(
                            "Are you sure you want to replay the interactive onboarding tutorial? This will guide you through the interface again.",
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            TextButton(
                              child: const Text("Replay"),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await game.restartTutorial();
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(context, "ACCOUNT"),
            Container(
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: outlineColor),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.query_stats, color: brandColor),
                    title: const Text("Stats"),
                    subtitle: const Text("Your lifetime financial record"),
                    trailing: Icon(Icons.chevron_right, color: brandColor, size: 20),
                    onTap: () {
                      sfx.playClick();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatsScreen(game: game),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(Icons.person, color: brandColor),
                    title: const Text("Player Name"),
                    subtitle: Text(game.playerName),
                    trailing: Icon(Icons.edit, color: brandColor, size: 20),
                    onTap: () {
                      sfx.playClick();
                      final TextEditingController controller =
                          TextEditingController(text: game.playerName);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Edit Player Name"),
                          content: TextField(
                            controller: controller,
                            maxLength: 20,
                            autofocus: true,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              hintText: "Enter your name",
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: const Text("Save"),
                              onPressed: () {
                                final newName = controller.text.trim();
                                if (newName.isNotEmpty) {
                                  game.updatePlayerName(newName);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(Icons.logout, color: brandColor),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                    subtitle: const Text("Sign out safely"),
                    onTap: () async {
                      sfx.playClick();
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Logout"),
                          content: const Text(
                            "Are you sure you want to logout?",
                          ),
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
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.of(context, 'kp'),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
