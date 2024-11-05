import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/vertigo_episode.dart';
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

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this vertigo episode?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteVertigoEpisode(index);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteVertigoEpisode(int index) {
    vertigoBox.deleteAt(index); // Delete the episode at the specified index
    setState(() {}); // Refresh the UI after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vertigo Logs')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<VertigoEpisode>('vertigoEpisodes').listenable(),
        builder: (context, Box<VertigoEpisode> box, _) {
          if (box.isEmpty) {
            return Center(child: Text('No vertigo episodes logged.'));
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final episode = box.getAt(index) as VertigoEpisode;
                return ListTile(
                  title: Text("Episode on ${episode.date.toLocal()}"),
                  subtitle: Text("Duration: ${episode.durationHours}h ${episode.durationMinutes}m"),
                  trailing: IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: () => _showDeleteConfirmationDialog(index),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToLogVertigoForm,
        tooltip: 'Log Vertigo Episode',
        child: Icon(Icons.add),
      ),
    );
  }
}
