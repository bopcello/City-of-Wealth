import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/city_sharing_models.dart';
import 'firestore_service.dart';
import 'notification_service.dart';

class FriendActivityMonitor {
  FriendActivityMonitor._();
  static final instance = FriendActivityMonitor._();

  final _firestore = FirestoreService();

  Future<void> check({required bool showAndroidNotifications}) async {
    final prefs = await SharedPreferences.getInstance();

    // Ensure Firebase Auth session is restored if currentUser is initially null (e.g. in background isolate)
    if (FirebaseAuth.instance.currentUser == null) {
      try {
        await FirebaseAuth.instance.authStateChanges().first.timeout(
          const Duration(seconds: 10),
        );
      } catch (_) {}
    }

    final uid =
        FirebaseAuth.instance.currentUser?.uid ??
        prefs.getString('current_logged_in_uid') ??
        prefs.getString('last_logged_in_uid');
    if (uid == null) return;

    //final notifService = NotificationService();
    final isAppOpen = prefs.getBool('is_app_open') ?? false;
    final bool shouldShowNotifications = showAndroidNotifications && !isAppOpen;

    // Fetch latest user progress to keep notification schedules up to date
    String playerName = prefs.getString("${uid}_playerName") ?? "User";
    int dailyQuizStreak = prefs.getInt("${uid}_dailyQuizStreak") ?? 0;
    int streakRevivals = prefs.getInt("${uid}_streakRevivals") ?? 3;
    String lastDailyQuizDate =
        prefs.getString("${uid}_lastDailyQuizDate") ?? "";

    // Stage 5: Fetch Player Progress
    try {
      final cloudData = await _firestore.getPlayerProgress(uid);
      if (cloudData != null) {
        playerName = (cloudData['playerName'] as String?) ?? playerName;
        dailyQuizStreak =
            (cloudData['dailyQuizStreak'] as num?)?.toInt() ?? dailyQuizStreak;
        streakRevivals =
            (cloudData['streakRevivals'] as num?)?.toInt() ?? streakRevivals;
        lastDailyQuizDate =
            (cloudData['lastDailyQuizDate'] as String?) ?? lastDailyQuizDate;

        // Save back to SharedPreferences
        await prefs.setString("${uid}_playerName", playerName);
        await prefs.setInt("${uid}_dailyQuizStreak", dailyQuizStreak);
        await prefs.setInt("${uid}_streakRevivals", streakRevivals);
        await prefs.setString("${uid}_lastDailyQuizDate", lastDailyQuizDate);
      }
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 5",
      //   body: "Fetched player progress for $uid",
      //   stageId: 5,
      // );
    } catch (e) {
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 5",
      //   body: "FAILED to fetch player progress for $uid",
      //   stageId: 5,
      // );
    }

    try {
      await NotificationService().scheduleDailyChallengeReminders(
        playerName: playerName,
        dailyQuizStreak: dailyQuizStreak,
        streakRevivals: streakRevivals,
        lastDailyQuizDate: lastDailyQuizDate,
      );
    } catch (e) {
      // Ignore background notification scheduling errors
    }

    // Stage 6 & 7 & 8: Fetch Friendships & Friend Cities
    try {
      final friendships = await _firestore.getAcceptedFriendships(uid);

      final fetchedFriendNames = <String>[];
      final failedFriendNames = <String>[];
      final processedFriendNames = <String>[];
      final failedProcessFriendNames = <String>[];

      for (final friendship in friendships) {
        final friendId = friendship.playerA == uid
            ? friendship.playerB
            : friendship.playerA;
        try {
          final city = await _firestore.getPublicCitySnapshot(friendId);
          if (city == null) {
            failedFriendNames.add(friendId);
            continue;
          }

          fetchedFriendNames.add(city.playerName);

          final key = 'friend_city_baseline_${uid}_$friendId';
          final raw = prefs.getString(key);
          if (raw != null) {
            final previous = PublicCitySnapshot.fromJson(jsonDecode(raw));
            final events = _events(previous, city);

            processedFriendNames.add(city.playerName);

            for (final event in events) {
              final eventId =
                  '${friendId}_${city.lastUpdatedAt.millisecondsSinceEpoch}_${event['type']}';
              await _firestore.recordFriendActivity(
                uid,
                eventId,
                friendId,
                city.playerName,
                event,
              );

              final notifiedKey = 'notified_event_$eventId';
              final alreadyNotified = prefs.getBool(notifiedKey) ?? false;

              if (!alreadyNotified) {
                if (shouldShowNotifications) {
                  try {
                    await NotificationService().showFriendActivityNotification(
                      friendId: friendId,
                      friendName: city.playerName,
                      playerName: playerName,
                      event: event,
                    );
                  } catch (e) {
                    // Ignore single notification display errors
                  }
                }
                await prefs.setBool(notifiedKey, true);
              }
            }
          } else {
            processedFriendNames.add(city.playerName);
          }
          final baseline = city.toJson()
            ..['lastUpdatedAt'] = city.lastUpdatedAt.toIso8601String();
          await prefs.setString(key, jsonEncode(baseline));
        } catch (e) {
          failedProcessFriendNames.add(friendId);
        }
      }

      // Stage 6 Notification
      //final friendshipListStr = fetchedFriendNames.isNotEmpty
      //? fetchedFriendNames.join(', ')
      //: '${friendships.length} friends';
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 6",
      //   body: "Fetched ${friendships.length} accepted friendships: $friendshipListStr",
      //   stageId: 6,
      // );

      // Stage 7 Notification
      //if (fetchedFriendNames.isNotEmpty) {
      //final friendListStr = fetchedFriendNames.join(', ');
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 7",
      //   body: "Fetched friend $friendListStr's city from firestore db",
      //   stageId: 7,
      // );
      //}
      //if (failedFriendNames.isNotEmpty) {
      //final failedListStr = failedFriendNames.join(', ');
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 7 Error",
      //   body: "FAILED Fetch friend $failedListStr from firestore db",
      //   stageId: 77,
      // );
      //}

      // Stage 8 Notification
      //if (processedFriendNames.isNotEmpty) {
      //final processedListStr = processedFriendNames.join(', ');
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 8",
      //   body: "Processed events for friend $processedListStr",
      //   stageId: 8,
      // );
      //}
      //if (failedProcessFriendNames.isNotEmpty) {
      //final failedProcStr = failedProcessFriendNames.join(', ');
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 8 Error",
      //   body: "FAILED processing events for friend $failedProcStr",
      //   stageId: 88,
      // );
      //}
    } catch (e) {
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 6",
      //   body: "FAILED to fetch accepted friendships",
      //   stageId: 6,
      // );
    }

    // Stage 9: Check activity feed for friend requests (sent, accepted, denied)
    try {
      final activitySnap = await FirebaseFirestore.instance
          .collection('players')
          .doc(uid)
          .collection('activity_feed')
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      for (final doc in activitySnap.docs) {
        final data = doc.data();
        final type = data['type'] as String?;
        if (type == 'friend_request_sent' ||
            type == 'friend_request_accepted' ||
            type == 'friend_request_denied') {
          final notifiedKey = 'notified_activity_${doc.id}';
          final alreadyNotified = prefs.getBool(notifiedKey) ?? false;
          if (!alreadyNotified) {
            String friendName =
                (data['sourcePlayerName'] as String?) ?? 'A player';
            final sourcePlayerId = data['sourcePlayerId'] as String?;

            if ((friendName == 'A player' ||
                    friendName == 'User' ||
                    friendName.trim().isEmpty) &&
                sourcePlayerId != null &&
                sourcePlayerId.isNotEmpty) {
              final resolvedName = await _firestore.resolvePlayerName(
                sourcePlayerId,
              );
              if (resolvedName.isNotEmpty &&
                  resolvedName != 'A player' &&
                  resolvedName != 'User') {
                friendName = resolvedName;
                try {
                  await doc.reference.update({'sourcePlayerName': friendName});
                } catch (_) {}
              }
            }

            if (shouldShowNotifications) {
              try {
                await NotificationService().showFriendRequestNotification(
                  friendName: friendName,
                  type: type!,
                );
              } catch (e) {
                // Ignore single notification display errors
              }
            }
            await prefs.setBool(notifiedKey, true);
          }
        }
      }
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 9",
      //   body: "Checked activity feed for friend requests",
      //   stageId: 9,
      // );
    } catch (_) {
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 9",
      //   body: "FAILED to check activity feed for friend requests",
      //   stageId: 9,
      // );
    }

    // Clean up any cheers_sent records that have passed the 24-hour window
    await _expireStaleCheersSent(uid);
  }

