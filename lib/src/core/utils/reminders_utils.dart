import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:vertigotracker/main.dart';
import 'package:vertigotracker/src/features/reminders/Domain/entity/reminder.dart';

Future<void> scheduleDailyReminder(Reminder reminder) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
    reminder.key, // Use the Hive object's key as the ID
    'Medication Reminder',
    reminder.message,
    tz.TZDateTime.from(reminder.time, tz.local),
    NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Channel for medication reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time, // To repeat daily
  );
}
