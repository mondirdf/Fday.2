class SleepSession {
  SleepSession({
    required this.start,
    required this.end,
    required this.isNap,
    this.napDuration,
  });

  final DateTime start;
  final DateTime end;
  final bool isNap;
  final double? napDuration;

  Duration get duration {
    if (isNap && napDuration != null) {
      return Duration(minutes: (napDuration! * 60).round());
    }

    if (end.isBefore(start)) {
      return end.add(const Duration(days: 1)).difference(start);
    }

    return end.difference(start);
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'isNap': isNap,
      'napDuration': napDuration,
    };
  }

  factory SleepSession.fromMap(Map<String, dynamic> map) {
    return SleepSession(
      start: DateTime.parse(map['start'] as String),
      end: DateTime.parse(map['end'] as String),
      isNap: map['isNap'] as bool,
      napDuration: (map['napDuration'] as num?)?.toDouble(),
    );
  }
}
