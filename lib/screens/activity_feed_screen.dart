import 'package:flutter/material.dart';
import '../data/notification_data.dart';
import '../models/city_sharing_models.dart';
import '../services/friends_service.dart';
import '../theme/app_colors.dart';
import 'city_viewer_screen.dart';
import '../services/sfx_manager.dart';

class ActivityFeedScreen extends StatefulWidget {
  final List<ActivityEntry> initialActivities;
  final String myPlayerName;
  final List<Friendship> friendships;
  final Map<String, String> friendNames; // uid -> name
  final SfxManager sfx;

  const ActivityFeedScreen({
    super.key,
    required this.initialActivities,
    required this.myPlayerName,
    required this.friendships,
    required this.friendNames,
    required this.sfx,
  });

  @override
  State<ActivityFeedScreen> createState() => _ActivityFeedScreenState();
}

class _ActivityFeedScreenState extends State<ActivityFeedScreen> {
  final FriendsService _friendsService = FriendsService();
  bool _isLoadingFriend = false;
  late List<ActivityEntry> _activities;

  @override
  void initState() {
    super.initState();
    _activities = List.from(widget.initialActivities);
    _markAllAsSeen();
  }

  void _markAllAsSeen() async {
    await _friendsService.markAllAsSeen();
  }

  void _onActivityTap(ActivityEntry entry) async {
    if (_isLoadingFriend) return;
    setState(() {
      _isLoadingFriend = true;
    });

    try {
      final snapshot = await _friendsService.getFriendSnapshot(
        entry.sourcePlayerId,
      );
      if (snapshot != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CityViewerScreen(
                snapshot: snapshot,
                myPlayerName: widget.myPlayerName,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Could not retrieve friend's city snapshot."),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error fetching city: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFriend = false;
        });
      }
    }
  }

  String _formatRelativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return "${difference.inDays}d ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }

  String _getActivityText(ActivityEntry entry) {
    switch (entry.type) {
      case 'cheer':
        return 'Sent you a cheer.';
      case 'friend_request_sent':
        return 'Sent you a friend request.';
      case 'friend_request_accepted':
        return 'Accepted your friend request.';
      case 'session_summary':
        return NotificationData.formatFriendActivitySummary(
          entry.sourcePlayerName,
          entry.payload,
        );
      default:
        return entry.payload['text'] ?? 'Updated their city.';
    }
  }

  IconData _getActivityIcon(ActivityEntry entry) {
    switch (entry.type) {
      case 'cheer':
        return Icons.celebration;
      case 'friend_request_sent':
        return Icons.person_add;
      case 'friend_request_accepted':
        return Icons.people;
      default:
        return Icons.location_city;
    }
  }

  bool _isSocialEvent(ActivityEntry entry) =>
      entry.type == 'friend_request_sent' ||
      entry.type == 'friend_request_accepted';

  Color _getAvatarColor(ActivityEntry entry, BuildContext context) {
    switch (entry.type) {
      case 'friend_request_sent':
      case 'friend_request_accepted':
        return AppColors.of(context, 'success');
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Activity Feed")),
      body: Stack(
        children: [
          _activities.isEmpty
              ? Center(
                  child: Text(
                    "No notifications yet.\nFriends' progress updates will appear here!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: _activities.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final entry = _activities[index];
                    final text = _getActivityText(entry);
                    final relativeTime = _formatRelativeTime(entry.createdAt);
                    final isSocial = _isSocialEvent(entry);
                    final avatarColor = _getAvatarColor(entry, context);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: avatarColor,
                        child: isSocial
                            ? Icon(
                                _getActivityIcon(entry),
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 20,
                              )
                            : Text(
                                entry.sourcePlayerName.isNotEmpty
                                    ? entry.sourcePlayerName[0].toUpperCase()
                                    : "?",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      title: Text(
                        entry.sourcePlayerName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(text),
                          const SizedBox(height: 4),
                          Text(
                            relativeTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      trailing: isSocial
                          ? null
                          : const Icon(Icons.chevron_right),
                      onTap: isSocial ? null : () => _onActivityTap(entry),
                    );
                  },
                ),
          if (_isLoadingFriend)
            Container(
              color: Theme.of(
                context,
              ).colorScheme.scrim.withValues(alpha: 0.45),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
