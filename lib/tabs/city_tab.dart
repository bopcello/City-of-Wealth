import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math' as math;
import '../widgets/icon_text.dart';
import '../theme/app_colors.dart';
import '../services/sfx_manager.dart';
import '../services/friends_service.dart';
import '../game_state.dart';
import '../logic/game_manager.dart';
import '../logic/tutorial_keys.dart';
import '../models/city_sharing_models.dart';
import '../widgets/add_friend_dialog.dart';
import '../screens/city_viewer_screen.dart';
import '../screens/activity_feed_screen.dart';
import '../screens/leaderboard_screen.dart';

class CityTab extends StatefulWidget {
  final CareerState career;
  final int gems;
  final AssetInventory assets;
  final List<PlacedBuilding> cityLayout;
  final Set<AssetType> insurances;
  final Map<AssetType, int> activePassiveIncomes;
  final bool hasWall;
  final void Function(AssetType type, int amount) onBuyAsset;
  final void Function(PlacedBuilding building) onPlaceBuilding;
  final void Function(PlacedBuilding building) onRemoveBuilding;
  final VoidCallback onBuyWall;
  final SfxManager sfx;
  final GameManager game;

  const CityTab({
    super.key,
    required this.career,
    required this.gems,
    required this.assets,
    required this.cityLayout,
    required this.insurances,
    required this.activePassiveIncomes,
    required this.hasWall,
    required this.onBuyAsset,
    required this.onPlaceBuilding,
    required this.onRemoveBuilding,
    required this.onBuyWall,
    required this.sfx,
    required this.game,
  });

  @override
  State<CityTab> createState() => CityTabState();
}

class CityTabState extends State<CityTab> {
  final TransformationController _transformationController =
      TransformationController();

  // 0 = My City, 1 = Friends
  int _selectedSegment = 0;

  List<Friendship> get friendships => _friendships;
  List<ActivityEntry> get activityFeed => _activityFeed;
  Map<String, PublicCitySnapshot> get friendSnapshots => _friendSnapshots;

  void setSelectedSegment(int index) {
    if (mounted) {
      setState(() {
        _selectedSegment = index;
      });
    }
  }

  // Friends
  List<Friendship> _friendships = [];
  List<ActivityEntry> _activityFeed = [];
  Map<String, PublicCitySnapshot> _friendSnapshots = {};
  StreamSubscription<List<Friendship>>? _friendsSub;
  StreamSubscription<List<ActivityEntry>>? _activitySub;
  final FriendsService _friendsService = FriendsService();

  @override
  void initState() {
    super.initState();
    _setupFriendStreams();
  }

  void _loadFriendSnapshots(List<Friendship> friendships) async {
    final currentUid = widget.game.currentUid;
    if (currentUid == null) return;
    final accepted = friendships.where((f) => f.status == 'accepted').toList();

    final Map<String, PublicCitySnapshot> newSnaps = {};
    for (var f in accepted) {
      final friendUid = f.playerA == currentUid ? f.playerB : f.playerA;
      try {
        final snap = await _friendsService.getFriendSnapshot(friendUid);
        if (snap != null) {
          newSnaps[friendUid] = snap;
        }
      } catch (e) {
        debugPrint("Error loading snapshot for $friendUid: $e");
      }
    }
    if (mounted) {
      setState(() {
        _friendSnapshots = newSnaps;
      });
    }
  }

