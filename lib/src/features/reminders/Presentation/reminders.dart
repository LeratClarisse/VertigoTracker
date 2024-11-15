import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vertigotracker/src/features/reminders/Domain/entity/reminder.dart';
import 'package:vertigotracker/src/features/reminders/Presentation/reminders_form_page.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({Key? key}) : super(key: key);

  @override
  _ReminderListScreenState createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen> {
  late Box<Reminder> reminderBox;

  @override
  void initState() {
    super.initState();
    reminderBox = Hive.box<Reminder>('reminders');
  }

  void _navigateToReminderForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReminderFormPage()),
    );
    if (result == true) {
      setState(() {}); // Refresh list
    }
  }

  void _showDeleteConfirmationDialog(int key) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this reminder?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteReminder(key);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteReminder(int key) {
    reminderBox.delete(key); // Delete the reminder at the specified index
    setState(() {}); // Refresh the UI after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminders')),
      body: ValueListenableBuilder(
        valueListenable: reminderBox.listenable(),
        builder: (context, Box<Reminder> box, _) {
          if (box.isEmpty) {
            return Center(child: Text('No reminders set.'));
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final reminder = box.getAt(index) as Reminder;
                return ListTile(
                  title: Text("Reminder: ${reminder.message}"),
                  subtitle: Text("Time: ${reminder.time.hour}:${reminder.time.minute.toString().padLeft(2, '0')}"),
                  trailing: IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: () => _showDeleteConfirmationDialog(reminder.key),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToReminderForm,
        tooltip: 'Add Reminder',
        child: Icon(Icons.add),
      ),
    );
  }
}
