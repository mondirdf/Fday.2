class StudySession {
  StudySession({
    required this.subject,
    required this.duration,
  });

  final String subject;
  final double duration;

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'duration': duration,
    };
  }

  factory StudySession.fromMap(Map<String, dynamic> map) {
    return StudySession(
      subject: map['subject'] as String,
      duration: (map['duration'] as num).toDouble(),
    );
  }
}
