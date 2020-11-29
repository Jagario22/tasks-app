import 'package:time_machine/time_machine.dart';

class DateUtil {
  static Instant formatDate(DateTime dateTime) {
    return Instant.dateTime(dateTime);
  }

  static DateTime dateTimeFromString(String datetime) {
    DateTime date = DateTime.parse(datetime);
    return Instant.dateTime(date).toDateTimeLocal();
  }
}
