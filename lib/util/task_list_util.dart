import 'package:task_manager/app/api/model/priority.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/util/sort_util.dart';

import 'date_util.dart';

class TaskListUtil {
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
    } else if (eSort == ESort.byCompletedStatus) {
      return _sortByCompleteStatus(tasks);
    }
    return result;
  }

  static List<int> countStatistic(List<Task> tasks) {
    int waiting = 0, onGoing = 0, gone = 0, completed = 0;
    List<int> statistic = new List();
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].completed == true) {
        completed++;
        continue;
      }

      DateTime now = DateTime.now();
      DateTime startTime = DateUtil.dateTimeFromString(tasks[i].startTime);
      if (tasks[i].endTime == null) {
        if (startTime.isBefore(now)) {
          onGoing++;
        } else
          waiting++;
        continue;
      }

      DateTime endTime = DateUtil.dateTimeFromString(tasks[i].endTime);

      if (startTime.isBefore(now)) {
        if (endTime.isAfter(now)) {
          onGoing++;
        } else {
          gone++;
        }
      } else
        waiting++;
    }

    statistic.add(waiting);
    statistic.add(onGoing);
    statistic.add(gone);
    statistic.add(completed);
    return statistic;
  }

  static List<Task> _sortByCompleteStatus(List<Task> tasks) {
    List<Task> unfinished = new List();
    List<Task> completed = new List();

    for (int i = 0; i < tasks.length; i++) {
      tasks[i].completed == true
          ? completed.add(tasks[i])
          : unfinished.add(tasks[i]);
    }

    List<Task> result = new List();

    result.addAll(unfinished);
    result.addAll(completed);

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
