import 'package:flutter/material.dart';
import 'package:vertigotracker/src/features/logs/Presentation/log_vertigo_form_page.dart';
import 'package:vertigotracker/src/features/reminders/Presentation/reminders_form_page.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
                    'Next Reminder: 8:00 AM',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Last Episode: 2 days ago',
                    style: TextStyle(fontSize: 16),
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
}
