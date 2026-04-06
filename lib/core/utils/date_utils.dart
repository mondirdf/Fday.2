import 'package:intl/intl.dart';

class FDateUtils {
  static final _keyFormatter = DateFormat('yyyy-MM-dd');
  static final _prettyFormatter = DateFormat('EEE, MMM d');
  static final _timeFormatter = DateFormat('HH:mm');

  static String dateKey(DateTime date) => _keyFormatter.format(date);
  static String prettyDate(DateTime date) => _prettyFormatter.format(date);
  static String prettyTime(DateTime date) => _timeFormatter.format(date);
}
