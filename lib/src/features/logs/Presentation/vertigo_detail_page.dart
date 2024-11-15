// Example usage in a page or widget that displays the details of a vertigo episode.
import 'package:flutter/material.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/medicine.dart';
import 'package:vertigotracker/src/features/logs/Presentation/widgets/vertigo_detail.dart';

class VertigoEpisodeDetailPage extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final int durationHours;
  final int durationMinutes;
  final bool nausea;
  final bool throwUp;
  final bool acouphene;
  final bool earObstructed;
  final List<Medicine> selectedMedicines;
  final String comment;

  const VertigoEpisodeDetailPage({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.durationHours,
    required this.durationMinutes,
    required this.nausea,
    required this.throwUp,
    required this.acouphene,
    required this.earObstructed,
    required this.selectedMedicines,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Détails du vertige")),
      body: VertigoEpisodeDetailWidget(
        selectedDate: selectedDate,
        selectedTime: selectedTime,
        durationHours: durationHours,
        durationMinutes: durationMinutes,
        nausea: nausea,
        throwUp: throwUp,
        acouphene: acouphene,
        earObstructed: earObstructed,
        selectedMedicines: selectedMedicines,
        comment: comment,
      ),
    );
  }
}
