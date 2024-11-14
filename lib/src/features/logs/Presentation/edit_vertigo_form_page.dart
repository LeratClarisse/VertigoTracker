import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/medicine.dart';
import 'package:vertigotracker/src/features/logs/Presentation/widgets/duration_picker.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/vertigo_episode.dart';
import 'package:vertigotracker/src/features/logs/Presentation/widgets/medicine_list.dart';

class EditVertigoFormPage extends StatefulWidget {
  final int episodeKey; // Key of the episode to be edited

  const EditVertigoFormPage({Key? key, required this.episodeKey}) : super(key: key);

  @override
  _EditVertigoFormPageState createState() => _EditVertigoFormPageState();
}

class _EditVertigoFormPageState extends State<EditVertigoFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEpisodeLoaded = false;
  late TextEditingController _commentController;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _durationHours = 0;
  int _durationMinutes = 0;
  bool _nausea = false;
  bool _throwUp = false;
  bool _acouphene = false;
  bool _earObstructed = false;
  List<Medicine> selectedMedicines = [];
  late VertigoEpisode originalEpisode;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _loadEpisode(); // Load existing episode data
  }

  Future<VertigoEpisode?> getEpisode(int key) async {
    final box = await Hive.openBox<VertigoEpisode>('vertigoEpisodes');
    return box.get(key); // Use key to fetch the specific episode
  }

  Future<void> _loadEpisode() async {
    final episode = await getEpisode(widget.episodeKey); // Load the episode
    if (episode != null) {
      setState(() {
        originalEpisode = episode;
        _selectedDate = episode.date;
        _selectedTime = TimeOfDay.fromDateTime(episode.time);
        _durationHours = episode.durationHours;
        _durationMinutes = episode.durationMinutes;
        _nausea = episode.nausea;
        _throwUp = episode.throwUp;
        _acouphene = episode.acouphene;
        _earObstructed = episode.earObstructed;
        _commentController.text = episode.comment;
        selectedMedicines = episode.medicinesTaken;

        _isEpisodeLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose(); // Dispose of the controller when done
    super.dispose();
  }

  Future<void> updateEpisode(int key, VertigoEpisode updatedEpisode) async {
    final box = await Hive.openBox<VertigoEpisode>('vertigoEpisodes');
    await box.put(key, updatedEpisode); // Save the updated episode at the same key
  }

  Future<void> _saveEditedEpisode() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedEpisode = VertigoEpisode(
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
          comment: _commentController.text,
          medicinesTaken: selectedMedicines);

      await updateEpisode(widget.episodeKey, updatedEpisode); // Update in Hive

      Navigator.pop(context, true); // Return to previous screen after save
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Vertigo Episode')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isEpisodeLoaded
            ? Form(
                key: _formKey,
                child: ListView(
                  children: [
                    ListTile(
                      title: Text("Date: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}"),
                      trailing: Icon(Icons.calendar_today),
                      onTap: _selectDate,
                    ),

                    ListTile(
                      title: Text("Time: ${_selectedTime.format(context)}"),
                      trailing: Icon(Icons.access_time),
                      onTap: _selectTime,
                    ),

                    ListTile(
                      title: Text("Duration: ${_durationHours}h ${_durationMinutes}m"),
                      trailing: Icon(Icons.timer),
                      onTap: _selectDuration,
                    ),

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

                    // Acouphene Toggle
                    SwitchListTile(
                      title: Text("Acouphene"),
                      value: _acouphene,
                      onChanged: (bool value) {
                        setState(() {
                          _acouphene = value;
                        });
                      },
                    ),

                    // Ear obstructed Toggle
                    SwitchListTile(
                      title: Text("Ear obstructed"),
                      value: _earObstructed,
                      onChanged: (bool value) {
                        setState(() {
                          _earObstructed = value;
                        });
                      },
                    ),

                    MedicineListWidget(
                      onMedicinesSelected: (selected) {
                        setState(() {
                          selectedMedicines = selected;
                        });
                      },
                      initialSelectedMedicines: selectedMedicines,
                    ),

                    TextFormField(
                      controller: _commentController,
                      decoration: InputDecoration(labelText: 'Comment'),
                      onChanged: (value) {
                        _commentController.text = value;
                      },
                    ),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _saveEditedEpisode,
                      child: Text('Save Changes'),
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
