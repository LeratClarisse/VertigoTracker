import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vertigotracker/src/features/logs/Domain/entity/vertigo_episode.dart';
import 'package:vertigotracker/src/features/logs/Presentation/logs.dart';
import 'package:vertigotracker/src/features/reminders/Domain/entity/reminder.dart';
import 'package:vertigotracker/src/features/reminders/Presentation/reminders.dart';

import '../home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;
  VertigoEpisode? lastVertigo;
  Reminder? nextReminder;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final vertigoBox = Hive.box<VertigoEpisode>('vertigoEpisodes');
    final reminderBox = Hive.box<Reminder>('reminders');
    lastVertigo = null;
    nextReminder = null;

    // Get the last vertigo episode
    if (vertigoBox.isNotEmpty) {
      lastVertigo = vertigoBox.getAt(vertigoBox.length - 1);
    }

    // Get the next reminder (upcoming based on time)
    final now = DateTime.now();
    final reminders = reminderBox.values.whereType<Reminder>().where((reminder) => reminder.time.isAfter(now)).toList();
    reminders.sort((a, b) => a.time.compareTo(b.time)); // Sort by time

    if (reminders.isNotEmpty) {
      nextReminder = reminders.first;
    }

    setState(() {}); // Refresh UI after loading data
  }

  List<Widget> get _pages => [
        Home(
          lastVertigo: lastVertigo,
          nextReminder: nextReminder,
          onDataUpdated: _loadData,
        ), // Dynamically passing data
        LogsScreen(),
        ReminderListScreen(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
    if (index == 0) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vertigo Tracker'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            _loadData();
          }
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Logs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Reminders',
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
