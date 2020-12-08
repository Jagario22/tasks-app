import 'package:task_manager/app/ui/pages/tasks_page.dart';

class PageRoutes {
  static const String home = today;

  static const String today = allTasks + "/today";
  static const String tomorrow = allTasks + "/tomorrow";
  static const String nextWeek = allTasks + "/next week";
  static const String planned = allTasks + "/planned";
  static const String gone = allTasks + "/gone";
  static const String allTasks = "/tasks";
  static const String tasksOfCategory = allTasks + "/category";

  static const String categories = "/categories";
}
