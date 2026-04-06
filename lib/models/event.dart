class Event {
  Event({
    required this.title,
    required this.time,
  });

  final String title;
  final DateTime time;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time.toIso8601String(),
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'] as String,
      time: DateTime.parse(map['time'] as String),
    );
  }
}
