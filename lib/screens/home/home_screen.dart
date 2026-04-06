import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../logic/analyzer.dart';
import '../../models/day.dart';
import '../../models/event.dart' as model;
import '../../models/sleep_session.dart';
import '../../models/study_session.dart';
import '../../services/storage_service.dart';
import '../../widgets/neumorphic/neu_button.dart';
import '../../widgets/neumorphic/neu_card.dart';
import '../../widgets/neumorphic/neu_input.dart';
import '../../widgets/neumorphic/neu_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _subjectController = TextEditingController();
  final _studyDurationController = TextEditingController(text: '1');
  final _eventTitleController = TextEditingController();
  final _napDurationController = TextEditingController(text: '0.5');

  final DateTime _selectedDate = DateTime.now();
  TimeOfDay? _sleepStart;
  TimeOfDay? _sleepEnd;
  TimeOfDay? _napStart;
  TimeOfDay? _eventTime;

  @override
  void dispose() {
    _subjectController.dispose();
    _studyDurationController.dispose();
    _eventTitleController.dispose();
    _napDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.storage,
      builder: (context, _) {
        final day = widget.storage.dayFor(_selectedDate);
        final studyHours = day.studySessions.fold<double>(0, (sum, s) => sum + s.duration);
        final analysis = Analyzer.fromStudyHours(studyHours);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            Text('fday', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  FDateUtils.prettyDate(_selectedDate),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 10),
                _statusChip(analysis.level),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              analysis.insight,
              style: const TextStyle(color: AppColors.subtext, fontSize: 13),
            ),
            const SizedBox(height: 16),
            _buildSleepSection(day),
            const SizedBox(height: 14),
            _buildStudySection(day),
            const SizedBox(height: 14),
            _buildEventsSection(day),
          ],
        );
      },
    );
  }

  Widget _statusChip(String level) {
    final color = switch (level) {
      'Good' => const Color(0xFF2E9B75),
      'Medium' => const Color(0xFFE8A84D),
      _ => const Color(0xFFC35F70),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.base,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: AppColors.lightShadow, offset: Offset(-2, -2), blurRadius: 6),
          BoxShadow(color: AppColors.darkShadow, offset: Offset(3, 3), blurRadius: 8),
        ],
      ),
      child: Text(
        level,
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  Widget _buildSleepSection(Day day) {
    final naps = day.sleepSessions.where((e) => e.isNap).toList();
    final mainSleep = day.sleepSessions.where((e) => !e.isNap).firstOrNull;

    return NeuCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Sleep'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              NeuButton(
                onTap: () => _pickTime((time) => setState(() => _sleepStart = time)),
                child: Text(_sleepStart == null ? 'Sleep start' : _sleepStart!.format(context)),
              ),
              NeuButton(
                onTap: () => _pickTime((time) => setState(() => _sleepEnd = time)),
                child: Text(_sleepEnd == null ? 'Wake time' : _sleepEnd!.format(context)),
              ),
              NeuButton(
                onTap: _addMainSleep,
                child: const Text('Set sleep'),
              ),
            ],
          ),
          if (mainSleep != null) ...[
            const SizedBox(height: 12),
            _sleepTile(mainSleep),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: NeuInput(
                  controller: _napDurationController,
                  hint: 'Nap duration (hrs)',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 10),
              NeuButton(
                onTap: () => _pickTime((time) => setState(() => _napStart = time)),
                child: Text(_napStart == null ? 'Nap start' : _napStart!.format(context)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          NeuButton(onTap: _addNap, child: const Text('+ Add nap')),
          if (naps.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...naps.map(_sleepTile),
          ],
        ],
      ),
    );
  }

  Widget _buildStudySection(Day day) {
    return NeuCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Study'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: NeuInput(controller: _subjectController, hint: 'Subject')),
              const SizedBox(width: 10),
              SizedBox(
                width: 90,
                child: NeuInput(
                  controller: _studyDurationController,
                  hint: 'Hours',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          NeuButton(onTap: _addStudy, child: const Text('+ Add session')),
          const SizedBox(height: 10),
          ...day.studySessions.map(_studyTile),
        ],
      ),
    );
  }

  Widget _buildEventsSection(Day day) {
    return NeuCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Events'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: NeuInput(controller: _eventTitleController, hint: 'Event title')),
              const SizedBox(width: 10),
              NeuButton(
                onTap: () => _pickTime((time) => setState(() => _eventTime = time)),
                child: Text(_eventTime == null ? 'Time' : _eventTime!.format(context)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          NeuButton(onTap: _addEvent, child: const Text('+ Add event')),
          const SizedBox(height: 10),
          ...day.events.map(_eventTile),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.text,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
    );
  }

  Widget _sleepTile(SleepSession session) {
    return NeuListItem(
      title: session.isNap ? 'Nap' : 'Main sleep',
      subtitle: '${FDateUtils.prettyTime(session.start)} - ${FDateUtils.prettyTime(session.end)}',
      trailing: Text(
        '${(session.duration.inMinutes / 60).toStringAsFixed(1)}h',
        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _studyTile(StudySession study) {
    return NeuListItem(
      title: study.subject,
      trailing: Text(
        '${study.duration.toStringAsFixed(1)}h',
        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _eventTile(model.Event event) {
    return NeuListItem(
      title: event.title,
      trailing: Text(
        FDateUtils.prettyTime(event.time),
        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
      ),
    );
  }

  Future<void> _pickTime(void Function(TimeOfDay) onPick) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: '',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.accent),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onPick(picked);
    }
  }

  DateTime _composeDateTime(TimeOfDay time) {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      time.hour,
      time.minute,
    );
  }

  Future<void> _addMainSleep() async {
    if (_sleepStart == null || _sleepEnd == null) {
      return;
    }

    await widget.storage.upsertMainSleep(
      date: _selectedDate,
      start: _composeDateTime(_sleepStart!),
      end: _composeDateTime(_sleepEnd!),
    );
  }

  Future<void> _addNap() async {
    if (_napStart == null) {
      return;
    }

    final duration = double.tryParse(_napDurationController.text.trim());
    if (duration == null || duration <= 0) {
      return;
    }

    await widget.storage.addNap(
      date: _selectedDate,
      start: _composeDateTime(_napStart!),
      durationHours: duration,
    );
  }

  Future<void> _addStudy() async {
    final subject = _subjectController.text.trim();
    final duration = double.tryParse(_studyDurationController.text.trim());
    if (subject.isEmpty || duration == null || duration <= 0) {
      return;
    }

    await widget.storage.addStudy(
      date: _selectedDate,
      subject: subject,
      durationHours: duration,
    );
    _subjectController.clear();
  }

  Future<void> _addEvent() async {
    final title = _eventTitleController.text.trim();
    if (title.isEmpty || _eventTime == null) {
      return;
    }

    await widget.storage.addEvent(
      date: _selectedDate,
      title: title,
      time: _composeDateTime(_eventTime!),
    );
    _eventTitleController.clear();
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
