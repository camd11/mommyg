import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:math';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initialize();
  }

  void _initialize() async {
    tz.initializeTimeZones();
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleDaily() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Affirmation',
      await _getRandomAffirmation(),
      _nextInstance(),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_affirmation_channel',
          'Daily Affirmation',
          channelDescription: 'Channel for daily affirmation notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<String> _getRandomAffirmation() async {
    final prefs = await SharedPreferences.getInstance();
    final affirmations = prefs.getStringList('affirmations') ?? [
      "I am loved and appreciated",
      "I am capable of great things",
      "I believe in myself and my abilities",
    ];
    return affirmations[Random().nextInt(affirmations.length)];
  }

  tz.TZDateTime _nextInstance() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 9); // 9 AM
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}