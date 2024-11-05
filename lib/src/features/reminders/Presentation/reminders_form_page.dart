import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vertigotracker/src/core/utils/notification_service.dart';
import 'package:vertigotracker/src/features/reminders/Domain/entity/reminder.dart';

class ReminderFormPage extends StatefulWidget {
  const ReminderFormPage({Key? key}) : super(key: key);

  @override
  _ReminderFormPageState createState() => _ReminderFormPageState();
}

class _ReminderFormPageState extends State<ReminderFormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedTime = DateTime.now();
  String _message = '';

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = DateTime(
          _selectedTime.year,
          _selectedTime.month,
          _selectedTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _saveReminder() async {
    if (_formKey.currentState?.validate() ?? false) {
      final reminder = Reminder()
        ..time = _selectedTime
        ..message = _message;

      final box = await Hive.openBox<Reminder>('reminders');
      await box.add(reminder);

      // Schedule the notification
      await NotificationService.scheduleDailyReminder(reminder);

      Navigator.pop(context, true); // Return to the list page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text("Reminder Time: ${_selectedTime.hour}:${_selectedTime.minute}"),
                trailing: Icon(Icons.access_time),
                onTap: _selectTime,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Reminder Message'),
                onChanged: (value) {
                  _message = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveReminder,
                child: Text('Save Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
