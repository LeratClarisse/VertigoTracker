import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vertigotracker/src/core/utils/notification_service.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/vertigo_episode.dart';
import 'package:vertigotracker/src/features/reminders/Domain/entity/reminder.dart';

import 'src/core/Presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive boxes
  await Hive.initFlutter();
  Hive.registerAdapter(VertigoEpisodeAdapter());
  Hive.registerAdapter(ReminderAdapter());
  await Hive.openBox('settings');
  await Hive.openBox<VertigoEpisode>('vertigoEpisodes');
  await Hive.openBox<Reminder>('reminders');

  // Initialize notifications
  NotificationService.initialize();

  return runApp(const App());
}
