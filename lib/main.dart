import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/vertigo_episode.dart';

import 'src/core/Presentation/app.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  Hive.registerAdapter(VertigoEpisodeAdapter());
  await Hive.openBox<VertigoEpisode>('vertigoEpisodes');
  return runApp(const App());
}
