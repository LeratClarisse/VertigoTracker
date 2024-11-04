import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:vertigotracker/src/features/logs/Domain/entity/vertigo_episode.dart';
import 'package:vertigotracker/src/features/reminders/Domain/entity/reminder.dart';

import 'src/core/Presentation/app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Initialize Hive boxes
  await Hive.initFlutter();
  Hive.registerAdapter(VertigoEpisodeAdapter());
  Hive.registerAdapter(ReminderAdapter());
  await Hive.openBox('settings');
  await Hive.openBox<VertigoEpisode>('vertigoEpisodes');
  await Hive.openBox<Reminder>('reminders');

  // Initialize time zones
  tz.initializeTimeZones();
  await flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
  );
  return runApp(const App());
}
