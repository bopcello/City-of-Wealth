import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../game_state.dart';

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

    // Create Notification Channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'game_events',
      'Game Events',
      description: 'Notifications for disasters and city events',
      importance: Importance.max,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> showDisasterNotification(DisasterType type) async {
    String title = "Disaster Alert!";
    String body = "";

    switch (type) {
      case DisasterType.flood:
        body = "Water levels are rising! Your lands are at risk of flooding.";
        break;
      case DisasterType.fire:
        body = "Fire outbreak! Your properties and vehicles are in danger.";
        break;
      case DisasterType.earthquake:
        body =
            "The ground is shaking! Buildings and machinery might be damaged.";
        break;
      case DisasterType.economyCrash:
        body = "Market crash! Your businesses are struggling to stay afloat.";
        break;
      case DisasterType.drought:
        body = "Scorching heat! Your farms are drying up.";
        break;
      case DisasterType.landslide:
        body = "Terrain shift! Distribution routes have been compromised.";
        break;
      case DisasterType.massEmigration:
        body = "Ghost town! Citizens are leaving your apartments in droves.";
        break;
      case DisasterType.pandemic:
        body = "Health crisis! IT services are at a standstill.";
        break;
    }

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
      title: title,
      body: body,
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

  Future<void> scheduleInactivityNotification() async {
    // Cancel existing inactivity notification (ID 999)
    await _notifications.cancel(id: 999);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'inactivity',
          'Player Retention',
          channelDescription: 'Reminders to check on your city',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        );

    await _notifications.zonedSchedule(
      id: 999,
      title: "Your city is crumbling!",
      body:
          "Your citizens miss you! Come back and save your city from financial ruin.",
      scheduledDate: tz.TZDateTime.now(tz.local).add(const Duration(days: 5)),
      notificationDetails: NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
