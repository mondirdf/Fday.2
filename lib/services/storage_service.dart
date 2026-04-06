import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/utils/date_utils.dart';
import '../models/day.dart';
import '../models/event.dart';
import '../models/sleep_session.dart';
import '../models/study_session.dart';

class StorageService extends ChangeNotifier {
  static const _storageKey = 'fday_days_v1';

  final Map<String, Day> _days = {};
  SharedPreferences? _prefs;

  List<Day> get allDays {
    final values = _days.values.toList();
    values.sort((a, b) => b.date.compareTo(a.date));
    return values;
  }

  Day dayFor(DateTime date) {
    final key = FDateUtils.dateKey(date);
    return _days.putIfAbsent(key, () => Day(date: date));
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_storageKey);
    if (raw == null || raw.isEmpty) return;

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    for (final entry in decoded.entries) {
      _days[entry.key] = Day.fromMap(entry.value as Map<String, dynamic>);
    }
    notifyListeners();
  }

  Future<void> upsertMainSleep({
    required DateTime date,
    required DateTime start,
    required DateTime end,
  }) async {
    final day = dayFor(date);
    day.sleepSessions.removeWhere((s) => !s.isNap);
    day.sleepSessions.add(SleepSession(start: start, end: end, isNap: false));
    await _persist();
  }

  Future<void> addNap({
    required DateTime date,
    required DateTime start,
    required double durationHours,
  }) async {
    final day = dayFor(date);
    final end = start.add(Duration(minutes: (durationHours * 60).round()));
    day.sleepSessions.add(
      SleepSession(
        start: start,
        end: end,
        isNap: true,
        napDuration: durationHours,
      ),
    );
    await _persist();
  }

  Future<void> addStudy({
    required DateTime date,
    required String subject,
    required double durationHours,
  }) async {
    final day = dayFor(date);
    day.studySessions.add(StudySession(subject: subject, duration: durationHours));
    await _persist();
  }

  Future<void> addEvent({
    required DateTime date,
    required String title,
    required DateTime time,
  }) async {
    final day = dayFor(date);
    day.events.add(Event(title: title, time: time));
    await _persist();
  }

  Future<void> _persist() async {
    final encoded = jsonEncode(_days.map((key, value) => MapEntry(key, value.toMap())));
    await _prefs?.setString(_storageKey, encoded);
    notifyListeners();
  }
}
