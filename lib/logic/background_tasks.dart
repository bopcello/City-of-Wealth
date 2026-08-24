import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../firebase_options.dart';
import '../services/firestore_service.dart';
import '../services/friend_activity_monitor.dart';
import '../services/notification_service.dart';

/// ============================================================================
/// Notifications for each stage of background task
/// ============================================================================
/// - Stage 1:  "app woke up successfuly" : "app FAILED to wake up"
/// - Stage 2:  "App firebase init successful in bg" : "App firebase init NOT successful in bg"
/// - Stage 3:  "App firebase auth successful in bg" : "App firebase auth NOT successful in bg"
/// - Stage 4:  "Notification service init successful in bg" : "Notification service init NOT successful in bg"
/// - Stage 5:  "Fetched player progress for {uid}" : "FAILED to fetch player progress for {uid}"
/// - Stage 6:  "Fetched {count} accepted friendships" : "FAILED to fetch accepted friendships"
/// - Stage 7:  "Fetched friend {xxxx}'s city from firestore db" : "FAILED Fetch friend {xxxx} from firestore db"
/// - Stage 8:  "Processed {count} events for friend {xxxx}" : "FAILED processing events for friend {xxxx}"
/// - Stage 9:  "Checked activity feed for friend requests" : "FAILED to check activity feed for friend requests"
/// - Stage 10: "Background task completed successfully" : "Background task FAILED"
/// ============================================================================

/// Top-level entry point for the background isolate required by Flutter AOT and WorkManager.
/// Top-level entry point for the background isolate required by Flutter AOT and WorkManager.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final notifService = NotificationService();
    try {
      WidgetsFlutterBinding.ensureInitialized();

      // Stage 1: Isolate Wakeup
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 1",
      //   body: "app woke up successfuly",
      //   stageId: 1,
      // );

      // Stage 2: Ensure Firebase is initialized in the background isolate
      try {
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        }
        // await notifService.showDebugStageNotification(
        //   title: "Background Task Stage 2",
        //   body: "App firebase init successful in bg",
        //   stageId: 2,
        // );
      } catch (e) {
        // await notifService.showDebugStageNotification(
        //   title: "Background Task Stage 2",
        //   body: "App firebase init NOT successful in bg",
        //   stageId: 2,
        // );
        rethrow;
      }

      // Stage 3: Wait briefly for Firebase Auth session to restore if needed
      try {
        if (FirebaseAuth.instance.currentUser == null) {
          await FirebaseAuth.instance.authStateChanges().first.timeout(
            const Duration(seconds: 4),
          );
        }
        // await notifService.showDebugStageNotification(
        //   title: "Background Task Stage 3",
        //   body: "App firebase auth successful in bg",
        //   stageId: 3,
        // );
      } catch (_) {
        // await notifService.showDebugStageNotification(
        //   title: "Background Task Stage 3",
        //   body: "App firebase auth NOT successful in bg",
        //   stageId: 3,
        // );
      }

      // Stage 4: Initialize NotificationService in the background isolate
      try {
        await notifService.initialize();
        // await notifService.showDebugStageNotification(
        //   title: "Background Task Stage 4",
        //   body: "Notification service init successful in bg",
        //   stageId: 4,
        // );
      } catch (e) {
        // await notifService.showDebugStageNotification(
        //   title: "Background Task Stage 4",
        //   body: "Notification service init NOT successful in bg",
        //   stageId: 4,
        // );
      }

      // Check Quiet Hours Exception Window (12:00 AM to wakeUpHour rounded down)
      final prefs = await SharedPreferences.getInstance();

      // Auto-stop background tasks after 30 days of complete user inactivity
      final lastOpenTs = prefs.getInt('last_app_open_timestamp');
      if (lastOpenTs != null) {
        final lastOpen = DateTime.fromMillisecondsSinceEpoch(lastOpenTs);
        if (DateTime.now().difference(lastOpen).inDays >= 30) {
          debugPrint(
            "🛑 User inactive for 30+ days. Auto-cancelling background tasks.",
          );
          await Workmanager().cancelAll();
          return true;
        }
      }

      final uid =
          FirebaseAuth.instance.currentUser?.uid ??
          prefs.getString('current_logged_in_uid') ??
          prefs.getString('last_logged_in_uid');
      final wakeUpHourKeyScoped = uid != null
          ? "${uid}_wakeUpHour"
          : 'wakeUpHour';
      final wakeUpHour =
          prefs.getInt(wakeUpHourKeyScoped) ?? prefs.getInt('wakeUpHour') ?? 8;
      final currentHour = DateTime.now().hour;

      if (currentHour < wakeUpHour && wakeUpHour > 0) {
        debugPrint(
          "🌙 Quiet hours (12 AM to $wakeUpHour:00 AM): Skipping background friend activity check",
        );
        return true;
      }

      if (task == BackgroundTaskManager.dailyQuizSyncTask ||
          task == BackgroundTaskManager.quizSyncTag) {
        // 3:00 AM Daily Quiz Sync
        final now = DateTime.now();
        final dateStr = DateFormat('yyyy-MM-dd').format(now);

        final quiz = await FirestoreService().getDailyQuiz(dateStr);
        if (quiz != null) {
          final lastDailyQuizDateKeyScoped = uid != null
              ? "${uid}_lastDailyQuizDate"
              : 'lastDailyQuizDate';
          final lastDate = prefs.getString(lastDailyQuizDateKeyScoped) ?? "";

          if (lastDate != dateStr) {
            final newQuizReadyKeyScoped = uid != null
                ? "${uid}_new_quiz_ready"
                : 'new_quiz_ready';
            await prefs.setBool(newQuizReadyKeyScoped, true);
            await prefs.setBool('new_quiz_ready', true);
            debugPrint(
              "📅 Background Sync: New 3:00 AM quiz detected for $dateStr",
            );
          }
        }
      } else {
        // Hourly Friend Activity & Request Monitoring
        await FriendActivityMonitor.instance.check(
          showAndroidNotifications: true,
        );
      }

      // Stage 10: Task Completion
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Stage 10",
      //   body: "Background task completed successfully",
      //   stageId: 10,
      // );

      return true;
    } catch (e) {
      debugPrint("❌ Background Sync Error ($task): $e");
      // await notifService.showDebugStageNotification(
      //   title: "Background Task Error",
      //   body: "Background task FAILED",
      //   stageId: 10,
      // );
      // Return true so Workmanager registers task completion successfully
      return true;
    }
  });
}