  void _setupFriendStreams() {
    _friendsSub = _friendsService.getFriendshipsStream().listen((friendships) {
      if (mounted) {
        setState(() => _friendships = friendships);
        _loadFriendSnapshots(friendships);
      }
    });
    _activitySub = _friendsService.getActivityFeedStream().listen((feed) {
      if (mounted) setState(() => _activityFeed = feed);
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _friendsSub?.cancel();
    _activitySub?.cancel();
    super.dispose();
  }

  void _clearSelection() {
    widget.game.clearSelection();
  }

  void _toggleEditMode() {
    widget.game.toggleEditMode();
  }

  @override
  Widget build(BuildContext context) {
    final int unseenCount = _activityFeed.where((e) => !e.seen).length;
    final currentUid = widget.game.currentUid;

    final pendingRequests = _friendships
        .where((f) => f.status == 'pending' && f.requestedBy != currentUid)
        .toList();
    final accepted = _friendships.where((f) => f.status == 'accepted').toList();
    accepted.sort((a, b) {
      // sort by kp descending - need to load snapshots for this, so skip for now and sort by createdAt
      return b.createdAt.compareTo(a.createdAt);
    });

    return Column(
      children: [
        // ── Header Bar ──
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              // Segmented control
              Expanded(
                child: SegmentedButton<int>(
                  key: TutorialKeys.friendsSegmentKey,
                  segments: const [
                    ButtonSegment(
                      value: 0,
                      label: Text("My City"),
                      icon: Icon(Icons.location_city),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text("Friends"),
                      icon: Icon(Icons.group),
                    ),
                  ],
                  selected: {_selectedSegment},
                  onSelectionChanged: (val) {
                    widget.sfx.playClick();
                    setState(() {
                      _selectedSegment = val.first;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Add friend button
              IconButton(
                key: TutorialKeys.addFriendButtonKey,
                icon: const Icon(Icons.person_add),
                tooltip: "Add Friend",
                onPressed: () {
                  widget.sfx.playClick();
                  showDialog(
                    context: context,
                    builder: (_) => AddFriendDialog(
                      myFriendCode: widget.game.friendCode,
                      currentFriendships: _friendships,
                    ),
                  );
                },
              ),
              // Leaderboard button
              IconButton(
                key: TutorialKeys.leaderboardButtonKey,
                icon: const Icon(Icons.leaderboard),
                tooltip: "Leaderboard",
                onPressed: () {
                  widget.sfx.playClick();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LeaderboardScreen(
                        currentUid: currentUid ?? '',
                        myPlayerName: widget.game.playerName,
                        myKp: widget.game.kp,
                        myStreak: widget.game.dailyQuizStreak,
                        myTitle: levelName(
                          widget.career.track,
                          widget.career.level,
                        ),
                        friendSnapshots: _friendSnapshots,
                      ),
                    ),
                  );
                },
              ),
              // Bell badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    key: TutorialKeys.activityFeedButtonKey,
                    icon: const Icon(Icons.notifications),
                    tooltip: "Activity Feed",
                    onPressed: () {
                      widget.sfx.playClick();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ActivityFeedScreen(
                            initialActivities: _activityFeed,
                            myPlayerName: widget.game.playerName,
                            friendships: _friendships,
                            friendNames: {
                              for (var f in _friendships)
                                (f.playerA == currentUid
                                        ? f.playerB
                                        : f.playerA):
                                    "Friend",
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  if (unseenCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            unseenCount > 9 ? '9+' : '$unseenCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // ── Tab Body ──
        Expanded(
          child: _selectedSegment == 0
              ? _buildMyCityView(context)
              : _buildFriendsView(
                  context,
                  currentUid,
                  pendingRequests,
                  accepted,
                ),
        ),
      ],
    );
  }

  Widget _buildMyCityView(BuildContext context) {
    final Map<String, PlacedBuilding> cityMap = {
      for (var b in widget.cityLayout) "${b.x},${b.y}": b,
    };
    final int gridSize = (widget.career.level - 1) * 2 + 1;

    return GestureDetector(
      onTap: () {
        if (widget.game.selectedBuilding != null) {
          if (widget.game.isEditMode) {
            widget.game.setBuildingSelection(null);
          } else {
            _clearSelection();
          }
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_transformationController.value == Matrix4.identity()) {
            final double vw = constraints.maxWidth;
            final double vh = constraints.maxHeight;

            final double side = gridSize * 52.0 + 200.0; // Account for the padding of 100 on each side
            final double tx = (vw - side) / 2;
            final double ty = (vh - side) / 2;

            _transformationController.value = Matrix4.translationValues(
              tx,
              ty,
              0.0,
            );
          }

          return Stack(
            key: TutorialKeys.cityBodyKey,
            children: [
              Container(color: Colors.transparent),
              InteractiveViewer(
                transformationController: _transformationController,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(500),
                minScale: 0.1,
                maxScale: 2.5,
                child: RepaintBoundary(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (widget.hasWall)
                        Transform.translate(
                          offset: const Offset(0, 45),
                          child: Transform.scale(
                            scale: 1.8,
                            child: Image.asset(
                              "lib/assets/buildings/The Keystone.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..rotateX(-math.pi / 3.5)
                          ..rotateZ(math.pi / 4),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(100),
                              child: _IsometricGrid(
                                gridSize: gridSize,
                                cityMap: cityMap,
                                selectedBuilding: widget.game.selectedBuilding,
                                isEditMode: widget.game.isEditMode,
                                onTileTap: (x, y) {
                                  final buildingKey = "$x,$y";
                                  final hasBuilding = cityMap.containsKey(
                                    buildingKey,
                                  );

                                  if (widget.game.selectedBuilding != null) {
                                    if (hasBuilding) {
                                      if (widget.game.isEditMode) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Cell is already occupied",
                                            ),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      }
                                      return;
                                    }
                                    widget.sfx.playBuy();
                                    widget.onPlaceBuilding(
                                      PlacedBuilding(
                                        name:
                                            widget.game.selectedBuilding!.name,
                                        x: x,
                                        y: y,
                                      ),
                                    );
                                    if (widget.game.isEditMode) {
                                      widget.game.setBuildingSelection(null);
                                    } else {
                                      _clearSelection();
                                    }
                                  } else if (widget.game.isEditMode &&
                                      hasBuilding) {
                                    final building = cityMap[buildingKey]!;
                                    widget.game.setBuildingSelection(
                                      buildings.firstWhere(
                                        (b) => b.name == building.name,
                                      ),
                                    );
                                    widget.onRemoveBuilding(building);
                                  }
                                },
                              ),
                            ),
                            Positioned(child: _Palace()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.game.selectedBuilding != null)
                Positioned(
                  left: 16,
                  top: 16,
                  child: Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.of(context, 'kp').withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.of(context, 'success'),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      widget.game.selectedBuilding!.iconPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              Positioned(
                right: 16,
                bottom: 90,
                child: FloatingActionButton.extended(
                  heroTag: "city_layout_fab",
                  onPressed: () {
                    widget.sfx.playClick();
                    _toggleEditMode();
                  },
                  label: Text(widget.game.isEditMode ? "Done" : "Edit layout"),
                  icon: Icon(widget.game.isEditMode ? Icons.check : Icons.edit),
                  backgroundColor: widget.game.isEditMode
                      ? AppColors.of(context, 'success')
                      : null,
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton.extended(
                  heroTag: "city_add_fab",
                  onPressed: () {
                    widget.sfx.playClick();
                    if (widget.game.isEditMode) {
                      widget.game.toggleEditMode();
                    }
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (_) {
                        return _BuildingsBottomSheet(
                          career: widget.career,
                          gems: widget.gems,
                          assets: widget.assets,
                          insurances: widget.insurances,
                          activePassiveIncomes: widget.activePassiveIncomes,
                          hasWall: widget.hasWall,
                          sfx: widget.sfx,
                          onSelect: (building) {
                            if (building.name == "The Keystone") {
                              widget.sfx.playBuy();
                              widget.onBuyWall();
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                              setState(() {
                                widget.game.setBuildingSelection(building);
                              });
                            }
                          },
                          onClose: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                  label: const Text("Add buildings"),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFriendsView(
    BuildContext context,
    String? currentUid,
    List<Friendship> pendingRequests,
    List<Friendship> accepted,
  ) {
    // Gather recent activity per accepted friend for the "most recent" snippet
    final Map<String, ActivityEntry?> recentActivityByFriend = {};
    for (final f in accepted) {
      final friendUid = f.playerA == currentUid ? f.playerB : f.playerA;
      final entries = _activityFeed
          .where((e) => e.sourcePlayerId == friendUid)
          .toList();
      recentActivityByFriend[friendUid] = entries.isEmpty
          ? null
          : entries.first;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Pending requests
        if (pendingRequests.isNotEmpty) ...[
          const Text(
            "Friend Requests",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...pendingRequests.map(
            (f) => PendingRequestCard(
              friendship: f,
              friendsService: _friendsService,
              sfx: widget.sfx,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
        ],

        // Friends section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Friends (${accepted.length})",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (accepted.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.group_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No friends yet!\nTap the person+ icon to add friends.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                  ),
                ],
              ),
            ),
          )
        else
          ...accepted.map((f) {
            final friendUid = f.playerA == currentUid ? f.playerB : f.playerA;
            final recent = recentActivityByFriend[friendUid];
            final isMuted = f.mutedBy.contains(currentUid);

            return FutureFriendCard(
              friendshipId: f.id,
              friendUid: friendUid,
              recentActivity: recent,
              isMuted: isMuted,
              myPlayerName: widget.game.playerName,
              sfx: widget.sfx,
              onMuteToggle: (mute) =>
                  _friendsService.toggleMuteFriend(f.id, mute),
              onBlock: () => _friendsService.blockFriend(f.id),
            );
          }),
      ],
    );
  }
}

/// A card that fetches a friend's PublicCitySnapshot and displays their info.
class FutureFriendCard extends StatefulWidget {
  final String friendshipId;
  final String friendUid;
  final ActivityEntry? recentActivity;
  final bool isMuted;
  final String myPlayerName;
  final SfxManager sfx;
  final Future<void> Function(bool) onMuteToggle;
  final VoidCallback onBlock;

  const FutureFriendCard({
    super.key,
    required this.friendshipId,
    required this.friendUid,
    required this.recentActivity,
    required this.isMuted,
    required this.myPlayerName,
    required this.sfx,
    required this.onMuteToggle,
    required this.onBlock,
  });

  @override
  State<FutureFriendCard> createState() => _FutureFriendCardState();
}

class _FutureFriendCardState extends State<FutureFriendCard> {
  PublicCitySnapshot? _snapshot;
  bool _loadingSnapshot = true;
  String _backupName = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadSnapshot();
  }

  Future<void> _loadSnapshot() async {
    final snap = await FriendsService().getFriendSnapshot(widget.friendUid);
    if (snap != null) {
      if (mounted) {
        setState(() {
          _snapshot = snap;
          _loadingSnapshot = false;
        });
      }
    } else {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('players')
            .doc(widget.friendUid)
            .get();
        if (doc.exists && doc.data() != null) {
          if (mounted) {
            setState(() {
              _backupName =
                  doc.data()?['playerName'] as String? ?? "Unknown User";
              _loadingSnapshot = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _backupName = "New Player";
              _loadingSnapshot = false;
            });
          }
        }
      } catch (_) {
        if (mounted) {
          setState(() {
            _backupName = "Unknown User";
            _loadingSnapshot = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _snapshot?.playerName ?? _backupName;
    final title = _snapshot?.title ?? "";
    final streak = _snapshot?.streak ?? 0;
    final kp = _snapshot?.kp ?? 0;
    String? recentText;
    if (widget.recentActivity != null) {
      final type = widget.recentActivity!.type;
      recentText = switch (type) {
        'cheer' => 'Sent you a cheer.',
        'friend_request_sent' => 'Sent you a friend request.',
        'friend_request_accepted' => 'Accepted your friend request.',
        _ =>
          widget.recentActivity!.payload['text'] as String? ??
              'Updated their city.',
      };
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _snapshot == null
            ? null
            : () {
                widget.sfx.playClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CityViewerScreen(
                      snapshot: _snapshot!,
                      myPlayerName: widget.myPlayerName,
                    ),
                  ),
                );
              },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: _loadingSnapshot
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        name.isNotEmpty ? name[0].toUpperCase() : "?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (title.isNotEmpty)
                      Text(
                        title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: IconText(
                        "[KP] $kp   [STREAK] $streak",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (recentText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          recentText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    if (_snapshot == null && !_loadingSnapshot)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "City not built yet",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Mute toggle icon (green = unmuted, red = muted)
              IconButton(
                icon: Icon(
                  widget.isMuted ? Icons.volume_off : Icons.volume_up,
                  size: 20,
                  color: widget.isMuted ? Colors.red : Colors.green,
                ),
                tooltip: widget.isMuted ? "Unmute" : "Mute",
                onPressed: () async {
                  widget.sfx.playClick();
                  await widget.onMuteToggle(!widget.isMuted);
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20),
                onSelected: (value) async {
                  if (value == 'block') {
                    widget.onBlock();
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'block',
                    child: Row(
                      children: [
                        Icon(Icons.block, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Block", style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildingsBottomSheet extends StatelessWidget {
  final CareerState career;
  final int gems;
  final AssetInventory assets;
  final Set<AssetType> insurances;
  final Map<AssetType, int> activePassiveIncomes;
  final bool hasWall;
  final SfxManager sfx;
  final Function(Building) onSelect;
  final VoidCallback onClose;

  const _BuildingsBottomSheet({
    required this.career,
    required this.gems,
    required this.assets,
    required this.insurances,
    required this.activePassiveIncomes,
    required this.hasWall,
    required this.sfx,
    required this.onSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final available = buildings.where((b) {
      if (b.name == "The Keystone") {
        // Only show Keystone if: Level 5, all 5 insurances, and not already owned
        if (hasWall) return false;
        if (career.level < 5) return false;
        if (insurances.length < 5) return false;
        return true;
      }

      final isPassiveIncomeBuilding = passiveIncomeData.values.any(
        (info) => info.buildingName == b.name,
      );
      if (isPassiveIncomeBuilding) {
        final passiveInfo = passiveIncomeData.values.firstWhere(
          (info) => info.buildingName == b.name,
        );
        final investedCount = activePassiveIncomes[passiveInfo.assetType] ?? 0;
        return investedCount > 0;
      }

      // Show if it matches career track and level
      return b.track == career.track && career.level >= b.requiredLevel;
    });

    return Container(
      height: 360,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black54
                : Colors.black12,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                "Available Buildings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close), onPressed: onClose),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: available.isEmpty
                ? Center(
                    child: Text(
                      "No buildings available yet.\nAdvance your career to unlock construction.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView(
                    children: available
                        .map(
                          (b) => _BuildingCard(
                            building: b,
                            career: career,
                            gems: gems,
                            assets: assets,
                            insurances: insurances,
                            onSelect: () => onSelect(b),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BuildingCard extends StatelessWidget {
  final Building building;
  final CareerState career;
  final int gems;
  final AssetInventory assets;
  final Set<AssetType> insurances;
  final VoidCallback onSelect;

  const _BuildingCard({
    required this.building,
    required this.career,
    required this.gems,
    required this.assets,
    required this.insurances,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isKeystone = building.name == "The Keystone";
    final isLevel5 = career.level >= 5;
    final hasAllInsurances = insurances.length >= 5;
    final isPassive = passiveIncomeData.values.any(
      (info) => info.buildingName == building.name,
    );

    // Keystone Requirements: Level 5 + 5 Insurances (simplified check)
    bool canBuild = false;
    final hasAssetRequirements = building.requirements.entries.every(
      (e) => assets.count(e.key) >= e.value,
    );

    if (isKeystone) {
      canBuild = isLevel5 && hasAllInsurances;
    } else {
      canBuild = career.level >= building.requiredLevel && hasAssetRequirements;
    }

    final hasLevel = isKeystone
        ? isLevel5
        : career.level >= building.requiredLevel;

    final widgetCard = Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canBuild
              ? AppColors.of(context, 'success')
              : AppColors.of(context, 'error'),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              building.iconPath,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  building.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Level: ${building.requiredLevel}",
                  style: TextStyle(
                    fontSize: 12,
                    color: hasLevel
                        ? AppColors.of(context, 'success')
                        : AppColors.of(context, 'error'),
                  ),
                ),
                if (building.requirements.isNotEmpty) ...[
                  IconText(
                    "Requires: ${building.requirements.entries.map((e) => "${e.value} ${assetLabel(e.key)}").join(", ")}",
                    style: const TextStyle(fontSize: 12),
                    color: hasAssetRequirements
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : AppColors.of(context, 'error'),
                  ),
                  if (building.name == "The Keystone")
                    IconText(
                      "Special: Requires all 5 Insurances",
                      style: const TextStyle(fontSize: 12),
                      color: hasAllInsurances
                          ? AppColors.of(context, 'gem')
                          : AppColors.of(context, 'error'),
                    ),
                ] else if (isPassive) ...[
                  IconText(
                    "Passive Income Building",
                    style: const TextStyle(fontSize: 12),
                    color: AppColors.of(context, 'success'),
                  ),
                ],
              ],
            ),
          ),
          if (canBuild)
            Icon(Icons.check_circle, color: AppColors.of(context, 'success'))
          else
            Icon(
              Icons.lock,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 16,
            ),
        ],
      ),
    );

    if (canBuild) {
      return GestureDetector(onTap: onSelect, child: widgetCard);
    }

    return widgetCard;
  }
}

class _IsometricGrid extends StatelessWidget {
  final int gridSize;
  final Map<String, PlacedBuilding> cityMap;
  final Building? selectedBuilding;
  final bool isEditMode;
  final Function(int, int) onTileTap;

  const _IsometricGrid({
    required this.gridSize,
    required this.cityMap,
    required this.selectedBuilding,
    required this.isEditMode,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    const double tileSize = 50;

    final int half = (gridSize - 1) ~/ 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(gridSize, (row) {
        final y = row - half;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(gridSize, (col) {
            final x = col - half;

            final placedBuilding = cityMap["$x,$y"];
            final hasBuilding = placedBuilding != null;
            final building = hasBuilding
                ? buildings.firstWhere((b) => b.name == placedBuilding.name)
                : null;

            return GestureDetector(
              onTap: () => onTileTap(x, y),
              child: Builder(
                builder: (context) {
                  Color cellColor;

                  if (selectedBuilding != null) {
                    // Building is selected for placement
                    if (!hasBuilding) {
                      // Empty cells highlighted in blue
                      cellColor = AppColors.of(
                        context,
                        'gem',
                      ).withValues(alpha: 0.6);
                    } else {
                      // Occupied cells highlighted in red
                      cellColor = AppColors.of(
                        context,
                        'error',
                      ).withValues(alpha: 0.6);
                    }
                  } else {
                    // No building selected - show default green grid
                    cellColor = AppColors.of(
                      context,
                      'gridGreen',
                    ).withValues(alpha: 0.5);
                  }

                  return Container(
                    width: tileSize,
                    height: tileSize,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: cellColor,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: hasBuilding
                        ? Center(
                            child: Image.asset(
                              building!.iconPath,
                              width: tileSize * 0.8,
                              height: tileSize * 0.8,
                              fit: BoxFit.contain,
                            ),
                          )
                        : null,
                  );
                },
              ),
            );
          }),
        );
      }),
    );
  }
}

class _Palace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.amber.shade600,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(blurRadius: 6, offset: Offset(2, 4), color: Colors.black26),
        ],
      ),
      child: Center(
        child: Image.asset(
          "lib/assets/buildings/palace.png",
          width: 48,
          height: 48,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class PendingRequestCard extends StatefulWidget {
  final Friendship friendship;
  final FriendsService friendsService;
  final SfxManager sfx;

  const PendingRequestCard({
    super.key,
    required this.friendship,
    required this.friendsService,
    required this.sfx,
  });

  @override
  State<PendingRequestCard> createState() => _PendingRequestCardState();
}

class _PendingRequestCardState extends State<PendingRequestCard> {
  String _senderName = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadSenderName();
  }

  void _loadSenderName() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('players')
          .doc(widget.friendship.requestedBy)
          .get();
      if (snap.exists && snap.data() != null) {
        if (mounted) {
          setState(() {
            _senderName =
                snap.data()?['playerName'] as String? ?? "Unknown User";
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _senderName = "New Player";
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _senderName = "Unknown User";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _senderName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                widget.sfx.playClick();
                widget.friendsService.acceptRequest(widget.friendship.id);
              },
              child: const Text("Accept"),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                widget.sfx.playClick();
                widget.friendsService.declineRequest(widget.friendship.id);
              },
              child: const Text("Decline"),
            ),
          ],
        ),
      ),
    );
  }
}
