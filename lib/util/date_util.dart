import 'package:time_machine/time_machine.dart';

class DateUtil {
  static Instant formatDate(DateTime dateTime) {
    return Instant.dateTime(dateTime);
  }

  static DateTime dateTimeFromString(String datetime) {
    DateTime date = DateTime.parse(datetime);
    return Instant.dateTime(date).toDateTimeLocal();
  }

  static DateTime getNextWeekFirstDate(DateTime dateTime) {
    int monday = 1;
    DateTime now = dateTime;

    if (now.weekday == monday) {
      now = now.add(new Duration(days: 7));
      return new DateTime(now.year, now.month, now.day);
    }

    while (now.weekday != monday) {
      now = now.add(new Duration(days: 1));
    }

    return new DateTime(now.year, now.month, now.day);
  }

  static DateTime getTomorrowDay(DateTime dateTime) {
    DateTime now = dateTime;
    now = now.add(new Duration(days: 1));

    return DateTime(now.year, now.month, now.day);
  }

  static DateTime getTodayDayFromDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static DateTime getTomorrowFromDate(DateTime dateTime) {
    DateTime result = dateTime.add(new Duration(days: 1));
    return DateTime(result.year, result.month, result.day);
  }

}
