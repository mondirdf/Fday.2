import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../logic/analyzer.dart';
import '../../logic/sleep_calculator.dart';
import '../../models/day.dart';
import '../../services/storage_service.dart';
import '../../widgets/neumorphic/neu_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: storage,
      builder: (context, _) {
        final today = storage.dayFor(DateTime.now());
        final todaySleep = SleepCalculator.totalHours(today.sleepSessions);
        final todayStudy = _studyHours(today);
        final weekDays = _last7Days();
        final avgSleep = weekDays.fold<double>(0, (sum, day) => sum + SleepCalculator.totalHours(day.sleepSessions)) / 7;
        final avgStudy = weekDays.fold<double>(0, (sum, day) => sum + _studyHours(day)) / 7;
        final analysis = Analyzer.fromStudyHours(todayStudy);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Stats', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            NeuCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row('Sleep today', '${todaySleep.toStringAsFixed(1)}h'),
                  _row('Study today', '${todayStudy.toStringAsFixed(1)}h'),
                  _row('Weekly avg sleep', '${avgSleep.toStringAsFixed(1)}h'),
                  _row('Weekly avg study', '${avgStudy.toStringAsFixed(1)}h'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            NeuCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily insight: ${analysis.level}',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    analysis.insight,
                    style: const TextStyle(color: AppColors.subtext),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            NeuCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Last 7 days study'),
                  const SizedBox(height: 10),
                  ...weekDays.map((day) => _barRow(
                        date: FDateUtils.prettyDate(day.date),
                        value: _studyHours(day),
                        maxValue: 8,
                      )),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _barRow({required String date, required double value, required double maxValue}) {
    final ratio = (value / maxValue).clamp(0, 1);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$date • ${value.toStringAsFixed(1)}h', style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  List<Day> _last7Days() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: index));
      return storage.dayFor(date);
    }).reversed.toList();
  }

  double _studyHours(Day day) {
    return day.studySessions.fold<double>(0, (sum, item) => sum + item.duration);
  }
}
