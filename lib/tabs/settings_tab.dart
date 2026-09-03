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
import '../widgets/profile_avatar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/about_screen.dart';
import '../services/shortcut_manager_service.dart';
import '../widgets/key_bindings_dialog.dart';

class SettingsTab extends StatefulWidget {
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
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  double _lastMusicVolume = 0.7;
  double _lastSfxVolume = 1.0;

  @override
  void initState() {
    super.initState();
    if (widget.musicVolume > 0) _lastMusicVolume = widget.musicVolume;
    if (widget.sfxVolume > 0) _lastSfxVolume = widget.sfxVolume;
  }

  void _showResetPasswordDialog(BuildContext context) {
    final currentUser = AuthService().currentUser;
    final isGoogleUser =
        currentUser?.providerData.any(
          (info) => info.providerId == 'google.com',
        ) ??
        false;

    if (isGoogleUser) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password reset is not applicable for Google Sign-In accounts.",
          ),
        ),
      );
      return;
    }

    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    bool isLoading = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Reset Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(
                      color: AppColors.of(context, 'error'),
                      fontSize: 13,
                    ),
                  ),
                ),
              TextField(
                controller: oldPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Current Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm New Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final oldPass = oldPassController.text.trim();
                      final newPass = newPassController.text.trim();
                      final confirmPass = confirmPassController.text.trim();

                      if (oldPass.isEmpty || newPass.isEmpty) {
                        setDialogState(() {
                          errorMessage = "Please enter all fields.";
                        });
                        return;
                      }

                      if (newPass != confirmPass) {
                        setDialogState(() {
                          errorMessage = "New passwords do not match.";
                        });
                        return;
                      }

                      if (newPass.length < 6) {
                        setDialogState(() {
                          errorMessage =
                              "New password must be at least 6 characters.";
                        });
                        return;
                      }

                      setDialogState(() {
                        isLoading = true;
                        errorMessage = null;
                      });

                      try {
                        await AuthService().changePassword(oldPass, newPass);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Password updated successfully!"),
                            ),
                          );
                        }
                      } catch (e) {
                        setDialogState(() {
                          isLoading = false;
                          errorMessage = e.toString().replaceAll(
                            "Exception: ",
                            "",
                          );
                        });
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Update Password"),
            ),
          ],
        ),
      ),
    );
  }

  void _showKeyBindingsModal(BuildContext context) {
    KeyBindingsDialog.show(context);
  }

  void _showDeactivateAccountDialog(BuildContext context) {
    final confirmController = TextEditingController();
    bool isLoading = false;
    String? errorText;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.of(context, 'error'),
              ),
              const SizedBox(width: 8),
              const Text("Deactivate Account"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Warning: This action will permanently delete all your city progress, assets, and account data from the cloud. This action is irreversible.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.of(context, 'error'),
                ),
              ),
              const SizedBox(height: 12),
              const Text("Type 'DELETE' below to confirm deactivation:"),
              const SizedBox(height: 12),
              TextField(
                controller: confirmController,
                decoration: InputDecoration(
                  hintText: "Type DELETE",
                  errorText: errorText,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.of(context, 'error'),
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      if (confirmController.text.trim() != "DELETE") {
                        setDialogState(() {
                          errorText = "Please type DELETE exactly to confirm";
                        });
                        return;
                      }

                      setDialogState(() {
                        isLoading = true;
                      });

                      try {
                        final uid = widget.game.currentUid;
                        if (uid != null) {
                          await AuthService().deleteAccount(uid);
                        } else {
                          await AuthService().signOut();
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        setDialogState(() {
                          isLoading = false;
                          errorText =
                              "Requires recent login. Please logout and log back in to deactivate.";
                        });
                      }
                    },
              child: isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    )
                  : Text(
                      "Delete & Deactivate",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

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

            // 1. ACCOUNT SECTION
            _buildSectionHeader(context, "ACCOUNT"),
            Container(
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: outlineColor),
              ),
              child: Column(
                children: [
                  // Profile Header Card
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ProfileAvatar(
                          profilePic: widget.game.profilePic,
                          fallbackName: widget.game.playerName,
                          radius: 32,
                          showBorder: true,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.game.playerName,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                levelName(
                                  widget.career.track,
                                  widget.career.level,
                                ),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: brandColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Code: ${widget.game.friendCode}",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            widget.sfx.playClick();
                            showDialog(
                              context: context,
                              builder: (context) => EditProfileDialog(
                                game: widget.game,
                                sfx: widget.sfx,
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text("Edit"),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: brandColor, width: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),

                  ListTile(
                    leading: Icon(Icons.lock_reset, color: brandColor),
                    title: const Text("Reset Password"),
                    subtitle: const Text("Change your login password"),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: brandColor,
                      size: 20,
                    ),
                    onTap: () {
                      widget.sfx.playClick();
                      _showResetPasswordDialog(context);
                    },
                  ),
                  const Divider(height: 1, indent: 56),

                  ListTile(
                    leading: Icon(Icons.query_stats, color: brandColor),
                    title: const Text("Stats"),
                    subtitle: const Text("Your lifetime financial record"),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: brandColor,
                      size: 20,
                    ),
                    onTap: () {
                      widget.sfx.playClick();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatsScreen(game: widget.game),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),

                  ListTile(
                    leading: Icon(Icons.cloud_done, color: brandColor),
                    title: const Text("Restore Data"),
                    subtitle: const Text(
                      "Restore progress to your account from cloud",
                    ),
                    onTap: () {
                      widget.sfx.playClick();
                      widget.onCloudSync();
                    },
                    trailing: Icon(Icons.sync, color: brandColor, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. AUDIO SECTION
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
                    leading: Tooltip(
                      message: widget.musicVolume == 0.0
                          ? "Unmute Music"
                          : "Mute Music",
                      child: Icon(
                        widget.musicVolume == 0.0
                            ? Icons.music_off
                            : Icons.music_note,
                        color: brandColor,
                      ),
                    ),
                    title: const Text("Music Volume"),
                    subtitle: Slider(
                      value: widget.musicVolume,
                      activeColor: brandColor,
                      onChanged: (val) {
                        if (val > 0) _lastMusicVolume = val;
                        widget.onMusicVolumeChanged(val, saveToDisk: false);
                      },
                      onChangeEnd: (val) =>
                          widget.onMusicVolumeChanged(val, saveToDisk: true),
                      min: 0.0,
                      max: 1.0,
                    ),
                    onTap: () {
                      widget.sfx.playClick();
                      if (widget.musicVolume > 0.0) {
                        _lastMusicVolume = widget.musicVolume;
                        widget.onMusicVolumeChanged(0.0, saveToDisk: true);
                      } else {
                        widget.onMusicVolumeChanged(
                          _lastMusicVolume > 0.0 ? _lastMusicVolume : 0.7,
                          saveToDisk: true,
                        );
                      }
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Tooltip(
                      message: widget.sfxVolume == 0.0
                          ? "Unmute Sound"
                          : "Mute Sound",
                      child: Icon(
                        widget.sfxVolume == 0.0
                            ? Icons.volume_off
                            : Icons.volume_up,
                        color: brandColor,
                      ),
                    ),
                    title: const Text("Sound Effects"),
                    subtitle: Slider(
                      value: widget.sfxVolume,
                      activeColor: brandColor,
                      onChanged: (val) {
                        if (val > 0) _lastSfxVolume = val;
                        widget.onSfxVolumeChanged(val, saveToDisk: false);
                      },
                      onChangeEnd: (val) =>
                          widget.onSfxVolumeChanged(val, saveToDisk: true),
                      min: 0.0,
                      max: 1.0,
                    ),
                    onTap: () {
                      widget.sfx.playClick();
                      if (widget.sfxVolume > 0.0) {
                        _lastSfxVolume = widget.sfxVolume;
                        widget.onSfxVolumeChanged(0.0, saveToDisk: true);
                      } else {
                        widget.onSfxVolumeChanged(
                          _lastSfxVolume > 0.0 ? _lastSfxVolume : 1.0,
                          saveToDisk: true,
                        );
                      }
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  SwitchListTile(
                    title: const Text("Dark Theme"),
                    subtitle: const Text("Easier on the eyes at night"),
                    value: widget.isDarkMode,
                    onChanged: (val) {
                      widget.sfx.playClick();
                      widget.onThemeToggle(val);
                    },
                    secondary: Icon(Icons.brightness_4, color: brandColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // KEYBOARD & CONTROLS SECTION (Only if keyboard detected)
            ListenableBuilder(
              listenable: ShortcutManagerService.instance,
              builder: (context, _) {
                final service = ShortcutManagerService.instance;
                if (!service.isKeyboardDetected) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(context, "CONTROLS & KEYBOARD"),
                    Container(
                      decoration: BoxDecoration(
                        color: surfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: outlineColor),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.keyboard, color: brandColor),
                            title: const Text("Key Bindings"),
                            subtitle: const Text("View and edit desktop shortcuts"),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: brandColor,
                              size: 20,
                            ),
                            onTap: () {
                              widget.sfx.playClick();
                              _showKeyBindingsModal(context);
                            },
                          ),
                          const Divider(height: 1, indent: 56),
                          ListTile(
                            leading: Icon(Icons.visibility, color: brandColor),
                            title: const Text("Unhide All Hints"),
                            subtitle: const Text("Restore shortcut overlay guides across all screens"),
                            trailing: Icon(
                              Icons.refresh_rounded,
                              color: brandColor,
                              size: 20,
                            ),
                            onTap: () {
                              widget.sfx.playClick();
                              service.unhideAllOverlays();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("All keyboard shortcut hints restored!"),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),


            // 3. HELP SECTION
            _buildSectionHeader(context, "HELP"),
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
                      widget.sfx.playClick();
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
                      widget.sfx.playClick();
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
                        await widget.game.restartTutorial();
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 4. NOTIFICATIONS SECTION
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
                      "Alert at ${TimeOfDay(hour: widget.game.wakeUpHour, minute: widget.game.wakeUpMinute).format(context)}",
                    ),
                    trailing: Icon(Icons.edit, color: brandColor, size: 20),
                    onTap: () async {
                      widget.sfx.playClick();
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: widget.game.wakeUpHour,
                          minute: widget.game.wakeUpMinute,
                        ),
                      );
                      if (picked != null) {
                        widget.game.updateWakeUpTime(
                          picked.hour,
                          picked.minute,
                        );
                        setState(() {});
                      }
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(
                      Icons.notifications_active,
                      color: brandColor,
                    ),
                    title: const Text("Manage Alerts"),
                    subtitle: const Text("Customize system notifications"),
                    onTap: () {
                      widget.sfx.playClick();
                      NotificationService().openSettings();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. PRIVACY SECTION
            _buildSectionHeader(context, "PRIVACY"),
            Container(
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: outlineColor),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: Icon(Icons.visibility, color: brandColor),
                    title: const Text("Share Profile Picture with Friends"),
                    subtitle: const Text(
                      "Allow accepted friends to view your profile picture in friend lists and city views",
                    ),
                    value: widget.game.showPfpPublicly,
                    onChanged: (val) {
                      widget.sfx.playClick();
                      widget.game.setShowPfpPublicly(val);
                      setState(() {});
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: brandColor),
                    title: const Text("About"),
                    subtitle: const Text("Version, developer & contact info"),
                    onTap: () {
                      widget.sfx.playClick();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(
                      Icons.privacy_tip_outlined,
                      color: brandColor,
                    ),
                    title: const Text("Privacy Policy"),
                    subtitle: const Text("How your data is collected and used"),
                    trailing: Icon(
                      Icons.open_in_new,
                      color: brandColor,
                      size: 20,
                    ),
                    onTap: () async {
                      widget.sfx.playClick();
                      final uri = Uri.parse(
                        'https://sites.google.com/view/city-of-wealth/privacy-policy',
                      );
                      final launched = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Couldn't open the link."),
                          ),
                        );
                      }
                    },
                  ),
                  const Divider(height: 1, indent: 56),
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(Icons.logout, color: brandColor),
                    title: const Text("Logout"),
                    subtitle: const Text("Sign out safely"),
                    onTap: () async {
                      widget.sfx.playClick();
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
                  const Divider(height: 1, indent: 56),
                  ListTile(
                    leading: Icon(
                      Icons.delete_forever,
                      color: AppColors.of(context, 'error'),
                    ),
                    title: Text(
                      "Deactivate Account",
                      style: TextStyle(color: AppColors.of(context, 'error')),
                    ),
                    subtitle: const Text(
                      "Permanently delete all data and deactivate your account",
                    ),
                    onTap: () {
                      widget.sfx.playClick();
                      _showDeactivateAccountDialog(context);
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
