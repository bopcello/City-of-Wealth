import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../game_state.dart';
import '../data/notification_data.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static final ValueNotifier<String?> notificationPayloadNotifier =
      ValueNotifier<String?>(null);

  Future<void> initialize() async {
    tz.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = info.identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint("📍 Timezone initialized: $timeZoneName");
    } catch (e) {
      debugPrint("⚠️ Could not get local timezone, defaulting to UTC: $e");
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("🔔 Notification clicked with payload: ${response.payload}");
        if (response.payload != null) {
          notificationPayloadNotifier.value = response.payload;
        }
      },
    );

    // Check if the app was launched via notification click when terminated
    try {
      final NotificationAppLaunchDetails? launchDetails = await _notifications
          .getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp ?? false) {
        final NotificationResponse? response =
            launchDetails?.notificationResponse;
        debugPrint(
          "🔔 App launched via notification click with payload: ${response?.payload}",
        );
        if (response?.payload != null) {
          notificationPayloadNotifier.value = response?.payload;
        }
      }
    } catch (e) {
      debugPrint("⚠️ Error getting notification app launch details: $e");
    }

    // Create Notification Channels for Android
    const AndroidNotificationChannel gameChannel = AndroidNotificationChannel(
      'game_events',
      'Game Events',
      description: 'Notifications for disasters and city events',
      importance: Importance.max,
    );

    const AndroidNotificationChannel routineChannel =
        AndroidNotificationChannel(
          'routine_updates',
          'Routine Updates',
          description: 'Daily city updates and reminders',
          importance: Importance.defaultImportance,
        );

    const AndroidNotificationChannel streakChannel = AndroidNotificationChannel(
      'streak_warnings',
      'Streak Warnings',
      description: 'Notifications before you lose your streak',
      importance: Importance.high,
    );

    const AndroidNotificationChannel inactivityChannel =
        AndroidNotificationChannel(
          'inactivity',
          'Reminders',
          description: 'Reminders to check on your city',
          importance: Importance.low,
        );

    const AndroidNotificationChannel dailyRoutineChannel =
        AndroidNotificationChannel(
          'daily_routine',
          'Daily Routine',
          description: 'Daily reminders for quizzes and city management',
          importance: Importance.high,
        );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(gameChannel);
    await androidPlugin?.createNotificationChannel(routineChannel);
    await androidPlugin?.createNotificationChannel(streakChannel);
    await androidPlugin?.createNotificationChannel(inactivityChannel);
    await androidPlugin?.createNotificationChannel(dailyRoutineChannel);

    // Clean up any lingering streak warning notifications from previous version
    final cancelFutures = <Future<void>>[];
    for (int i = 3000; i <= 3050; i++) {
      cancelFutures.add(_notifications.cancel(id: i));
    }
    await Future.wait(cancelFutures);
  }

  Future<void> requestPermissions() async {
    // Android 13+ requires explicit permission
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();

    // iOS requires explicit permission
    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Cancels all notifications and schedules daily, morning, and challenge reminders.
  /// Staggers database writes to avoid blocking the main UI thread.
  Future<void> rescheduleAllNotifications({
    required String playerName,
    required int dailyQuizStreak,
    required int streakRevivals,
    required String lastDailyQuizDate,
    required int wakeUpHour,
    required int wakeUpMinute,
  }) async {
    await _notifications.cancelAll();

    await scheduleDailyMorningNotification(
      playerName,
      wakeUpHour,
      wakeUpMinute,
      skipCancel: true,
    );

    await Future.delayed(const Duration(milliseconds: 300));
    await scheduleDailyChallengeReminders(
      playerName: playerName,
      dailyQuizStreak: dailyQuizStreak,
      streakRevivals: streakRevivals,
      lastDailyQuizDate: lastDailyQuizDate,
      skipCancel: true,
    );

    await Future.delayed(const Duration(milliseconds: 300));
    await scheduleDailyNotifications(playerName, skipCancel: true);
  }

  Future<void> showDisasterNotification(
    String playerName,
    DisasterType type,
    bool insured,
  ) async {
    final notification = NotificationData.getRandomDisasterNotification(
      playerName,
      type,
      insured,
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'game_events',
          'Game Events',
          channelDescription: 'Notifications for disasters and city events',
          importance: Importance.max,
          priority: Priority.high,
        );

    await _notifications.show(
      id: type.index,
      title: notification.$1,
      body: notification.$2,
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }

  Future<void> showDebtNotification(String playerName) async {
    final notification = NotificationData.getRandomDebtNotification(playerName);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'game_events',
          'Game Events',
          channelDescription: 'Notifications for disasters and city events',
          importance: Importance.high,
          priority: Priority.high,
        );

    await _notifications.show(
      id: 500,
      title: notification.$1,
      body: notification.$2,
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }

  Future<void> showForeclosureNotification(
    String playerName,
    String buildingName,
  ) async {
    final notification = NotificationData.getRandomForeclosureNotification(
      playerName,
      buildingName,
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'game_events',
          'Game Events',
          channelDescription: 'Notifications for disasters and city events',
          importance: Importance.max,
          priority: Priority.high,
        );

    await _notifications.show(
      id: 100 + buildingName.hashCode % 1000,
      title: notification.$1,
      body: notification.$2,
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }

  Future<void> scheduleDailyNotifications(String playerName, {bool skipCancel = false}) async {
    if (!skipCancel) {
      // Cancel previous daily notifications (IDs 1000-1100)
      final cancelFutures = <Future<void>>[];
      for (int i = 1000; i < 1100; i++) {
        cancelFutures.add(_notifications.cancel(id: i));
      }
      await Future.wait(cancelFutures);
    }

    int scheduledCount = 0;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'routine_updates',
          'Routine Updates',
          channelDescription: 'Daily city updates and reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        );

    final now = tz.TZDateTime.now(tz.local);
    final scheduleFutures = <Future<void>>[];

    // Schedule for the next 7 days
    for (int day = 0; day < 7; day++) {
      for (int hour in [6, 12, 18]) {
        // 6 AM, 12 PM, 6 PM
        var scheduledDate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          hour,
        ).add(Duration(days: day));

        if (scheduledDate.isBefore(now)) continue;

        final notification = NotificationData.getRandomDailyGeneralNotification(
          playerName,
        );

        scheduleFutures.add(_notifications.zonedSchedule(
          id: 1000 + scheduledCount,
          title: notification.$1,
          body: notification.$2,
          scheduledDate: scheduledDate,
          notificationDetails: NotificationDetails(android: androidDetails),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        ));
        scheduledCount++;
      }
    }
    await Future.wait(scheduleFutures);
    debugPrint("📅 Scheduled $scheduledCount general notifications for 1 week");
  }

  Future<void> scheduleInactivityNotification(String playerName) async {
    // Cancel previous inactivity notifications (IDs 2000-2010)
    final cancelFutures = <Future<void>>[];
    for (int i = 2000; i < 2010; i++) {
      cancelFutures.add(_notifications.cancel(id: i));
    }
    await Future.wait(cancelFutures);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'inactivity',
          'Reminders',
          channelDescription: 'Reminders to check on your city',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        );

    final intervals = {
      "2d": const Duration(days: 1),
      "3d": const Duration(days: 3),
      "5d": const Duration(days: 5),
      "1w": const Duration(days: 7),
      "2w": const Duration(days: 14),
      "1m": const Duration(days: 30),
    };

    final scheduleFutures = <Future<void>>[];
    int i = 0;
    for (var entry in intervals.entries) {
      final key = entry.key;
      final duration = entry.value;
      final notification = NotificationData.getRandomInactivityNotification(
        playerName,
        key,
      );

      scheduleFutures.add(_notifications.zonedSchedule(
        id: 2000 + i,
        title: notification.$1,
        body: notification.$2,
        scheduledDate: tz.TZDateTime.now(tz.local).add(duration),
        notificationDetails: NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      ));
      i++;
    }
    await Future.wait(scheduleFutures);
    debugPrint("⏳ Scheduled $i inactivity notifications");
  }

  Future<void> showNewQuizNotification(String playerName) async {
    final notification = NotificationData.getRandomNewQuizNotification(
      playerName,
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'routine_updates',
          'Routine Updates',
          channelDescription: 'Daily city updates and reminders',
          importance: Importance.high,
          priority: Priority.high,
        );

    await _notifications.show(
      id: 4000,
      title: notification.$1,
      body: notification.$2,
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }

  Future<void> scheduleDisasterNotification(
    String playerName,
    DateTime time,
    DisasterType type,
    bool insured,
  ) async {
    // Cancel existing disaster notifications (ID 5000)
    await _notifications.cancel(id: 5000);

    final notification = NotificationData.getRandomDisasterNotification(
      playerName,
      type,
      insured,
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'game_events',
          'Game Events',
          channelDescription: 'Notifications for disasters and city events',
          importance: Importance.max,
          priority: Priority.high,
        );

    await _notifications.zonedSchedule(
      id: 5000,
      title: notification.$1,
      body: notification.$2,
      scheduledDate: tz.TZDateTime.from(time, tz.local),
      notificationDetails: NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleDailyMorningNotification(
    String playerName,
    int hour,
    int minute, {
    bool skipCancel = false,
  }) async {
    if (!skipCancel) {
      // ID 6000 for daily morning quiz
      await _notifications.cancel(id: 6000);
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_routine',
          'Daily Routine',
          channelDescription: 'Daily reminders for quizzes and city management',
          importance: Importance.high,
          priority: Priority.high,
        );

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final notification = NotificationData.getRandomDailyMorningNotification(
      playerName,
    );

    await _notifications.zonedSchedule(
      id: 6000,
      title: notification.$1,
      body: notification.$2,
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'quiz',
    );
  }

  Future<void> scheduleDailyChallengeReminders({
    required String playerName,
    required int dailyQuizStreak,
    required int streakRevivals,
    required String lastDailyQuizDate,
    bool skipCancel = false,
  }) async {
    if (!skipCancel) {
      // Cancel previous challenge reminder notifications (IDs 3000 to 3050)
      final cancelFutures = <Future<void>>[];
      for (int i = 3000; i <= 3050; i++) {
        cancelFutures.add(_notifications.cancel(id: i));
      }
      await Future.wait(cancelFutures);
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'streak_warnings',
          'Streak Warnings',
          channelDescription:
              'Notifications before you lose your streak or consume a revival',
          importance: Importance.high,
          priority: Priority.high,
        );

    final now = tz.TZDateTime.now(tz.local);
    final baseMidnight = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      0,
      0,
    );

    final List<(String, Duration)> intervals = [
      ("6h", const Duration(hours: 6)),
      ("2h", const Duration(hours: 2)),
      ("1h", const Duration(hours: 1)),
      ("15m", const Duration(minutes: 15)),
    ];

    final scheduleFutures = <Future<void>>[];
    int scheduledCount = 0;

    for (int day = 0; day < 7; day++) {
      final deadline = baseMidnight.add(Duration(days: day + 1));

      for (int i = 0; i < intervals.length; i++) {
        final interval = intervals[i];
        final scheduledDate = deadline.subtract(interval.$2);

        // Only schedule if the time is in the future
        if (scheduledDate.isBefore(now)) {
          continue;
        }

        // Convert the scheduled local date to IST date string to check if already attempted
        final scheduledDateIST = scheduledDate.toUtc().add(const Duration(hours: 5, minutes: 30));
        final targetQuizDateStr = DateFormat('yyyy-MM-dd').format(scheduledDateIST);

        if (lastDailyQuizDate == targetQuizDateStr) {
          continue;
        }

        final notification = NotificationData.getRandomChallengeReminder(
          playerName,
          dailyQuizStreak,
          streakRevivals,
          interval.$1,
        );

        final notificationId = 3000 + (day * 4) + i;

        scheduleFutures.add(_notifications.zonedSchedule(
          id: notificationId,
          title: notification.$1,
          body: notification.$2,
          scheduledDate: scheduledDate,
          notificationDetails: NotificationDetails(android: androidDetails),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: 'quiz',
        ));
        scheduledCount++;
      }
    }
    await Future.wait(scheduleFutures);
    debugPrint("🔔 Scheduled $scheduledCount daily challenge reminders");
  }



  Future<bool> requestPermission() async {
    if (await Permission.notification.isGranted) return true;
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}
