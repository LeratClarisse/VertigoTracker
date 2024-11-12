import 'package:hive/hive.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/medicine.dart';

part 'vertigo_episode.g.dart';

@HiveType(typeId: 2)
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
  bool acouphene;

  @HiveField(7)
  bool earObstructed;

  @HiveField(8)
  String comment;

  @HiveField(9)
  List<Medicine> medicinesTaken; // Stores names of medicines taken

  VertigoEpisode({
    required this.date,
    required this.time,
    required this.durationHours,
    required this.durationMinutes,
    required this.nausea,
    required this.throwUp,
    required this.acouphene,
    required this.earObstructed,
    required this.comment,
    required this.medicinesTaken,
  });
}
