import 'dart:async';
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

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> _safeCancel(int id) async {
    if (!_isInitialized) return;
    try {
      await _notifications.cancel(id: id);
    } catch (e) {
      debugPrint("⚠️ Safe cancel notification $id error: $e");
    }
  }

  Future<void> _safeCancelAll() async {
    if (!_isInitialized) return;
    try {
      await _notifications.cancelAll();
    } catch (e) {
      debugPrint("⚠️ Safe cancel all notifications error: $e");
    }
  }

  Future<void> _safeShow({
    required int id,
    required String title,
    required String body,
    required NotificationDetails notificationDetails,
    String? payload,
  }) async {
    if (!_isInitialized) return;
    try {
      await _notifications.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    } catch (e) {
      debugPrint("⚠️ Safe show notification error: $e");
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

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
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const WindowsInitializationSettings initializationSettingsWindows =
        WindowsInitializationSettings(
      appName: 'City of Wealth',
      appUserModelId: 'com.cityofwealth.app',
      guid: '39078505-5286-43b6-901a-1b1000000000',
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      linux: initializationSettingsLinux,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      windows: initializationSettingsWindows,
    );

    try {
      await _notifications.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint("🔔 Notification clicked with payload: ${response.payload}");
          if (response.payload != null) {
            notificationPayloadNotifier.value = response.payload;
          }
        },
      );
      _isInitialized = true;
    } catch (e) {
      debugPrint("⚠️ Notification plugin initialization error: $e");
    }

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
    try {
      const AndroidNotificationChannel gameChannel = AndroidNotificationChannel(
        'game_events',
        'Game Events',
        description: 'Notifications for disasters and city events',
        importance: Importance.max,
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
            'routine_updates',
            'Routine Updates',
            description: 'Daily reminders for quizzes and city management',
            importance: Importance.high,
          );

      const AndroidNotificationChannel friendActivityChannel =
          AndroidNotificationChannel(
            'friend_city_activity',
            'Friend Activity',
            description: 'Level-ups, milestones, and activity from your friends',
            importance: Importance.high,
          );

      const AndroidNotificationChannel debugStageChannel =
          AndroidNotificationChannel(
            'background_debug_stage',
            'Background Debug Logs',
            description: 'Stage notifications for background task stages',
            importance: Importance.low,
          );

      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      await androidPlugin?.createNotificationChannel(gameChannel);
      await androidPlugin?.createNotificationChannel(streakChannel);
      await androidPlugin?.createNotificationChannel(inactivityChannel);
      await androidPlugin?.createNotificationChannel(dailyRoutineChannel);
      await androidPlugin?.createNotificationChannel(friendActivityChannel);
      await androidPlugin?.createNotificationChannel(debugStageChannel);

      // Delete obsolete notification channels from Android OS settings
      await androidPlugin?.deleteNotificationChannel(channelId: 'daily_routine');
    } catch (e) {
      debugPrint("⚠️ Error setting up Android notification channels: $e");
    }

    // Clean up any lingering streak warning notifications from previous version
    final cancelFutures = <Future<void>>[];
    for (int i = 3000; i <= 3050; i++) {
      cancelFutures.add(_safeCancel(i));
    }
    await Future.wait(cancelFutures);
  }

  /// Displays a status notification for each stage of the background task.
  Future<void> showDebugStageNotification({
    required String title,
    required String body,
    required int stageId,
  }) async {
    const details = AndroidNotificationDetails(
      'background_debug_stage',
      'Background Debug Logs',
      channelDescription: 'Stage notifications for background task stages',
      importance: Importance.low,
      priority: Priority.low,
      showWhen: true,
    );
    await _safeShow(
      id: 9000 + stageId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(android: details),
      payload: 'debug_stage',
    );
  }

  Future<void> requestPermissions() async {
    if (!_isInitialized) return;
    try {
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
    } catch (e) {
      debugPrint("⚠️ Error requesting notification permissions: $e");
    }
  }

  Future<void> showFriendActivityNotification({
    required String friendId,
    required String friendName,
    required String playerName,
    required Map<String, dynamic> event,
  }) async {
    final notification = NotificationData.getRandomFriendActivityNotification(
      friendName,
      event['type'] as String,
      event,
    );
    const details = AndroidNotificationDetails(
      'friend_city_activity',
      'Friend Activity',
      channelDescription: 'Updates from your friends',
      importance: Importance.high,
      priority: Priority.high,
    );
    await _safeShow(
      id: (friendId.hashCode ^ event.hashCode) & 0x7FFFFFFF,
      title: notification.$1,
      body: notification.$2,
      notificationDetails: const NotificationDetails(android: details),
      payload: 'friend_activity:$friendId',
    );
  }

  Future<void> showFriendRequestNotification({
    required String friendName,
    required String type,
  }) async {
    final notification = NotificationData.getRandomFriendRequestNotification(
      friendName,
      type,
    );
    const details = AndroidNotificationDetails(
      'friend_city_activity',
      'Friend Activity',
      channelDescription: 'Updates and requests from your friends',
      importance: Importance.high,
      priority: Priority.high,
    );
    await _safeShow(
      id: (friendName.hashCode ^ type.hashCode ^ DateTime.now().millisecondsSinceEpoch) & 0x7FFFFFFF,
      title: notification.$1,
      body: notification.$2,
      notificationDetails: const NotificationDetails(android: details),
      payload: 'friend_request',
    );
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
    int level = 1,
    bool kpMet = false,
    bool assetsMet = false,
    bool quizzesMet = false,
    int kpNeeded = 0,
    int buildingsNeeded = 0,
    String quizzesNeeded = '',
    List<String>? builtBuildings,
    int gemYield = 0,
    int gemBoostNextLevel = 0,
    int gemYieldFromPassive = 0,
    int debt = 0,
  }) async {
    await _safeCancelAll();

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
    await scheduleDailyNotifications(
      playerName,
      skipCancel: true,
      level: level,
      kpMet: kpMet,
      assetsMet: assetsMet,
      quizzesMet: quizzesMet,
      kpNeeded: kpNeeded,
      buildingsNeeded: buildingsNeeded,
      quizzesNeeded: quizzesNeeded,
      builtBuildings: builtBuildings,
      gemYield: gemYield,
      gemBoostNextLevel: gemBoostNextLevel,
      gemYieldFromPassive: gemYieldFromPassive,
      debt: debt,
    );
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

    await _safeShow(
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

    await _safeShow(
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

    await _safeShow(
      id: 100 + buildingName.hashCode % 1000,
      title: notification.$1,
      body: notification.$2,
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }

  Future<void> scheduleDailyNotifications(
    String playerName, {
    bool skipCancel = false,
    int level = 1,
    bool kpMet = false,
    bool assetsMet = false,
    bool quizzesMet = false,
    int kpNeeded = 0,
    int buildingsNeeded = 0,
    String quizzesNeeded = '',
    String? buildingName,
    List<String>? builtBuildings,
    int gemYield = 0,
    int gemBoostNextLevel = 0,
    int gemYieldFromPassive = 0,
    int debt = 0,
  }) async {
    if (!skipCancel) {
      // Cancel previous daily notifications (IDs 1000-1100)
      final cancelFutures = <Future<void>>[];
      for (int i = 1000; i < 1100; i++) {
        cancelFutures.add(_safeCancel(i));
      }
      await Future.wait(cancelFutures);
    }

    int scheduledCount = 0;
    int cycleIndex = 0;

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

    // Schedule every 6 hours for the next 7 days (0, 6, 12, 18)
    for (int day = 0; day < 7; day++) {
      for (int hour in [0, 6, 12, 18]) {
        var scheduledDate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          hour,
        ).add(Duration(days: day));

        if (scheduledDate.isBefore(now)) continue;

        final notification =
            NotificationData.getAlternatingRetentionNotification(
              cycleIndex: cycleIndex,
              name: playerName,
              level: level,
              kpMet: kpMet,
              assetsMet: assetsMet,
              quizzesMet: quizzesMet,
              kpNeeded: kpNeeded,
              buildingsNeeded: buildingsNeeded,
              quizzesNeeded: quizzesNeeded,
              buildingName: buildingName,
              builtBuildings: builtBuildings,
              gemYield: gemYield,
              gemBoostNextLevel: gemBoostNextLevel,
              gemYieldFromPassive: gemYieldFromPassive,
              debt: debt,
            );

        scheduleFutures.add(
          _safeZonedSchedule(
            id: 1000 + scheduledCount,
            title: notification.$1,
            body: notification.$2,
            scheduledDate: scheduledDate,
            notificationDetails: NotificationDetails(android: androidDetails),
          ),
        );
        scheduledCount++;
        cycleIndex++;
      }
    }
    await Future.wait(scheduleFutures);
    debugPrint(
      "📅 Scheduled $scheduledCount alternating retention notifications for 1 week",
    );
  }

  Future<void> scheduleInactivityNotification(String playerName) async {
    // Cancel previous inactivity notifications (IDs 2000-2010)
    final cancelFutures = <Future<void>>[];
    for (int i = 2000; i < 2010; i++) {
      cancelFutures.add(_safeCancel(i));
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

      scheduleFutures.add(
        _safeZonedSchedule(
          id: 2000 + i,
          title: notification.$1,
          body: notification.$2,
          scheduledDate: tz.TZDateTime.now(tz.local).add(duration),
          notificationDetails: NotificationDetails(android: androidDetails),
        ),
      );
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

    await _safeShow(
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
    await _safeCancel(5000);

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

    await _safeZonedSchedule(
      id: 5000,
      title: notification.$1,
      body: notification.$2,
      scheduledDate: tz.TZDateTime.from(time, tz.local),
      notificationDetails: NotificationDetails(android: androidDetails),
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
      await _safeCancel(6000);
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'routine_updates',
          'Routine Updates',
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

    await _safeZonedSchedule(
      id: 6000,
      title: notification.$1,
      body: notification.$2,
      scheduledDate: scheduledDate,
      notificationDetails: NotificationDetails(android: androidDetails),
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
        cancelFutures.add(_safeCancel(i));
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

      // Calculate the projected streak and revival values for this future day
      int projectedStreak = dailyQuizStreak;
      int projectedRevivals = streakRevivals;
      for (int d = 0; d < day; d++) {
        if (projectedRevivals > 0) {
          projectedRevivals--;
        } else {
          projectedStreak = 0;
        }
      }

      for (int i = 0; i < intervals.length; i++) {
        final interval = intervals[i];
        final scheduledDate = deadline.subtract(interval.$2);

        // Only schedule if the time is in the future
        if (scheduledDate.isBefore(now)) {
          continue;
        }

        // Convert the scheduled local date to IST date string to check if already attempted
        final scheduledDateIST = scheduledDate.toUtc().add(
          const Duration(hours: 5, minutes: 30),
        );
        final targetQuizDateStr = DateFormat(
          'yyyy-MM-dd',
        ).format(scheduledDateIST);

        if (lastDailyQuizDate == targetQuizDateStr) {
          continue;
        }

        final notification = NotificationData.getRandomChallengeReminder(
          playerName,
          projectedStreak,
          projectedRevivals,
          interval.$1,
        );

        final notificationId = 3000 + (day * 4) + i;

        scheduleFutures.add(
          _safeZonedSchedule(
            id: notificationId,
            title: notification.$1,
            body: notification.$2,
            scheduledDate: scheduledDate,
            notificationDetails: NotificationDetails(android: androidDetails),
            payload: 'quiz',
          ),
        );
        scheduledCount++;
      }
    }
    await Future.wait(scheduleFutures);
    debugPrint("🔔 Scheduled $scheduledCount daily challenge reminders");
  }

  Future<void> _safeZonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    if (!_isInitialized) return;
    try {
      await _notifications.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
        matchDateTimeComponents: matchDateTimeComponents,
      );
    } catch (e) {
      debugPrint(
        "⚠️ Exact alarm scheduling failed ($e), falling back to inexactAllowWhileIdle",
      );
      try {
        await _notifications.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
          matchDateTimeComponents: matchDateTimeComponents,
        );
      } catch (innerErr) {
        debugPrint("❌ Failed to schedule notification $id: $innerErr");
      }
    }
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
