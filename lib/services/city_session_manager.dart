import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/city_sharing_models.dart';
import '../game_state.dart';
import '../logic/game_manager.dart';
import 'firestore_service.dart';

class CitySessionManager {
  static final CitySessionManager _instance = CitySessionManager._internal();
  factory CitySessionManager() => _instance;
  CitySessionManager._internal();

  final FirestoreService _firestoreService = FirestoreService();

  Timer? _idleTimer;
  bool _isSessionActive = false;

  int? _startLevel;
  int? _startStreak;
  List<PlacedBuilding>? _startLayout;
  int? _startBankruptcyCount;
  String? _startTrack;

  bool get isSessionActive => _isSessionActive;

  void notifyEdit(GameManager game) {
    if (!_isSessionActive) {
      _startSession(game);
    } else {
      _resetIdleTimer(game);
    }
  }

  void _startSession(GameManager game) {
    final uid = game.currentUid;
    if (uid == null) return;

    _isSessionActive = true;
    _startLevel = game.career.level;
    _startStreak = game.dailyQuizStreak;
    _startLayout = List<PlacedBuilding>.from(game.cityLayout);
    _startBankruptcyCount = game.bankruptcyCount;
    _startTrack = game.career.track.name;

    debugPrint("🏙️ CitySession: Edit session started");
    _resetIdleTimer(game);
  }

  void _resetIdleTimer(GameManager game) {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(minutes: 3), () {
      debugPrint("🏙️ CitySession: Idle timer expired. Closing session...");
      closeSession(game);
    });
  }

  Future<void> closeSession(GameManager game) async {
    if (!_isSessionActive) return;

    _idleTimer?.cancel();
    _isSessionActive = false;

    final uid = game.currentUid;
    if (uid == null) return;

    debugPrint("🏙️ CitySession: Closing edit session...");

    try {
      final PublicCitySnapshot? prevSnapshot =
          await _firestoreService.getPublicCitySnapshot(uid);

      final currentLevel = game.career.level;
      final currentStreak = game.dailyQuizStreak;
      final currentTrack = game.career.track.name;
      final currentLayout = game.cityLayout;
      final currentBankruptcy = game.bankruptcyCount;

      final baseLevel = prevSnapshot?.level ?? _startLevel ?? 1;
      final baseStreak = prevSnapshot?.streak ?? _startStreak ?? 0;
      final baseTrack = prevSnapshot?.track ?? _startTrack ?? 'student';
      final baseLayout = prevSnapshot?.buildings ?? _startLayout ?? [];
      final baseBankruptcy = _startBankruptcyCount ?? 0;

      // Overwrite PublicCitySnapshot
      final newSnapshot = PublicCitySnapshot(
        playerId: uid,
        playerName: game.playerName,
        friendCode: game.friendCode,
        track: currentTrack,
        level: currentLevel,
        title: levelName(game.career.track, game.career.level),
        streak: currentStreak,
        kp: game.kp,
        buildings: currentLayout,
        buildingCount: currentLayout.length,
        lastUpdatedAt: DateTime.now(),
      );

      await _firestoreService.savePublicCitySnapshot(newSnapshot);
      debugPrint("🏙️ Public city snapshot saved.");

      // Classify notable events
      final List<String> notableEvents = [];
      String type = "building_built";

      if (currentLevel > baseLevel && currentTrack == baseTrack) {
        notableEvents.add("leveled up to ${levelName(game.career.track, game.career.level)}");
        type = "level_up";
      }

      if (currentBankruptcy > baseBankruptcy) {
        notableEvents.add("declared bankruptcy");
        type = "bankruptcy";
      }

      final baseBuildingTypes = baseLayout.map((b) => b.name).toSet();
      final currentBuildingTypes = currentLayout.map((b) => b.name).toSet();
      final newBuildingTypes = currentBuildingTypes.difference(baseBuildingTypes);
      if (newBuildingTypes.isNotEmpty) {
        notableEvents.add("built their first ${newBuildingTypes.join(', ')}");
        if (type != "level_up") type = "building_built";
      }

      if (currentStreak > baseStreak &&
          (currentStreak == 10 || currentStreak == 30 || currentStreak == 100)) {
        notableEvents.add("reached a $currentStreak-day streak milestone");
        type = "streak_milestone";
      }

      if (notableEvents.isEmpty) {
        debugPrint("🏙️ No notable events. Silent snapshot update done.");
        return;
      }

      final eventDescription = notableEvents.join(" and ");

      // Fetch accepted friendships for this user
      final queryA = await FirebaseFirestore.instance
          .collection('friendships')
          .where('playerA', isEqualTo: uid)
          .where('status', isEqualTo: 'accepted')
          .get();

      final queryB = await FirebaseFirestore.instance
          .collection('friendships')
          .where('playerB', isEqualTo: uid)
          .where('status', isEqualTo: 'accepted')
          .get();

      final allFriendships = [
        ...queryA.docs.map((doc) => Friendship.fromJson(doc.data(), doc.id)),
        ...queryB.docs.map((doc) => Friendship.fromJson(doc.data(), doc.id)),
      ];

      if (allFriendships.isEmpty) return;

      final now = DateTime.now();

      for (final f in allFriendships) {
        final friendUid = f.playerA == uid ? f.playerB : f.playerA;

        // Suppress if the FRIEND has muted us (the source)
        // mutedBy stores UIDs of the ones who chose to mute notifications from their side
        if (f.mutedBy.contains(friendUid)) {
          debugPrint("🔇 Notifications muted by $friendUid. Skipping.");
          continue;
        }

        // Cooldown check
        final recentEntriesQuery = await FirebaseFirestore.instance
            .collection('players')
            .doc(friendUid)
            .collection('activity_feed')
            .where('sourcePlayerId', isEqualTo: uid)
            .where('type', whereIn: ['level_up', 'building_built', 'streak_milestone', 'bankruptcy'])
            .orderBy('createdAt', descending: true)
            .limit(1)
            .get();

        if (recentEntriesQuery.docs.isNotEmpty) {
          final doc = recentEntriesQuery.docs.first;
          final entry = ActivityEntry.fromJson(doc.data(), doc.id);
          final diff = now.difference(entry.createdAt);

          if (diff < const Duration(minutes: 30)) {
            // Fold into existing entry
            final existingPayload = Map<String, dynamic>.from(entry.payload);
            final List<dynamic> oldEvents = existingPayload['events'] as List? ?? [];
            final Set<String> updatedEvents = {
              ...oldEvents.cast<String>(),
              ...notableEvents,
            };
            final combinedText = updatedEvents.join(" and ");

            await doc.reference.update({
              'type': type,
              'payload': {
                'events': updatedEvents.toList(),
                'text': combinedText,
              },
              'createdAt': FieldValue.serverTimestamp(),
              'seen': false,
            });
            debugPrint("🏙️ Folded event for: $friendUid");
            continue;
          }
        }

        // New entry
        await FirebaseFirestore.instance
            .collection('players')
            .doc(friendUid)
            .collection('activity_feed')
            .add({
          'sourcePlayerId': uid,
          'sourcePlayerName': game.playerName,
          'targetPlayerId': friendUid,
          'type': type,
          'payload': {
            'events': notableEvents,
            'text': eventDescription,
          },
          'createdAt': FieldValue.serverTimestamp(),
          'seen': false,
        });
        debugPrint("🏙️ Notified: $friendUid");
      }
    } catch (e) {
      debugPrint("❌ Error closing edit session: $e");
    } finally {
      _startLevel = null;
      _startStreak = null;
      _startLayout = null;
      _startBankruptcyCount = null;
      _startTrack = null;
    }
  }
}
