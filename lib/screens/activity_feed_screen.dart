import 'package:flutter/material.dart';
import '../data/notification_data.dart';
import '../models/city_sharing_models.dart';
import '../services/firestore_service.dart';
import '../services/friends_service.dart';
import '../theme/app_colors.dart';
import 'city_viewer_screen.dart';
import '../services/sfx_manager.dart';
import '../widgets/profile_avatar.dart';

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
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoadingFriend = false;
  late List<ActivityEntry> _activities;

  // Cache of sourcePlayerId -> profilePic
  final Map<String, String?> _profilePicCache = {};
  final Set<String> _fetchingProfilePics = {};

  // Cache of sourcePlayerId -> resolved player name
  final Map<String, String> _friendNameCache = {};
  final Set<String> _fetchingFriendNames = {};

  // Track action states for friend request cards (entry.id -> 'accepted' | 'declined')
  final Map<String, String> _requestActionState = {};

  @override
  void initState() {
    super.initState();
    _activities = List.from(widget.initialActivities);
    _markAllAsSeen();
  }

  void _markAllAsSeen() async {
    await _friendsService.markAllAsSeen();
  }

  void _loadProfilePic(String sourcePlayerId) {
    if (_profilePicCache.containsKey(sourcePlayerId) ||
        _fetchingProfilePics.contains(sourcePlayerId)) {
      return;
    }
    _fetchingProfilePics.add(sourcePlayerId);
    _friendsService
        .getFriendSnapshot(sourcePlayerId)
        .then((snapshot) {
          if (!mounted) return;
          setState(() {
            _profilePicCache[sourcePlayerId] = snapshot?.profilePic;
            if (snapshot?.playerName != null &&
                snapshot!.playerName.isNotEmpty &&
                snapshot.playerName != 'User' &&
                snapshot.playerName != 'Unknown User') {
              _friendNameCache[sourcePlayerId] = snapshot.playerName;
            }
          });
        })
        .catchError((_) {
          if (mounted) {
            setState(() {
              _profilePicCache[sourcePlayerId] = null;
            });
          }
        })
        .whenComplete(() {
          _fetchingProfilePics.remove(sourcePlayerId);
        });
  }

  void _loadFriendName(String sourcePlayerId, String currentName) {
    if (currentName.isNotEmpty &&
        currentName != 'User' &&
        currentName != 'A player' &&
        currentName != 'Unknown User') {
      _friendNameCache[sourcePlayerId] = currentName;
      return;
    }
    if (_friendNameCache.containsKey(sourcePlayerId) ||
        _fetchingFriendNames.contains(sourcePlayerId)) {
      return;
    }
    _fetchingFriendNames.add(sourcePlayerId);
    _firestoreService.resolvePlayerName(sourcePlayerId).then((name) {
      if (!mounted) return;
      if (name.isNotEmpty && name != 'User' && name != 'A player') {
        setState(() {
          _friendNameCache[sourcePlayerId] = name;
        });
      }
    }).catchError((_) {}).whenComplete(() {
      _fetchingFriendNames.remove(sourcePlayerId);
    });
  }

  void _onActivityTap(ActivityEntry entry) async {
    if (_isLoadingFriend) return;
    widget.sfx.playClick();
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
                sfx: widget.sfx,
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

  String _getDisplayName(ActivityEntry entry) {
    if (_friendNameCache.containsKey(entry.sourcePlayerId)) {
      return _friendNameCache[entry.sourcePlayerId]!;
    }
    final mappedName = widget.friendNames[entry.sourcePlayerId];
    if (mappedName != null && mappedName.isNotEmpty && mappedName != 'User') {
      return mappedName;
    }
    if (entry.sourcePlayerName.isNotEmpty &&
        entry.sourcePlayerName != 'User' &&
        entry.sourcePlayerName != 'A player') {
      return entry.sourcePlayerName;
    }
    return 'Friend';
  }

  String _getActivityText(ActivityEntry entry) {
    final name = _getDisplayName(entry);
    switch (entry.type) {
      case 'cheer':
        return 'Sent you a cheer.';
      case 'friend_request_sent':
        return 'Sent you a friend request.';
      case 'friend_request_accepted':
        return 'Accepted your friend request.';
      case 'session_summary':
        return NotificationData.formatFriendActivitySummary(
          name,
          entry.payload,
        );
      default:
        return entry.payload['text'] ?? 'Updated their city.';
    }
  }

  Friendship? _findFriendship(String friendUid) {
    final myUid = _friendsService.currentUid;
    if (myUid == null) return null;
    final friendshipId = _firestoreService.getFriendshipId(myUid, friendUid);
    for (final f in widget.friendships) {
      if (f.id == friendshipId) return f;
    }
    return null;
  }

  void _acceptRequest(ActivityEntry entry) async {
    widget.sfx.playClick();
    final myUid = _friendsService.currentUid;
    if (myUid == null) return;

    final friendshipId = _firestoreService.getFriendshipId(myUid, entry.sourcePlayerId);
    setState(() {
      _requestActionState[entry.id] = 'accepted';
    });
    try {
      await _friendsService.acceptRequest(friendshipId);
    } catch (_) {}
  }

  void _declineRequest(ActivityEntry entry) async {
    widget.sfx.playClick();
    final myUid = _friendsService.currentUid;
    if (myUid == null) return;

    final friendshipId = _firestoreService.getFriendshipId(myUid, entry.sourcePlayerId);
    setState(() {
      _requestActionState[entry.id] = 'declined';
    });
    try {
      await _friendsService.declineRequest(friendshipId);
    } catch (_) {}
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
                    _loadProfilePic(entry.sourcePlayerId);
                    _loadFriendName(entry.sourcePlayerId, entry.sourcePlayerName);

                    final displayName = _getDisplayName(entry);
                    final text = _getActivityText(entry);
                    final relativeTime = _formatRelativeTime(entry.createdAt);
                    final isFriendRequest = entry.type == 'friend_request_sent';

                    final existingFriendship = _findFriendship(entry.sourcePlayerId);
                    final isPending = existingFriendship?.status == 'pending' &&
                        _requestActionState[entry.id] == null;
                    final actionState = _requestActionState[entry.id] ??
                        (existingFriendship?.status == 'accepted'
                            ? 'accepted'
                            : existingFriendship?.status == 'declined'
                                ? 'declined'
                                : null);

                    return Card(
                      elevation: isFriendRequest ? 2 : 0,
                      margin: isFriendRequest
                          ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
                          : EdgeInsets.zero,
                      shape: isFriendRequest
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )
                          : null,
                      child: ListTile(
                        leading: ProfileAvatar(
                          profilePic: _profilePicCache[entry.sourcePlayerId],
                          fallbackName: displayName,
                          radius: 20,
                        ),
                        title: Text(
                          displayName,
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
                            if (isFriendRequest && isPending) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                    ),
                                    onPressed: () => _acceptRequest(entry),
                                    child: const Text("Accept"),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      foregroundColor: AppColors.of(context, 'error'),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                    ),
                                    onPressed: () => _declineRequest(entry),
                                    child: const Text("Decline"),
                                  ),
                                ],
                              ),
                            ] else if (isFriendRequest && actionState != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                actionState == 'accepted'
                                    ? "✓ Accepted"
                                    : "Declined",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: actionState == 'accepted'
                                      ? AppColors.of(context, 'success')
                                      : AppColors.of(context, 'error'),
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: isFriendRequest
                            ? null
                            : const Icon(Icons.chevron_right),
                        onTap: isFriendRequest
                            ? null
                            : () => _onActivityTap(entry),
                      ),
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
