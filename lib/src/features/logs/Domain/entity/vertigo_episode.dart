import 'package:hive/hive.dart';

part 'vertigo_episode.g.dart';

@HiveType(typeId: 0)
class VertigoEpisode extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  DateTime time;

  @HiveField(2)
  int durationHours;

  @HiveField(3)
  int durationMinutes;

  @HiveField(4)
  bool nausea;

  @HiveField(5)
  bool throwUp;

  @HiveField(6)
  String comment;

  VertigoEpisode({
    required this.date,
    required this.time,
    required this.durationHours,
    required this.durationMinutes,
    required this.nausea,
    required this.throwUp,
    required this.comment,
  });
}
