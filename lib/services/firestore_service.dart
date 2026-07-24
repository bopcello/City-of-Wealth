import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import '../data/quote_data.dart';
import '../models/city_sharing_models.dart';
import '../game_state.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Saves the player's progress to Firestore.
  /// The [uid] is the user's unique identifier from Firebase Auth.
  /// The [data] is a map containing all game state information.
  Future<void> savePlayerProgress(String uid, Map<String, dynamic> data) async {
    if (uid.isEmpty) {
      debugPrint("⚠️ Skipping Firestore save: UID is empty");
      return;
    }

    if (data.isEmpty) {
      debugPrint("⚠️ Skipping Firestore save for user $uid: Data map is empty");
      return;
    }

    try {
      debugPrint(
        "📤 CLOUD SAVE: Syncing ${data.keys.length} fields for user: $uid",
      );
      // debugPrint("📤 Full Data Map: $data"); // Uncomment if verbose debug is needed

      await _db.collection('players').doc(uid).set({
        ...data,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint("✅ CLOUD SAVE: Success");

      // Also update public_cities snapshot so friends always see the up-to-date city
      try {
        final playerDoc = await _db.collection('players').doc(uid).get();
        if (playerDoc.exists && playerDoc.data() != null) {
          final snapshot = buildSnapshotFromPlayerData(uid, playerDoc.data()!);
          await savePublicCitySnapshot(snapshot);
        }
      } catch (e) {
        debugPrint("Notice: could not sync public_cities on save: $e");
      }
    } catch (e) {
      debugPrint("❌ CLOUD SAVE: Error - $e");
      rethrow;
    }
  }

  /// Retrieves the player's progress from Firestore.
  /// Returns null if no progress is found.
  Future<Map<String, dynamic>?> getPlayerProgress(String uid) async {
    try {
      debugPrint("📥 CLOUD LOAD: Fetching progress for user: $uid");
      final doc = await _db.collection('players').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        debugPrint("✅ CLOUD LOAD: Success. doc.data(): $data");
        return data;
      } else {
        debugPrint("ℹ️ CLOUD LOAD: No document found");
        return null;
      }
    } catch (e) {
      debugPrint("❌ CLOUD LOAD: Error - $e");
      rethrow;
    }
  }

  /// Retrieves the daily quiz for a specific date.
  Future<Map<String, dynamic>?> getDailyQuiz(String date) async {
    try {
      final doc = await _db.collection('daily_quizzes').doc('daily_$date').get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      debugPrint("❌ Error fetching daily quiz: $e");
      return null;
    }
  }

  /// Retrieves the daily financial quote for a specific date or from cache/local fallback.
  Future<Map<String, dynamic>> getDailyQuote(String date) async {
    try {
      final doc = await _db.collection('daily_quotes').doc('daily_$date').get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!;
      }
      final todayDoc = await _db.collection('daily_quotes').doc('today').get();
      if (todayDoc.exists && todayDoc.data() != null) {
        return todayDoc.data()!;
      }
      final cacheDoc = await _db.collection('daily_quotes').doc('cache').get();
      if (cacheDoc.exists && cacheDoc.data() != null) {
        final quotes = (cacheDoc.data()?['quotes'] as List?) ?? [];
        if (quotes.isNotEmpty) {
          final index = DateTime.now().day % quotes.length;
          return Map<String, dynamic>.from(quotes[index]);
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching daily quote: $e");
    }
    return getRandomLocalQuote();
  }

  /// Retrieves the last 30 daily quizzes.
  Future<List<Map<String, dynamic>>> getRecentDailyQuizzes() async {
    try {
      final query = await _db
          .collection('daily_quizzes')
          .orderBy('timestamp', descending: true)
          .limit(30)
          .get();
      return query.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("❌ Error fetching recent quizzes: $e");
      return [];
    }
  }

  Future<void> updatePlayerStreak(String uid, int streak, String date, int revivals, String? lastRevival) async {
    try {
      await _db.collection('players').doc(uid).update({
        'dailyQuizStreak': streak,
        'lastDailyQuizDate': date,
        'streakRevivals': revivals,
        'lastRevivalDate': lastRevival,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("❌ Error updating player streak: $e");
    }
  }

  String getFriendshipId(String uidA, String uidB) =>
      uidA.compareTo(uidB) < 0 ? '${uidA}_$uidB' : '${uidB}_$uidA';

  Future<void> sendFriendRequest(String sourceUid, String targetUid) async {
    final docId = getFriendshipId(sourceUid, targetUid);
    await _db.collection('friendships').doc(docId).set({
      'playerA': sourceUid.compareTo(targetUid) < 0 ? sourceUid : targetUid,
      'playerB': sourceUid.compareTo(targetUid) < 0 ? targetUid : sourceUid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'requestedBy': sourceUid,
      'mutedBy': [],
    }, SetOptions(merge: true));

    try {
      final sourceSnap = await _db.collection('players').doc(sourceUid).get();
      final sourceName = sourceSnap.data()?['playerName'] as String? ?? 'A player';
      await _db.collection('players').doc(targetUid).collection('activity_feed').add({
        'sourcePlayerId': sourceUid,
        'sourcePlayerName': sourceName,
        'targetPlayerId': targetUid,
        'type': 'friend_request_sent',
        'payload': {'text': 'sent you a friend request'},
        'createdAt': FieldValue.serverTimestamp(),
        'seen': false,
      });
    } catch (e) {
      debugPrint("Error logging friend request activity: $e");
    }
  }

  Future<void> acceptFriendRequest(String friendshipId) async {
    await _db.collection('friendships').doc(friendshipId).update({
      'status': 'accepted',
    });

    try {
      final docSnap = await _db.collection('friendships').doc(friendshipId).get();
      if (docSnap.exists && docSnap.data() != null) {
        final data = docSnap.data()!;
        final playerA = data['playerA'] as String;
        final playerB = data['playerB'] as String;
        final requestedBy = data['requestedBy'] as String;
        final acceptorUid = requestedBy == playerA ? playerB : playerA;
        final requestorUid = requestedBy;

        final acceptorSnap = await _db.collection('players').doc(acceptorUid).get();
        final acceptorName = acceptorSnap.data()?['playerName'] as String? ?? 'A player';

        await _db.collection('players').doc(requestorUid).collection('activity_feed').add({
          'sourcePlayerId': acceptorUid,
          'sourcePlayerName': acceptorName,
          'targetPlayerId': requestorUid,
          'type': 'friend_request_accepted',
          'payload': {'text': 'accepted your friend request'},
          'createdAt': FieldValue.serverTimestamp(),
          'seen': false,
        });
      }
    } catch (e) {
      debugPrint("Error logging friend acceptance activity: $e");
    }
  }

  Future<void> declineFriendRequest(String friendshipId) async {
    await _db.collection('friendships').doc(friendshipId).delete();
  }

  Future<void> blockUser(String friendshipId, String blockingUid) async {
    await _db.collection('friendships').doc(friendshipId).set({
      'status': 'blocked',
      'requestedBy': blockingUid,
    }, SetOptions(merge: true));
  }

  Future<void> unblockUser(String friendshipId) async {
    await _db.collection('friendships').doc(friendshipId).delete();
  }


  Future<void> toggleMuteFriend(String friendshipId, String uid, bool mute) async {
    if (mute) {
      await _db.collection('friendships').doc(friendshipId).update({
        'mutedBy': FieldValue.arrayUnion([uid]),
      });
    } else {
      await _db.collection('friendships').doc(friendshipId).update({
        'mutedBy': FieldValue.arrayRemove([uid]),
      });
    }
  }

  Stream<List<Friendship>> getFriendshipsStream(String uid) {
    final controller = StreamController<List<Friendship>>();
    
    StreamSubscription? subA;
    StreamSubscription? subB;
    
    List<Friendship> listA = [];
    List<Friendship> listB = [];
    
    void emit() {
      final mergedMap = <String, Friendship>{};
      for (var f in listA) { mergedMap[f.id] = f; }
      for (var f in listB) { mergedMap[f.id] = f; }
      controller.add(mergedMap.values.toList());
    }
    
    subA = _db.collection('friendships')
        .where('playerA', isEqualTo: uid)
        .snapshots()
        .listen((snap) {
          listA = snap.docs.map((doc) => Friendship.fromJson(doc.data(), doc.id)).toList();
          emit();
        }, onError: (e) {
          debugPrint("Stream playerA error: $e");
        });

    subB = _db.collection('friendships')
        .where('playerB', isEqualTo: uid)
        .snapshots()
        .listen((snap) {
          listB = snap.docs.map((doc) => Friendship.fromJson(doc.data(), doc.id)).toList();
          emit();
        }, onError: (e) {
          debugPrint("Stream playerB error: $e");
        });

    controller.onCancel = () {
      subA?.cancel();
      subB?.cancel();
    };

    return controller.stream;
  }

  Future<List<Map<String, dynamic>>> searchUserByCodeOrName(String query) async {
    if (query.trim().isEmpty) return [];
    final cleanQuery = query.trim();
    
    try {
      final allPlayersSnap = await _db.collection('players').get();
      final allPlayers = allPlayersSnap.docs.map((doc) => {...doc.data(), 'uid': doc.id}).toList();
      
      RegExp regex;
      try {
        regex = RegExp(cleanQuery, caseSensitive: false);
      } catch (_) {
        final escaped = RegExp.escape(cleanQuery);
        regex = RegExp(escaped, caseSensitive: false);
      }

      final results = allPlayers.where((player) {
        final playerName = player['playerName'] as String? ?? '';
        final friendCode = player['friendCode'] as String? ?? '';
        return regex.hasMatch(playerName) || regex.hasMatch(friendCode);
      }).toList();

      if (results.length > 15) {
        return results.sublist(0, 15);
      }
      return results;
    } catch (e) {
      debugPrint("❌ Error searching users: $e");
      return [];
    }
  }

  Future<PublicCitySnapshot?> getPublicCitySnapshot(String uid) async {
    try {
      final doc = await _db.collection('public_cities').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return PublicCitySnapshot.fromJson(doc.data()!);
      }

      // Fallback: If public_cities/{uid} doc does not exist yet, construct from players/{uid}
      final playerDoc = await _db.collection('players').doc(uid).get();
      if (playerDoc.exists && playerDoc.data() != null) {
        final snapshot = buildSnapshotFromPlayerData(uid, playerDoc.data()!);
        // Asynchronously save to public_cities so future reads are instant
        savePublicCitySnapshot(snapshot).catchError((e) {
          debugPrint("Notice: Auto-caching public city snapshot error: $e");
        });
        return snapshot;
      }
    } catch (e) {
      debugPrint("❌ Error getting public city snapshot for $uid: $e");
    }
    return null;
  }

  PublicCitySnapshot buildSnapshotFromPlayerData(String uid, Map<String, dynamic> data) {
    List<PlacedBuilding> buildings = [];
    final layoutData = data['cityLayout'];
    if (layoutData != null) {
      try {
        if (layoutData is String && layoutData.isNotEmpty) {
          final decoded = jsonDecode(layoutData);
          if (decoded is List) {
            buildings = decoded
                .map((b) => PlacedBuilding.fromJson(Map<String, dynamic>.from(b)))
                .toList();
          }
        } else if (layoutData is List) {
          buildings = layoutData
              .map((b) => PlacedBuilding.fromJson(Map<String, dynamic>.from(b)))
              .toList();
        }
      } catch (e) {
        debugPrint("Error parsing fallback city layout: $e");
      }
    }

    final trackStr = (data['careerTrack'] as String?) ?? 'student';
    CareerTrack track = CareerTrack.student;
    if (trackStr == 'job') track = CareerTrack.job;
    if (trackStr == 'business') track = CareerTrack.business;
    final level = (data['careerLevel'] as num?)?.toInt() ?? 1;

    final titleStr = (data['title'] as String?) ?? levelName(track, level);

    return PublicCitySnapshot(
      playerId: uid,
      playerName: (data['playerName'] as String?) ?? 'Unknown Player',
      friendCode: (data['friendCode'] as String?) ?? '',
      track: trackStr,
      level: level,
      title: titleStr,
      streak: (data['dailyQuizStreak'] as num?)?.toInt() ?? 0,
      kp: (data['kp'] as num?)?.toInt() ?? 0,
      buildings: buildings,
      buildingCount: buildings.length,
      lastUpdatedAt: DateTime.now(),
    );
  }

  Future<void> savePublicCitySnapshot(PublicCitySnapshot snapshot) async {
    await _db.collection('public_cities').doc(snapshot.playerId).set({
      ...snapshot.toJson(),
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    });
  }


  Stream<List<ActivityEntry>> getActivityFeedStream(String uid) {
    return _db.collection('players').doc(uid).collection('activity_feed')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => ActivityEntry.fromJson(doc.data(), doc.id)).toList());
  }

  Future<void> markActivityAsSeen(String uid, String activityId) async {
    await _db.collection('players').doc(uid).collection('activity_feed').doc(activityId).update({
      'seen': true,
    });
  }

  Future<void> markAllActivitiesAsSeen(String uid) async {
    final query = await _db.collection('players').doc(uid).collection('activity_feed').where('seen', isEqualTo: false).get();
    final batch = _db.batch();
    for (var doc in query.docs) {
      batch.update(doc.reference, {'seen': true});
    }
    await batch.commit();
  }

  Future<void> fanOutActivity(String sourceUid, String sourceName, List<String> targetUids, String type, Map<String, dynamic> payload) async {
    if (targetUids.isEmpty) return;
    final batch = _db.batch();
    for (var targetUid in targetUids) {
      final ref = _db.collection('players').doc(targetUid).collection('activity_feed').doc();
      batch.set(ref, {
        'sourcePlayerId': sourceUid,
        'sourcePlayerName': sourceName,
        'targetPlayerId': targetUid,
        'type': type,
        'payload': payload,
        'createdAt': FieldValue.serverTimestamp(),
        'seen': false,
      });
    }
    await batch.commit();
  }
}
