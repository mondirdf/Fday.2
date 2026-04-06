import 'package:flutter/material.dart';

import '../../core/utils/date_utils.dart';
import '../../services/storage_service.dart';
import '../../widgets/neumorphic/neu_card.dart';

class EventsHistoryScreen extends StatelessWidget {
  const EventsHistoryScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: storage,
      builder: (context, _) {
        final days = storage.allDays.where((day) => day.events.isNotEmpty).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Events History', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (days.isEmpty)
              const Text('No events yet.')
            else
              ...days.map(
                (day) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NeuCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(FDateUtils.prettyDate(day.date)),
                        const SizedBox(height: 8),
                        ...day.events.map(
                          (event) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text(event.title),
                            trailing: Text(FDateUtils.prettyTime(event.time)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
