import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/vertigo_episode.dart';
import 'package:vertigotracker/src/features/logs/Presentation/edit_vertigo_form_page.dart';
import 'package:vertigotracker/src/features/logs/Presentation/vertigo_detail_page.dart';
import 'log_vertigo_form_page.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({Key? key}) : super(key: key);

  @override
  _LogsScreenState createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  late Box<VertigoEpisode> vertigoBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    vertigoBox = await Hive.openBox<VertigoEpisode>('vertigoEpisodes');
    setState(() {}); // Refresh UI once the box is opened
  }

  Future<void> _navigateToLogVertigoForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LogVertigoFormPage()),
    );
    if (result == true) {
      setState(() {}); // Refresh list after logging an episode
    }
  }

  void _showDeleteConfirmationDialog(int key) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmer la suppression'),
          content: Text('Voulez-vous vraiment supprimer ce vertige ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _deleteVertigoEpisode(key);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void _deleteVertigoEpisode(int key) {
    vertigoBox.delete(key); // Delete the episode at the specified index
    setState(() {}); // Refresh the UI after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Liste des vertiges')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<VertigoEpisode>('vertigoEpisodes').listenable(),
        builder: (context, Box<VertigoEpisode> box, _) {
          if (box.isEmpty) {
            return Center(child: Text('Aucun vertige'));
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final episode = box.getAt(index) as VertigoEpisode;
                return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                          "Vertige du ${DateFormat('dd.MM.yyyy').format(episode.date)} ${DateFormat('HH:mm').format(episode.time)}"),
                      subtitle: Text("Durée: ${episode.durationHours}h ${episode.durationMinutes}min"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditVertigoFormPage(
                                    episodeKey: episode.key,
                                  ),
                                ),
                              );
                            },
                            tooltip: 'Modifier',
                          ),
                          IconButton(
                            icon: Icon(Icons.clear, color: Colors.red),
                            onPressed: () => _showDeleteConfirmationDialog(episode.key),
                            tooltip: 'Supprimer',
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to the detail page with the data for this episode
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VertigoEpisodeDetailPage(
                              selectedDate: episode.date,
                              selectedTime: TimeOfDay.fromDateTime(episode.time),
                              durationHours: episode.durationHours,
                              durationMinutes: episode.durationMinutes,
                              nausea: episode.nausea,
                              throwUp: episode.throwUp,
                              acouphene: episode.acouphene,
                              earObstructed: episode.earObstructed,
                              selectedMedicines: episode.medicinesTaken,
                              comment: episode.comment,
                            ),
                          ),
                        );
                      },
                    ));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToLogVertigoForm,
        tooltip: 'Ajouter un vertige',
        child: Icon(Icons.add),
      ),
    );
  }
}
