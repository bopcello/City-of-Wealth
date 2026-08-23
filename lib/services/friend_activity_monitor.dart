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
    final uid = FirebaseAuth.instance.currentUser?.uid ??
        prefs.getString('current_logged_in_uid') ??
        prefs.getString('last_logged_in_uid');
    if (uid == null) return;

    // Fetch latest user progress to keep notification schedules up to date
    String playerName = prefs.getString("${uid}_playerName") ?? "User";
    int dailyQuizStreak = prefs.getInt("${uid}_dailyQuizStreak") ?? 0;
    int streakRevivals = prefs.getInt("${uid}_streakRevivals") ?? 3;
    String lastDailyQuizDate = prefs.getString("${uid}_lastDailyQuizDate") ?? "";

    try {
      final cloudData = await _firestore.getPlayerProgress(uid);
      if (cloudData != null) {
        playerName = (cloudData['playerName'] as String?) ?? playerName;
        dailyQuizStreak = (cloudData['dailyQuizStreak'] as num?)?.toInt() ?? dailyQuizStreak;
        streakRevivals = (cloudData['streakRevivals'] as num?)?.toInt() ?? streakRevivals;
        lastDailyQuizDate = (cloudData['lastDailyQuizDate'] as String?) ?? lastDailyQuizDate;

        // Save back to SharedPreferences
        await prefs.setString("${uid}_playerName", playerName);
        await prefs.setInt("${uid}_dailyQuizStreak", dailyQuizStreak);
        await prefs.setInt("${uid}_streakRevivals", streakRevivals);
        await prefs.setString("${uid}_lastDailyQuizDate", lastDailyQuizDate);
      }
    } catch (e) {
      // Ignore background firestore load failures, use local fallback
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

    final friendships = await _firestore.getAcceptedFriendships(uid);
    for (final friendship in friendships) {
      final friendId = friendship.playerA == uid ? friendship.playerB : friendship.playerA;
      final city = await _firestore.getPublicCitySnapshot(friendId);
      if (city == null) continue;
      final key = 'friend_city_baseline_${uid}_$friendId';
      final raw = prefs.getString(key);
      if (raw != null) {
        final previous = PublicCitySnapshot.fromJson(jsonDecode(raw));
        final events = _events(previous, city);
        for (final event in events) {
          final eventId = '${friendId}_${city.lastUpdatedAt.millisecondsSinceEpoch}_${event['type']}';
          await _firestore.recordFriendActivity(uid, eventId, friendId, city.playerName, event);

          final notifiedKey = 'notified_event_$eventId';
          final alreadyNotified = prefs.getBool(notifiedKey) ?? false;

          if (showAndroidNotifications || !alreadyNotified) {
            await NotificationService().showFriendActivityNotification(
              friendId: friendId,
              friendName: city.playerName,
              playerName: playerName,
              event: event,
            );
            await prefs.setBool(notifiedKey, true);
          }
        }
      }
      final baseline = city.toJson()
        ..['lastUpdatedAt'] = city.lastUpdatedAt.toIso8601String();
      await prefs.setString(key, jsonEncode(baseline));
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

  List<Map<String, dynamic>> _events(PublicCitySnapshot before, PublicCitySnapshot after) {
    final events = <Map<String, dynamic>>[];
    if (after.bankruptcyCount > before.bankruptcyCount || (before.level > 1 && after.level == 1)) {
      return [{'type': 'bankruptcy', 'events': ['bankruptcy']}];
    }
    if (after.level > before.level) events.add({'type': 'level_up', 'events': ['level_up'], 'newLevel': after.title});
    final beforeBuildings = <String, int>{};
    final afterBuildings = <String, int>{};
    for (final building in before.buildings) {
      beforeBuildings[building.name] = (beforeBuildings[building.name] ?? 0) + 1;
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
    if (built.isNotEmpty) events.add({'type': 'building_built', 'events': ['building_built'], 'newBuildings': built});
    if (destroyed.isNotEmpty) events.add({'type': 'building_destroyed', 'events': ['building_destroyed'], 'destroyedBuildings': destroyed});
    final kp = after.kp - before.kp;
    if (kp != 0) events.add({'type': kp > 0 ? 'kp_gained' : 'kp_lost', 'events': [kp > 0 ? 'kp_gained' : 'kp_lost'], 'kpChange': kp});
    if (after.streak != before.streak) events.add({'type': after.streak > before.streak ? 'streak_continued' : 'streak_lost', 'events': [after.streak > before.streak ? 'streak_continued' : 'streak_lost'], 'streak': after.streak, 'previousStreak': before.streak});
    return events;
  }
}
