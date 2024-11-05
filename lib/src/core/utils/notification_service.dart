import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:vertigotracker/src/features/reminders/Domain/entity/reminder.dart';

class NotificationService {
  static final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialization function
  static Future<void> initialize() async {
    tz.initializeTimeZones(); // Initialize timezone package

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher'); // App icon
    const initSettings = InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Create a notification channel for Android 8.0+
    const androidChannel = AndroidNotificationChannel(
      'reminders_channel', // Channel ID
      'Daily Reminders', // Channel name
      description: 'Channel for daily reminders',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  // Scheduling function
  static Future<void> scheduleDailyReminder(Reminder reminder) async {
    final scheduledTime = reminder.time; // DateTime of the reminder
    final hour = scheduledTime.hour;
    final minute = scheduledTime.minute;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      reminder.key ?? 0, // Use the Hive key or another unique ID
      'Medication Reminder',
      reminder.message,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders_channel', // Same as channel id in init
          'Daily Reminders',
          channelDescription: 'Channel for daily reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Triggers daily at specified time
    );
  }

  // Helper function to get the next instance of a specified time
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1)); // Schedule for tomorrow if time has passed today
    }
    return scheduledDate;
  }
}
