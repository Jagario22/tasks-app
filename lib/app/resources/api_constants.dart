class ApiConstants {
  ApiConstants._();

  static const host = "http://192.168.1.103:8080";
  static const tasksURL = "/tasks";
  static const getAllTasksByCategoryId = "/category/{id}";
  static const deleteAllByCategoryId = "/category/{categoryId}/delete";
  static const getGoneTasks = "/gone/{endDateTime}";
  static const addTask = "/add";
  static const getAllTasksDuringDays = "/during/days/{start}/{end}";
  static const getAllPlannedTasks = "/during/planned/{startDay}";
  static const getUnfinishedTasks = "/unfinished";
  static const deleteTask = "/delete/id/{taskId}";

  static const categoriesURL = "/categories";
  static const deleteCategoryById = "/id/{categoryId}/delete";
  static const addCategory = "/add";
}