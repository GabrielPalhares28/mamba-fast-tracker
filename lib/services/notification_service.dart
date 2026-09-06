import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    final localTimezone = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(localTimezone.identifier));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings: initializationSettings);
  }

  static Future<bool> requestPermission() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final granted = await androidPlugin?.requestNotificationsPermission();

    return granted ?? true;
  }

  static Future<bool> areNotificationsEnabled() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final enabled = await androidPlugin?.areNotificationsEnabled();

    return enabled ?? true;
  }

  static Future<void> showFastingStartedNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'fasting_channel',
      'Fasting notifications',
      channelDescription: 'Notifications about fasting sessions',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id: 1,
      title: 'Jejum iniciado',
      body: 'Seu período de jejum começou.',
      notificationDetails: notificationDetails,
    );
    
  }
  static Future<void> scheduleFastingEndedNotification(
  DateTime endTime,
) async {
  const androidDetails = AndroidNotificationDetails(
    'fasting_channel',
    'Fasting notifications',
    channelDescription: 'Notifications about fasting sessions',
    importance: Importance.high,
    priority: Priority.high,
  );

  const notificationDetails = NotificationDetails(
    android: androidDetails,
  );

  final scheduledDate = tz.TZDateTime.from(
    endTime,
    tz.local,
  );

  await _notifications.zonedSchedule(
    id: 2,
    title: 'Jejum concluído',
    body: 'Seu período de jejum terminou.',
    scheduledDate: scheduledDate,
    notificationDetails: notificationDetails,
    androidScheduleMode:
        AndroidScheduleMode.inexactAllowWhileIdle,
  );
  
}
static Future<void> cancelFastingEndedNotification() async {
  await _notifications.cancel(id: 2);
}
}
