import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../game_state.dart';
import '../data/notification_data.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notifications.initialize(settings: initializationSettings);

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

    const AndroidNotificationChannel inactivityChannel =
        AndroidNotificationChannel(
          'inactivity',
          'Player Retention',
          description: 'Reminders to check on your city',
          importance: Importance.low,
        );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(gameChannel);
    await androidPlugin?.createNotificationChannel(routineChannel);
    await androidPlugin?.createNotificationChannel(inactivityChannel);
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

  Future<void> showDisasterNotification(DisasterType type, bool insured) async {
    final notification = insured
        ? NotificationData.disasterInsured[type]!
        : NotificationData.disasterUninsured[type]!;

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

  Future<void> showDebtNotification() async {
    final random = Random();
    final notification =
        NotificationData.debtNotifications[random.nextInt(
          NotificationData.debtNotifications.length,
        )];

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

  Future<void> showForeclosureNotification(String buildingName) async {
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
      title: "Foreclosure Alert!",
      body:
          "Your city is crumbling! $buildingName has been foreclosed due to debt.",
      notificationDetails: NotificationDetails(android: androidDetails),
    );
  }

  Future<void> scheduleDailyNotifications() async {
    // Cancel previous daily notifications (IDs 1000-1100)
    for (int i = 1000; i < 1100; i++) {
      await _notifications.cancel(id: i);
    }

    final random = Random();
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

        final notification = NotificationData
            .dailyGeneral[random.nextInt(NotificationData.dailyGeneral.length)];

        await _notifications.zonedSchedule(
          id: 1000 + scheduledCount,
          title: notification.$1,
          body: notification.$2,
          scheduledDate: scheduledDate,
          notificationDetails: NotificationDetails(android: androidDetails),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
        scheduledCount++;
      }
    }
    debugPrint("📅 Scheduled $scheduledCount general notifications for 1 week");
  }

  Future<void> scheduleInactivityNotification() async {
    // Cancel previous inactivity notifications (IDs 2000-2010)
    for (int i = 2000; i < 2010; i++) {
      await _notifications.cancel(id: i);
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'inactivity',
          'Player Retention',
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

    int i = 0;
    for (var entry in intervals.entries) {
      final key = entry.key;
      final duration = entry.value;
      final notification = NotificationData.inactivityNotifications[key]!;

      await _notifications.zonedSchedule(
        id: 2000 + i,
        title: notification.$1,
        body: notification.$2,
        scheduledDate: tz.TZDateTime.now(tz.local).add(duration),
        notificationDetails: NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      i++;
    }
    debugPrint("⏳ Scheduled $i inactivity notifications");
  }
}
