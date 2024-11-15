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
          title: Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer ce rappel ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _deleteReminder(key);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Supprimer'),
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
      appBar: AppBar(title: Text('Rappels')),
      body: ValueListenableBuilder(
        valueListenable: reminderBox.listenable(),
        builder: (context, Box<Reminder> box, _) {
          if (box.isEmpty) {
            return Center(child: Text('Aucun rappel'));
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final reminder = box.getAt(index) as Reminder;
                return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text("Rappel: ${reminder.message}"),
                      subtitle: Text("Heure: ${reminder.time.hour}:${reminder.time.minute.toString().padLeft(2, '0')}"),
                      trailing: IconButton(
                        icon: Icon(Icons.clear, color: Colors.red),
                        onPressed: () => _showDeleteConfirmationDialog(reminder.key),
                      ),
                    ));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToReminderForm,
        tooltip: 'Ajouter un rappel',
        child: Icon(Icons.add),
      ),
    );
  }
}
