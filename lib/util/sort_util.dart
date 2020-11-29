import 'package:task_manager/app/api/model/priority.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/util/date_util.dart';

enum ESort {
  byPriority,
  byTitle,
  byDeadLine,
  byStartDate,
}

class ESortUtil {
  static ESort toEnum(String value) {
    if (value == "byPriority") return ESort.byPriority;

    if (value == "byTitle") return ESort.byTitle;

    if (value == "byDeadLine") return ESort.byDeadLine;

    if (value == "byStartDate") return ESort.byStartDate;

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

  static List<Task> sortTasks(ESort eSort, List<Task> tasks) {
    List<Task> result = tasks;
    if (eSort == ESort.byTitle) {
      result.sort((a, b) => a.title.compareTo(b.title));
    } else if (eSort == ESort.byDeadLine) {
      result.sort((a, b) {
        return _sortByDeadline(a, b);
      });
    } else if (eSort == ESort.byPriority) {
      return _sortByPriority(tasks);
    } else if (eSort == ESort.byStartDate) {
      result.sort((a, b) {
        return _sortByStartDate(a, b);
      });
    }
    return result;
  }

  static List<Task> _sortByPriority(List<Task> tasks) {
    List<Task> medium = new List();
    List<Task> low = new List();
    List<Task> high = new List();
    List<Task> none = new List();

    List<Task> result = new List();
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].priority == EPriority.LOW)
        low.add(tasks[i]);
      else if (tasks[i].priority == EPriority.MEDIUM)
        medium.add(tasks[i]);
      else if (tasks[i].priority == EPriority.HIGH)
        high.add(tasks[i]);
      else
        none.add(tasks[i]);
    }
    result.addAll(high);
    result.addAll(medium);
    result.addAll(low);
    result.addAll(none);



    return result;
  }

  static int _sortByDeadline(Task a, Task b) {
    if (a.endTime == null)
      return 1;
    else if (b.endTime == null)
      return -1;
    else if (a.endTime == null && b.endTime == null) return 0;

    return _compareDateTime(DateUtil.dateTimeFromString(a.endTime),
        DateUtil.dateTimeFromString(b.endTime));
  }

  static int _sortByStartDate(Task a, Task b) {
    if (a.startTime == null)
      return 1;
    else if (b.startTime == null)
      return -1;
    else if (a.startTime == null && b.startTime == null) return 0;

    return _compareDateTime(DateUtil.dateTimeFromString(a.startTime),
        DateUtil.dateTimeFromString(b.startTime));
  }

  static int _compareDateTime(DateTime a, DateTime b) {
    if (a.isBefore(b)) {
      return -1;
    } else if (a.isAtSameMomentAs(b))
      return 0;
    else
      return 1;
  }
}