class BackgroundTaskManager {
  static const String dailyQuizSyncTask = "daily_quiz_sync";
  static const String quizSyncTag = "quiz_sync";
  static const String friendActivitySyncTask = "friend_activity_sync";
  static const String friendSyncTag = "friend_activity_sync";

  /// Initialize Workmanager and register the callback dispatcher.
  static Future<void> initialize() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await Workmanager().initialize(callbackDispatcher);
      if (Platform.isAndroid) {
        try {
          const channel = MethodChannel("com.city_of_wealth/share");
          await channel.invokeMethod("requestIgnoreBatteryOptimizations");
        } catch (_) {}
      }
    }
  }

  /// Schedules all necessary background tasks aligned to clock hours.
  static Future<void> scheduleTasks() async {
    debugPrint("⏳ Registering background tasks with WorkManager...");

    // 1. Hourly friend activity and friend request check (Periodic)
    await Workmanager().registerPeriodicTask(
      friendActivitySyncTask,
      friendSyncTag,
      frequency: const Duration(hours: 1),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
      ),
    );

    // 2. Schedule fixed one-off tasks at each upcoming clock hour (e.g. 6am, 7am, 8am...)
    // excluding quiet hours from 12 AM to the user's wake-up hour.
    final prefs = await SharedPreferences.getInstance();
    final uid =
        prefs.getString('current_logged_in_uid') ??
        prefs.getString('last_logged_in_uid');
    final wakeUpHourKeyScoped = uid != null
        ? "${uid}_wakeUpHour"
        : 'wakeUpHour';
    final wakeUpHour =
        prefs.getInt(wakeUpHourKeyScoped) ?? prefs.getInt('wakeUpHour') ?? 8;

    final now = DateTime.now();

    for (int i = 1; i <= 24; i++) {
      final targetTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        0,
        0,
      ).add(Duration(hours: i));

      // Skip quiet hours between 12:00 AM (0) and wakeUpHour - 1
      if (targetTime.hour < wakeUpHour && wakeUpHour > 0) {
        continue;
      }

      final initialDelay = targetTime.difference(now);
      await Workmanager().registerOneOffTask(
        "hourly_sync_${targetTime.hour}",
        friendSyncTag,
        initialDelay: initialDelay,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: false,
        ),
      );
    }

    // 3. Daily quiz sync scheduled for 3:00 AM
    var scheduledTime = DateTime(now.year, now.month, now.day, 3, 0);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final initialDelay = scheduledTime.difference(now);
    debugPrint(
      "⏳ Scheduling 3:00 AM daily quiz sync with delay: ${initialDelay.inHours}h ${initialDelay.inMinutes % 60}m",
    );

    await Workmanager().registerPeriodicTask(
      dailyQuizSyncTask,
      quizSyncTag,
      frequency: const Duration(hours: 24),
      initialDelay: initialDelay,
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
      ),
    );
  }
}
