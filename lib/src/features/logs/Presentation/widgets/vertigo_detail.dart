import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/medicine.dart';

class VertigoEpisodeDetailWidget extends StatelessWidget {
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

  const VertigoEpisodeDetailWidget({
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Date display
          ListTile(
            title: Text("Date: ${DateFormat('dd.MM.yyyy').format(selectedDate)}"),
            trailing: Icon(Icons.calendar_today),
          ),

          // Time display
          ListTile(
            title: Text("Time: ${selectedTime.format(context)}"),
            trailing: Icon(Icons.access_time),
          ),

          // Duration display
          ListTile(
            title: Text("Duration: $durationHours h $durationMinutes m"),
            trailing: Icon(Icons.timer),
          ),

          // Nausea display
          ListTile(
            title: Text("Nausea: ${nausea ? 'Yes' : 'No'}"),
          ),

          // Throw Up display
          ListTile(
            title: Text("Throw Up: ${throwUp ? 'Yes' : 'No'}"),
          ),

          // Acouphene display
          ListTile(
            title: Text("Acouphene: ${acouphene ? 'Yes' : 'No'}"),
          ),

          // Ear Obstructed display
          ListTile(
            title: Text("Ear Obstructed: ${earObstructed ? 'Yes' : 'No'}"),
          ),

          // Medicines display
          if (selectedMedicines.isNotEmpty)
            ListTile(
              title: Text("Medicines Taken:"),
              subtitle: Wrap(
                spacing: 8.0,
                children: selectedMedicines.map((medicine) => Chip(label: Text(medicine.name))).toList(),
              ),
            ),

          // Comment display
          if (comment.isNotEmpty)
            ListTile(
              title: Text("Comment: $comment"),
            )
        ],
      ),
    );
  }
}
