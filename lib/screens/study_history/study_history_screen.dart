import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../services/storage_service.dart';
import '../../widgets/neumorphic/neu_card.dart';
import '../../widgets/neumorphic/neu_list_item.dart';

class StudyHistoryScreen extends StatelessWidget {
  const StudyHistoryScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: storage,
      builder: (context, _) {
        final days = storage.allDays.where((day) => day.studySessions.isNotEmpty).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Study History', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (days.isEmpty)
              const Text('No study sessions yet.', style: TextStyle(color: AppColors.subtext))
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
                        ...day.studySessions.map(
                          (session) => NeuListItem(
                            title: session.subject,
                            trailing: Text(
                              '${session.duration.toStringAsFixed(1)}h',
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
