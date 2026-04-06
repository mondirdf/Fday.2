import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/events_history/events_history_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/stats/stats_screen.dart';
import 'screens/study_history/study_history_screen.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  await storage.init();
  runApp(FDayApp(storage: storage));
}

class FDayApp extends StatelessWidget {
  const FDayApp({super.key, required this.storage});

  final StorageService storage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fday',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: AppShell(storage: storage),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.storage});

  final StorageService storage;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(storage: widget.storage),
      StatsScreen(storage: widget.storage),
      StudyHistoryScreen(storage: widget.storage),
      EventsHistoryScreen(storage: widget.storage),
    ];

    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _index, children: pages)),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black,
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), label: 'Study'),
          NavigationDestination(icon: Icon(Icons.event_note_outlined), label: 'Events'),
        ],
      ),
    );
  }
}
