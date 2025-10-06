import 'package:intl/intl.dart';

class AppDateTime {
  static DateTime dateFormat(String time) {
    var parsedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
  }

  static String dateTimeFormat(String time) {
    var parsedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (parsedDate.year == today.year &&
        parsedDate.month == today.month &&
        parsedDate.day == today.day) {
      return 'Today at ${timeFormat(time)}';
    } else if (parsedDate.year == yesterday.year &&
        parsedDate.month == yesterday.month &&
        parsedDate.day == yesterday.day) {
      return 'Yesterday at ${timeFormat(time)}';
    } else if (parsedDate.year == today.year) {
      return DateFormat.MMMd().format(parsedDate).toString();
    } else {
      return DateFormat.yMMMd().format(parsedDate).toString();
    }
  }

  static String timeFormat(String time) {
    var parsedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    return DateFormat('jm').format(parsedDate).toString();
  }
}
