import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/medicine.dart';
import 'package:vertigotracker/src/features/logs/Presentation/widgets/duration_picker.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/vertigo_episode.dart';
import 'package:vertigotracker/src/features/logs/Presentation/widgets/medicine_list.dart';

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
  bool _acouphene = false;
  bool _earObstructed = false;
  String _comment = '';
  List<Medicine> medicinesTaken = [];

  void _selectDuration() async {
    showDurationPicker(
      context,
      _durationHours,
      _durationMinutes,
      (duration) {
        setState(() {
          _durationHours = duration.inHours;
          _durationMinutes = duration.inMinutes % 60;
        });
      },
    );
  }

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

  void _addMedicine(List<Medicine> selectedMedicines) {
    setState(() {
      medicinesTaken = selectedMedicines;
    });
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
          acouphene: _acouphene,
          earObstructed: _earObstructed,
          comment: _comment,
          medicinesTaken: medicinesTaken);

      final box = await Hive.openBox<VertigoEpisode>('vertigoEpisodes');
      await box.add(vertigoEpisode);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un vertige')),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Date picker
                ListTile(
                  title: Text("Date: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}"),
                  trailing: Icon(Icons.calendar_today),
                  onTap: _selectDate,
                ),

                // Time picker
                ListTile(
                  title: Text("Heure: ${_selectedTime.format(context)}"),
                  trailing: Icon(Icons.access_time),
                  onTap: _selectTime,
                ),

                // Duration picker with display
                ListTile(
                  title: Text("Durée: ${_durationHours}h ${_durationMinutes}m"),
                  trailing: Icon(Icons.timer),
                  onTap: _selectDuration,
                ),

                // Nausea Toggle
                SwitchListTile(
                  title: Text("Nausées"),
                  value: _nausea,
                  onChanged: (bool value) {
                    setState(() {
                      _nausea = value;
                    });
                  },
                ),

                // Throw Up Toggle
                SwitchListTile(
                  title: Text("Vomissements"),
                  value: _throwUp,
                  onChanged: (bool value) {
                    setState(() {
                      _throwUp = value;
                    });
                  },
                ),

                // Acouphene Toggle
                SwitchListTile(
                  title: Text("Acouphènes"),
                  value: _acouphene,
                  onChanged: (bool value) {
                    setState(() {
                      _acouphene = value;
                    });
                  },
                ),

                // Ear obstructed Toggle
                SwitchListTile(
                  title: Text("Oreille bouchée"),
                  value: _earObstructed,
                  onChanged: (bool value) {
                    setState(() {
                      _earObstructed = value;
                    });
                  },
                ),

                // Medicine Picker (Add Medicines)
                MedicineListWidget(
                  onMedicinesSelected: _addMedicine,
                ),

                // Comment Field
                TextFormField(
                  decoration: InputDecoration(labelText: 'Commentaires'),
                  onChanged: (value) {
                    _comment = value;
                  },
                ),

                SizedBox(height: 20),

                // Save Button
                ElevatedButton(
                  onPressed: _saveVertigoEpisode,
                  child: Text('Enregistrer'),
                ),
              ],
            ),
          )),
    );
  }
}
