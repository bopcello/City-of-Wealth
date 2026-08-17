import 'dart:convert';
// ignore: unnecessary_import
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../logic/game_manager.dart';
import '../theme/app_colors.dart';

class AvatarPreset {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const AvatarPreset({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class AvatarPresets {
  static const List<AvatarPreset> all = [
    AvatarPreset(
      id: 'avatar_1',
      name: 'Tycoon',
      icon: Icons.business_center,
      color: Color(0xFFE65100),
    ),
    AvatarPreset(
      id: 'avatar_2',
      name: 'Architect',
      icon: Icons.architecture,
      color: Color(0xFF00838F),
    ),
    AvatarPreset(
      id: 'avatar_3',
      name: 'Investor',
      icon: Icons.trending_up,
      color: Color(0xFF2E7D32),
    ),
    AvatarPreset(
      id: 'avatar_4',
      name: 'Visionary',
      icon: Icons.auto_awesome,
      color: Color(0xFF6A1B9A),
    ),
    AvatarPreset(
      id: 'avatar_5',
      name: 'Scholar',
      icon: Icons.school,
      color: Color(0xFF1565C0),
    ),
    AvatarPreset(
      id: 'avatar_6',
      name: 'Explorer',
      icon: Icons.explore,
      color: Color(0xFFD84315),
    ),
    AvatarPreset(
      id: 'avatar_7',
      name: 'Builder',
      icon: Icons.construction,
      color: Color(0xFFF57F17),
    ),
    AvatarPreset(
      id: 'avatar_8',
      name: 'Innovator',
      icon: Icons.lightbulb,
      color: Color(0xFF9E9D24),
    ),
    AvatarPreset(
      id: 'avatar_9',
      name: 'Pioneer',
      icon: Icons.flag,
      color: Color(0xFFC62828),
    ),
    AvatarPreset(
      id: 'avatar_10',
      name: 'Captain',
      icon: Icons.anchor,
      color: Color(0xFF283593),
    ),
    AvatarPreset(
      id: 'avatar_11',
      name: 'Baron',
      icon: Icons.workspace_premium,
      color: Color(0xFF4A148C),
    ),
    AvatarPreset(
      id: 'avatar_12',
      name: 'Mindset',
      icon: Icons.psychology,
      color: Color(0xFFAD1457),
    ),
    AvatarPreset(
      id: 'avatar_13',
      name: 'Shield',
      icon: Icons.shield,
      color: Color(0xFF37474F),
    ),
    AvatarPreset(
      id: 'avatar_14',
      name: 'Bolt',
      icon: Icons.bolt,
      color: Color(0xFFFF8F00),
    ),
    AvatarPreset(
      id: 'avatar_15',
      name: 'Eco',
      icon: Icons.eco,
      color: Color(0xFF558B2F),
    ),
    AvatarPreset(
      id: 'avatar_16',
      name: 'Crown',
      icon: Icons.stars,
      color: Color(0xFFFBC02D),
    ),
  ];

  static AvatarPreset? getById(String? id) {
    if (id == null || id.isEmpty) return null;
    try {
      return all.firstWhere((preset) => preset.id == id);
    } catch (_) {
      return null;
    }
  }
}

class ProfileAvatar extends StatelessWidget {
  final String? profilePic;
  final String fallbackName;
  final double radius;
  final bool showBorder;

  const ProfileAvatar({
    super.key,
    required this.profilePic,
    required this.fallbackName,
    this.radius = 24,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final preset = AvatarPresets.getById(profilePic);
    final theme = Theme.of(context);
    final imageBytes = _decodeCustomImage(profilePic);

    Widget avatarContent;
    Color bgColor;

    if (imageBytes != null) {
      bgColor = AppColors.of(context, 'kp');
      avatarContent = ClipOval(
        child: Image.memory(
          imageBytes,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.person),
        ),
      );
    } else if (preset != null) {
      bgColor = preset.color;
      avatarContent = Icon(
        preset.icon,
        size: radius * 1.1,
        color: Colors.white,
      );
    } else {
      bgColor = AppColors.of(context, 'kp');
      final initial = fallbackName.trim().isNotEmpty
          ? fallbackName.trim()[0].toUpperCase()
          : '?';
      avatarContent = Text(
        initial,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.9,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: theme.colorScheme.primary, width: 2.5)
            : null,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        child: avatarContent,
      ),
    );
  }

  static Uint8List? _decodeCustomImage(String? value) {
    if (value == null || !value.startsWith('data:image')) return null;
    final separator = value.indexOf(',');
    if (separator == -1) return null;
    try {
      return base64Decode(value.substring(separator + 1));
    } catch (_) {
      return null;
    }
  }
}

class EditProfileDialog extends StatefulWidget {
  final GameManager game;

  const EditProfileDialog({super.key, required this.game});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameController;
  late String _selectedPfp;
  late String _currentFriendCode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.game.playerName);
    _selectedPfp = widget.game.profilePic;
    _currentFriendCode = widget.game.friendCode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 256,
      maxHeight: 256,
      imageQuality: 70,
    );
    if (image == null || !mounted) return;

    final bytes = await image.readAsBytes();
    if (!mounted) return;
    setState(() {
      _selectedPfp = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.edit_note, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          const Text("Edit Profile"),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Preview
              Center(
                child: Column(
                  children: [
                    ProfileAvatar(
                      profilePic: _selectedPfp,
                      fallbackName: _nameController.text,
                      radius: 36,
                      showBorder: true,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Choose Avatar",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Avatar Presets Selector Grid
              SizedBox(
                height: 120,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: AvatarPresets.all.length,
                  itemBuilder: (context, index) {
                    if (index == AvatarPresets.all.length - 1) {
                      return InkWell(
                        onTap: _pickProfileImage,
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: theme.colorScheme.primary,
                            size: 22,
                          ),
                        ),
                      );
                    }

                    final preset = AvatarPresets.all[index];
                    final isSelected = _selectedPfp == preset.id;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPfp = preset.id;
                        });
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: theme.colorScheme.primary,
                                  width: 3,
                                )
                              : null,
                        ),
                        child: CircleAvatar(
                          backgroundColor: preset.color,
                          child: Icon(
                            preset.icon,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Player Name Field
              TextField(
                controller: _nameController,
                maxLength: 20,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: "Player Name",
                  hintText: "Enter your name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              // Friend Code Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Friend Code",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SelectableText(
                          _currentFriendCode,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18),
                          tooltip: "Copy Code",
                          color: theme.colorScheme.onPrimaryContainer,
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: _currentFriendCode),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Friend code copied!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 20),
                          tooltip: "Regenerate Code",
                          color: theme.colorScheme.onPrimaryContainer,
                          onPressed: () {
                            setState(() {
                              _currentFriendCode = widget.game
                                  .generateNewFriendCode();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            final newName = _nameController.text.trim();
            if (newName.isNotEmpty) {
              widget.game.updateProfile(
                name: newName,
                pfp: _selectedPfp,
                newFriendCode: _currentFriendCode,
              );
              Navigator.pop(context);
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
