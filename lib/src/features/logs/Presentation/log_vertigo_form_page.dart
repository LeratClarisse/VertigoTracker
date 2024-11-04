import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/vertigo_episode.dart';

class LogVertigoFormPage extends StatefulWidget {
  const LogVertigoFormPage({Key? key}) : super(key: key);

  @override
  _LogVertigoFormPageState createState() => _LogVertigoFormPageState();
}

class _LogVertigoFormPageState extends State<LogVertigoFormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _durationHours = 0;
  int _durationMinutes = 0;
  bool _nausea = false;
  bool _throwUp = false;
  String _comment = '';

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveVertigoEpisode() async {
    if (_formKey.currentState?.validate() ?? false) {
      final vertigoEpisode = VertigoEpisode(
        date: _selectedDate,
        time: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        durationHours: _durationHours,
        durationMinutes: _durationMinutes,
        nausea: _nausea,
        throwUp: _throwUp,
        comment: _comment,
      );

      final box = await Hive.openBox<VertigoEpisode>('vertigoEpisodes');
      await box.add(vertigoEpisode);

      Navigator.pop(context, true); // Return to previous screen after save
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log Vertigo Episode')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Date picker
              ListTile(
                title: Text("Date: ${_selectedDate.toLocal()}".split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),

              // Time picker
              ListTile(
                title: Text("Time: ${_selectedTime.format(context)}"),
                trailing: Icon(Icons.access_time),
                onTap: _selectTime,
              ),

              // Duration Input
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Duration (Hours)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _durationHours = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Duration (Minutes)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _durationMinutes = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
                ],
              ),

              // Nausea Toggle
              SwitchListTile(
                title: Text("Nausea"),
                value: _nausea,
                onChanged: (bool value) {
                  setState(() {
                    _nausea = value;
                  });
                },
              ),

              // Throw Up Toggle
              SwitchListTile(
                title: Text("Throw Up"),
                value: _throwUp,
                onChanged: (bool value) {
                  setState(() {
                    _throwUp = value;
                  });
                },
              ),

              // Comment Field
              TextFormField(
                decoration: InputDecoration(labelText: 'Comment'),
                onChanged: (value) {
                  _comment = value;
                },
              ),

              SizedBox(height: 20),

              // Save Button
              ElevatedButton(
                onPressed: _saveVertigoEpisode,
                child: Text('Save Episode'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}