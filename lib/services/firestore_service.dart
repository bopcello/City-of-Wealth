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
  Future<void> savePlayerProgress(
    String uid,
    Map<String, dynamic> data, {
    String? publicProfilePic,
    bool updatePublicProfilePic = false,
  }) async {
    if (uid.isEmpty) {
      debugPrint("⚠️ Skipping Firestore save: UID is empty");
      return;
    }

    if (data.isEmpty) {
      debugPrint("⚠️ Skipping Firestore save for user $uid: Data map is empty");
      return;
    }

    // FCM is fully removed — never persist these fields again even if a
    // stale call site still passes them.
    final sanitized = Map<String, dynamic>.from(data)
      ..remove('fcmToken')
      ..remove('fcmTokenUpdatedAt');

    try {
      debugPrint(
        "📤 CLOUD SAVE: Syncing ${sanitized.keys.length} fields for user: $uid",
      );

      final playerRef = _db.collection('players').doc(uid);

      // This used to be 1 write + 1 read + 2 more writes (4 separate round
      // trips to Firestore) every single time progress synced — including
      // once per lifecycle callback when the app closes. It's now a single
      // read (to know the merged doc shape for the public snapshot)
      // followed by one batched commit that writes
      // players/public_cities/public_profiles together as one call.
      final batch = _db.batch();
      batch.set(playerRef, {
        ...sanitized,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      try {
        final playerDoc = await playerRef.get();
        final mergedData = <String, dynamic>{
          if (playerDoc.exists && playerDoc.data() != null)
            ...playerDoc.data()!,
          ...sanitized,
        };

        var snapshot = buildSnapshotFromPlayerData(uid, mergedData);
        if (updatePublicProfilePic) {
          snapshot = snapshot.copyWith(profilePic: publicProfilePic);
        }

        final publicCityData = snapshot.toJson();
        if (!updatePublicProfilePic) {
          publicCityData.remove('profilePic');
        } else if (snapshot.profilePic == null) {
          publicCityData['profilePic'] = FieldValue.delete();
        }

        batch.set(_db.collection('public_cities').doc(uid), {
          ...publicCityData,
          'lastUpdatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        batch.set(_db.collection('public_profiles').doc(uid), {
          'playerName': snapshot.playerName,
          'friendCode': snapshot.friendCode,
        });
      } catch (e) {
        debugPrint(
          "Notice: could not prepare public_cities/public_profiles sync: $e",
        );
      }

      await batch.commit();
      debugPrint("✅ CLOUD SAVE: Success (single batched write)");
    } catch (e) {
      debugPrint("❌ CLOUD SAVE: Error - $e");
      rethrow;
    }
  }

  /// Publishes only the fields needed for friend search — never the full
  /// private game state. A plain (non-merge) `.set()` so the doc can only
  /// ever contain exactly these two fields, matching the security rule.
  Future<void> savePublicProfile(
    String uid,
    String playerName,
    String friendCode,
  ) async {
    if (uid.isEmpty) return;
    try {
      await _db.collection('public_profiles').doc(uid).set({
        'playerName': playerName,
        'friendCode': friendCode,
      });
    } catch (e) {
      debugPrint("Notice: could not sync public_profiles: $e");
    }
  }

  /// Self-heals `public_profiles` + `public_cities` from in-memory state
  /// without waiting for a full cloud sync. Called on every app load so
  /// accounts created before these collections existed catch up
  /// automatically instead of being locked out of search/city-viewing.
  Future<void> ensurePublicRecords({
    required String uid,
    required String playerName,
    required String friendCode,
    required String track,
    required int level,
    required String title,
    required int streak,
    required int kp,
    required int bankruptcyCount,
    required List<PlacedBuilding> buildings,
    String? profilePic,
  }) async {
    await savePublicProfile(uid, playerName, friendCode);
    final snapshot = PublicCitySnapshot(
      playerId: uid,
      playerName: playerName,
      friendCode: friendCode,
      track: track,
      level: level,
      title: title,
      streak: streak,
      kp: kp,
      bankruptcyCount: bankruptcyCount,
      buildings: buildings,
      buildingCount: buildings.length,
      lastUpdatedAt: DateTime.now(),
      profilePic: profilePic,
    );
    await savePublicCitySnapshot(
      snapshot,
      includeProfilePic: profilePic != null,
    );
  }

  /// One-time cleanup: strips the deprecated FCM fields from a player's
  /// private doc now that push notifications go through local scheduling
  /// only. Safe to call repeatedly; no-ops once the fields are gone.
  Future<void> purgeFcmToken(String uid) async {
    if (uid.isEmpty) return;
    try {
      await _db.collection('players').doc(uid).update({
        'fcmToken': FieldValue.delete(),
        'fcmTokenUpdatedAt': FieldValue.delete(),
      });
    } catch (e) {
      debugPrint("Notice: fcmToken purge skipped: $e");
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
      final doc = await _db
          .collection('daily_quizzes')
          .doc('daily_$date')
          .get();
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

  Future<void> updatePlayerStreak(
    String uid,
    int streak,
    String date,
    int revivals,
    String? lastRevival,
  ) async {
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

  Future<String> resolvePlayerName(String uid) async {
    if (uid.isEmpty) return 'A player';
    try {
      final profileSnap = await _db.collection('public_profiles').doc(uid).get();
      if (profileSnap.exists && profileSnap.data() != null) {
        final name = profileSnap.data()?['playerName'] as String?;
        if (name != null && name.trim().isNotEmpty && name != 'User') {
          return name.trim();
        }
      }
    } catch (_) {}

    try {
      final citySnap = await _db.collection('public_cities').doc(uid).get();
      if (citySnap.exists && citySnap.data() != null) {
        final name = citySnap.data()?['playerName'] as String?;
        if (name != null && name.trim().isNotEmpty && name != 'User') {
          return name.trim();
        }
      }
    } catch (_) {}

    try {
      final playerSnap = await _db.collection('players').doc(uid).get();
      if (playerSnap.exists && playerSnap.data() != null) {
        final name = playerSnap.data()?['playerName'] as String?;
        if (name != null && name.trim().isNotEmpty && name != 'User') {
          return name.trim();
        }
      }
    } catch (_) {}

    return 'A player';
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
      final sourceName = await resolvePlayerName(sourceUid);
      await _db
          .collection('players')
          .doc(targetUid)
          .collection('activity_feed')
          .add({
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
      final docSnap = await _db
          .collection('friendships')
          .doc(friendshipId)
          .get();
      if (docSnap.exists && docSnap.data() != null) {
        final data = docSnap.data()!;
        final playerA = data['playerA'] as String;
        final playerB = data['playerB'] as String;
        final requestedBy = data['requestedBy'] as String;
        final acceptorUid = requestedBy == playerA ? playerB : playerA;
        final requestorUid = requestedBy;

        final acceptorName = await resolvePlayerName(acceptorUid);

        await _db
            .collection('players')
            .doc(requestorUid)
            .collection('activity_feed')
            .add({
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
    try {
      final docSnap = await _db.collection('friendships').doc(friendshipId).get();
      if (docSnap.exists && docSnap.data() != null) {
        final data = docSnap.data()!;
        final playerA = data['playerA'] as String;
        final playerB = data['playerB'] as String;
        final requestedBy = data['requestedBy'] as String?;
        if (requestedBy != null) {
          final declinerUid = requestedBy == playerA ? playerB : playerA;
          final requestorUid = requestedBy;

          final declinerName = await resolvePlayerName(declinerUid);

          await _db
              .collection('players')
              .doc(requestorUid)
              .collection('activity_feed')
              .add({
                'sourcePlayerId': declinerUid,
                'sourcePlayerName': declinerName,
                'targetPlayerId': requestorUid,
                'type': 'friend_request_denied',
                'payload': {'text': 'denied your friend request'},
                'createdAt': FieldValue.serverTimestamp(),
                'seen': false,
              });
        }
      }
    } catch (e) {
      debugPrint("Error logging friend denial activity: $e");
    }

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

  Future<void> toggleMuteFriend(
    String friendshipId,
    String uid,
    bool mute,
  ) async {
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
      for (var f in listA) {
        mergedMap[f.id] = f;
      }
      for (var f in listB) {
        mergedMap[f.id] = f;
      }
      controller.add(mergedMap.values.toList());
    }

    subA = _db
        .collection('friendships')
        .where('playerA', isEqualTo: uid)
        .snapshots()
        .listen(
          (snap) {
            listA = snap.docs
                .map((doc) => Friendship.fromJson(doc.data(), doc.id))
                .toList();
            emit();
          },
          onError: (e) {
            debugPrint("Stream playerA error: $e");
          },
        );

    subB = _db
        .collection('friendships')
        .where('playerB', isEqualTo: uid)
        .snapshots()
        .listen(
          (snap) {
            listB = snap.docs
                .map((doc) => Friendship.fromJson(doc.data(), doc.id))
                .toList();
            emit();
          },
          onError: (e) {
            debugPrint("Stream playerB error: $e");
          },
        );

    controller.onCancel = () {
      subA?.cancel();
      subB?.cancel();
    };

    return controller.stream;
  }

  Future<List<Friendship>> getAcceptedFriendships(String uid) async {
    final results = await Future.wait([
      _db
          .collection('friendships')
          .where('playerA', isEqualTo: uid)
          .where('status', isEqualTo: 'accepted')
          .get(),
      _db
          .collection('friendships')
          .where('playerB', isEqualTo: uid)
          .where('status', isEqualTo: 'accepted')
          .get(),
    ]);
    return [
      ...results[0].docs,
      ...results[1].docs,
    ].map((doc) => Friendship.fromJson(doc.data(), doc.id)).toList();
  }

  Future<void> recordFriendActivity(
    String uid,
    String eventId,
    String friendId,
    String friendName,
    Map<String, dynamic> payload,
  ) {
    return _db
        .collection('players')
        .doc(uid)
        .collection('activity_feed')
        .doc(eventId)
        .set({
          'sourcePlayerId': friendId,
          'sourcePlayerName': friendName,
          'targetPlayerId': uid,
          'type': 'session_summary',
          'payload': payload,
          'createdAt': FieldValue.serverTimestamp(),
          'seen': false,
        });
  }

  Future<List<Map<String, dynamic>>> searchUserByCodeOrName(
    String query,
  ) async {
    if (query.trim().isEmpty) return [];
    final cleanQuery = query.trim();

    try {
      // Only the small, intentionally-public profile collection is read now
      // (playerName + friendCode). The private `players` collection is
      // never bulk-downloaded for search.
      final publicProfilesSnap = await _db.collection('public_profiles').get();
      final allProfiles = publicProfilesSnap.docs
          .map((doc) => {...doc.data(), 'uid': doc.id})
          .toList();

      RegExp regex;
      try {
        regex = RegExp(cleanQuery, caseSensitive: false);
      } catch (_) {
        final escaped = RegExp.escape(cleanQuery);
        regex = RegExp(escaped, caseSensitive: false);
      }

      final results = allProfiles.where((profile) {
        final playerName = profile['playerName'] as String? ?? '';
        final friendCode = profile['friendCode'] as String? ?? '';
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
      // No fallback to players/{uid} anymore — that collection is private
      // and no longer cross-readable. Every signed-in client now
      // self-publishes its own public_cities doc on load (see
      // GameManager._ensurePublicRecords), so a null here should only
      // happen for an account that hasn't opened the app since this
      // change shipped.
    } catch (e) {
      debugPrint("❌ Error getting public city snapshot for $uid: $e");
    }
    return null;
  }

  PublicCitySnapshot buildSnapshotFromPlayerData(
    String uid,
    Map<String, dynamic> data,
  ) {
    List<PlacedBuilding> buildings = [];
    final layoutData = data['cityLayout'];
    if (layoutData != null) {
      try {
        if (layoutData is String && layoutData.isNotEmpty) {
          final decoded = jsonDecode(layoutData);
          if (decoded is List) {
            buildings = decoded
                .map(
                  (b) => PlacedBuilding.fromJson(Map<String, dynamic>.from(b)),
                )
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
    final showPfpPublicly = (data['showPfpPublicly'] as bool?) ?? false;
    final profilePic = showPfpPublicly ? (data['profilePic'] as String?) : null;

    return PublicCitySnapshot(
      playerId: uid,
      playerName: (data['playerName'] as String?) ?? 'Unknown Player',
      friendCode: (data['friendCode'] as String?) ?? '',
      track: trackStr,
      level: level,
      title: titleStr,
      streak: (data['dailyQuizStreak'] as num?)?.toInt() ?? 0,
      kp: (data['kp'] as num?)?.toInt() ?? 0,
      bankruptcyCount: (data['bankruptcyCount'] as num?)?.toInt() ?? 0,
      buildings: buildings,
      buildingCount: buildings.length,
      lastUpdatedAt: DateTime.now(),
      profilePic: profilePic,
    );
  }

  Future<void> savePublicCitySnapshot(
    PublicCitySnapshot snapshot, {
    bool includeProfilePic = true,
  }) async {
    final data = snapshot.toJson();
    if (!includeProfilePic) {
      data.remove('profilePic');
    } else if (snapshot.profilePic == null) {
      data['profilePic'] = FieldValue.delete();
    }
    await _db.collection('public_cities').doc(snapshot.playerId).set({
      ...data,
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Delete user data completely
  Future<void> deleteUserData(String uid) async {
    await _deleteSubcollection(
      _db.collection('players').doc(uid).collection('activity_feed'),
    );
    await _deleteSubcollection(
      _db.collection('players').doc(uid).collection('cheers_sent'),
    );

    final asA = await _db
        .collection('friendships')
        .where('playerA', isEqualTo: uid)
        .get();
    final asB = await _db
        .collection('friendships')
        .where('playerB', isEqualTo: uid)
        .get();
    final batch = _db.batch();
    for (final doc in [...asA.docs, ...asB.docs]) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    await _db.collection('players').doc(uid).delete();
    await _db.collection('public_cities').doc(uid).delete();
    await _db.collection('public_profiles').doc(uid).delete();
  }

  Future<void> _deleteSubcollection(CollectionReference ref) async {
    final snap = await ref.get();
    if (snap.docs.isEmpty) return;
    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<List<ActivityEntry>> getActivityFeedStream(String uid) {
    return _db
        .collection('players')
        .doc(uid)
        .collection('activity_feed')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ActivityEntry.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> markActivityAsSeen(String uid, String activityId) async {
    await _db
        .collection('players')
        .doc(uid)
        .collection('activity_feed')
        .doc(activityId)
        .update({'seen': true});
  }

  Future<void> markAllActivitiesAsSeen(String uid) async {
    final query = await _db
        .collection('players')
        .doc(uid)
        .collection('activity_feed')
        .where('seen', isEqualTo: false)
        .get();
    final batch = _db.batch();
    for (var doc in query.docs) {
      batch.update(doc.reference, {'seen': true});
    }
    await batch.commit();
  }

  Future<void> fanOutActivity(
    String sourceUid,
    String sourceName,
    List<String> targetUids,
    String type,
    Map<String, dynamic> payload,
  ) async {
    if (targetUids.isEmpty) return;
    final batch = _db.batch();
    for (var targetUid in targetUids) {
      final ref = _db
          .collection('players')
          .doc(targetUid)
          .collection('activity_feed')
          .doc();
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
