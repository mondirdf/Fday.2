import '../models/sleep_session.dart';

class SleepCalculator {
  static double totalHours(List<SleepSession> sessions) {
    final totalMinutes = sessions.fold<int>(
      0,
      (sum, session) => sum + session.duration.inMinutes,
    );
    return totalMinutes / 60;
  }
}