  /// Deletes any `cheers_sent` documents older than exactly 24 hours.
  /// Called by the background task so the cheer cooldown is lifted promptly.
  Future<void> _expireStaleCheersSent(String uid) async {
    try {
      final cutoff = DateTime.now().subtract(const Duration(hours: 24));
      final snapshot = await FirebaseFirestore.instance
          .collection('players')
          .doc(uid)
          .collection('cheers_sent')
          .get();
      for (final doc in snapshot.docs) {
        final sentAt = (doc.data()['sentAt'] as Timestamp?)?.toDate();
        if (sentAt != null && sentAt.isBefore(cutoff)) {
          await doc.reference.delete();
        }
      }
    } catch (_) {
      // Non-critical — ignore errors during background cleanup
    }
  }

  List<Map<String, dynamic>> _events(
    PublicCitySnapshot before,
    PublicCitySnapshot after,
  ) {
    final events = <Map<String, dynamic>>[];
    if (after.bankruptcyCount > before.bankruptcyCount ||
        (before.level > 1 && after.level == 1)) {
      return [
        {
          'type': 'bankruptcy',
          'events': ['bankruptcy'],
        },
      ];
    }
    if (after.level > before.level) {
      events.add({
        'type': 'level_up',
        'events': ['level_up'],
        'newLevel': after.title,
      });
    }
    final beforeBuildings = <String, int>{};
    final afterBuildings = <String, int>{};
    for (final building in before.buildings) {
      beforeBuildings[building.name] =
          (beforeBuildings[building.name] ?? 0) + 1;
    }
    for (final building in after.buildings) {
      afterBuildings[building.name] = (afterBuildings[building.name] ?? 0) + 1;
    }
    final built = <String>[];
    final destroyed = <String>[];
    for (final entry in afterBuildings.entries) {
      final count = entry.value - (beforeBuildings[entry.key] ?? 0);
      if (count > 0) built.addAll(List.filled(count, entry.key));
    }
    for (final entry in beforeBuildings.entries) {
      final count = entry.value - (afterBuildings[entry.key] ?? 0);
      if (count > 0) destroyed.addAll(List.filled(count, entry.key));
    }
    if (built.isNotEmpty) {
      events.add({
        'type': 'building_built',
        'events': ['building_built'],
        'newBuildings': built,
      });
    }
    if (destroyed.isNotEmpty) {
      events.add({
        'type': 'building_destroyed',
        'events': ['building_destroyed'],
        'destroyedBuildings': destroyed,
      });
    }
    final kp = after.kp - before.kp;
    if (kp != 0) {
      events.add({
        'type': kp > 0 ? 'kp_gained' : 'kp_lost',
        'events': [kp > 0 ? 'kp_gained' : 'kp_lost'],
        'kpChange': kp,
      });
    }
    if (after.streak != before.streak) {
      events.add({
        'type': after.streak > before.streak
            ? 'streak_continued'
            : 'streak_lost',
        'events': [
          after.streak > before.streak ? 'streak_continued' : 'streak_lost',
        ],
        'streak': after.streak,
        'previousStreak': before.streak,
      });
    }
    return events;
  }
}
