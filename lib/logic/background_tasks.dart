import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../firebase_options.dart';
import '../services/firestore_service.dart';

class BackgroundTaskManager {
  static const String dailyQuizSyncTask = "daily_quiz_sync";
  static const String quizSyncTag = "quiz_sync";

  /// Initialize Workmanager and register the callback dispatcher.
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  /// Entry point for the background isolate.
  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      try {
        // Ensure Firebase is initialized in the background
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        }

        final now = DateTime.now();
        final dateStr = DateFormat('yyyy-MM-dd').format(now);
        
        // Fetch daily quiz from Firestore
        final quiz = await FirestoreService().getDailyQuiz(dateStr);
        
        if (quiz != null) {
          final prefs = await SharedPreferences.getInstance();
          final lastDate = prefs.getString('lastDailyQuizDate') ?? "";
          
          if (lastDate != dateStr) {
            // Flag to show notification on next phone interaction
            await prefs.setBool('new_quiz_ready', true);
            debugPrint("📅 Background Sync: New quiz detected for $dateStr");
          }
        }
        return true;
      } catch (e) {
        debugPrint("❌ Background Sync Error: $e");
        return false;
      }
    });
  }

  /// Schedules all necessary background tasks.
  static Future<void> scheduleTasks() async {
    final now = DateTime.now();
    
    // Calculate initial delay to hit 12:10 AM
    var scheduledTime = DateTime(now.year, now.month, now.day, 0, 10);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    
    final initialDelay = scheduledTime.difference(now);
    debugPrint("⏳ Scheduling daily quiz sync with delay: ${initialDelay.inHours}h ${initialDelay.inMinutes % 60}m");

    await Workmanager().registerPeriodicTask(
      dailyQuizSyncTask,
      quizSyncTag,
      frequency: const Duration(hours: 24),
      initialDelay: initialDelay,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
    );
  }
}
