import 'event.dart';
import 'sleep_session.dart';
import 'study_session.dart';

class Day {
  Day({
    required this.date,
    List<SleepSession>? sleepSessions,
    List<StudySession>? studySessions,
    List<Event>? events,
  })  : sleepSessions = sleepSessions ?? [],
        studySessions = studySessions ?? [],
        events = events ?? [];

  final DateTime date;
  final List<SleepSession> sleepSessions;
  final List<StudySession> studySessions;
  final List<Event> events;

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'sleepSessions': sleepSessions.map((e) => e.toMap()).toList(),
      'studySessions': studySessions.map((e) => e.toMap()).toList(),
      'events': events.map((e) => e.toMap()).toList(),
    };
  }

  factory Day.fromMap(Map<String, dynamic> map) {
    return Day(
      date: DateTime.parse(map['date'] as String),
      sleepSessions: (map['sleepSessions'] as List<dynamic>)
          .map((e) => SleepSession.fromMap(e as Map<String, dynamic>))
          .toList(),
      studySessions: (map['studySessions'] as List<dynamic>)
          .map((e) => StudySession.fromMap(e as Map<String, dynamic>))
          .toList(),
      events: (map['events'] as List<dynamic>)
          .map((e) => Event.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
