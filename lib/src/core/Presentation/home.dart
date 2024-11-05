import 'package:flutter/material.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/vertigo_episode.dart';
import 'package:vertigotracker/src/features/logs/Presentation/log_vertigo_form_page.dart';
import 'package:vertigotracker/src/features/reminders/Domain/entity/reminder.dart';
import 'package:vertigotracker/src/features/reminders/Presentation/reminders_form_page.dart';

class Home extends StatelessWidget {
  final VertigoEpisode? lastVertigo;
  final Reminder? nextReminder;
  const Home({Key? key, required this.lastVertigo, required this.nextReminder}) : super(key: key);

  // Calculate the days since the last vertigo episode
  int _daysSinceLastVertigo() {
    if (lastVertigo == null) return 0;
    final now = DateTime.now();
    final lastEpisodeDate = lastVertigo!.date;
    final difference = now.difference(lastEpisodeDate).inDays;
    return difference; // Count partial days as a full day
  }

  // Method to navigate to the log vertigo form page
  void _navigateToLogVertigoForm(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LogVertigoFormPage()),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vertigo episode logged successfully')),
      );
    }
  }

  // Method to navigate to the create reminder form page
  void _navigateToCreateReminderForm(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReminderFormPage()),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder created successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Daily Summary Cards
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Next Reminder: ${nextReminder != null ? "${nextReminder!.time.hour}:${nextReminder!.time.minute} - ${nextReminder!.message}" : "No reminders set"}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Last Episode: ${lastVertigo != null ? "${_formatDate(lastVertigo!.date)} - Duration: ${lastVertigo!.durationHours}h ${lastVertigo!.durationMinutes}m" : "No episodes logged"}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Days Since Last Episode: ${lastVertigo != null ? _daysSinceLastVertigo() : "No episodes logged"}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Quick Actions Area
          ElevatedButton(
            onPressed: () => _navigateToLogVertigoForm(context),
            child: Text('Log Vertigo Episode'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _navigateToCreateReminderForm(context),
            child: Text('Set Medication Reminder'),
          ),
        ],
      ),
    );
  }

  // Helper function to format date
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
