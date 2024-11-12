import 'package:hive/hive.dart';

part 'medicine.g.dart';

@HiveType(typeId: 3)
class Medicine extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String name;

  Medicine({required this.id, required this.name});
}
