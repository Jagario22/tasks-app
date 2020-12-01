import 'package:task_manager/app/api/model/priority.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/util/date_util.dart';

enum ESort { byPriority, byTitle, byDeadLine, byStartDate, byCompletedStatus }

class ESortUtil {
  static ESort toEnum(String value) {
    if (value == "byPriority") return ESort.byPriority;

    if (value == "byTitle") return ESort.byTitle;

    if (value == "byDeadLine") return ESort.byDeadLine;

    if (value == "byStartDate") return ESort.byStartDate;

    if (value == "byCompletedStatus") return ESort.byCompletedStatus;

    return null;
  }

  static String toStringValue(ESort value) {
    return value.toString().substring(value.toString().indexOf('.') + 1);
  }

  static List<String> allToStringValue(List<ESort> values) {
    List<String> result = new List();

    for (int i = 0; i < values.length; i++) {
      result.add(ESortUtil.toStringValue(values[i]));
    }

    return result;
  }
}
