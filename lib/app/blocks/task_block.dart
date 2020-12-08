import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:task_manager/app/api/api_client.dart';
import 'package:task_manager/app/api/api_error.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/blocks/state.dart';

class TaskPageBlock extends BlocBase {
  final ApiClient apiClient;

  TaskPageBlock(this.apiClient);

  final _tasksController = StreamController<AppState<List<Task>>>()
    ..add(InitialState());

  Stream<AppState<List<Task>>> get tasksStream => _tasksController.stream;

  @override
  void dispose() {
    _tasksController.close();
    super.dispose();
  }

  void getTasksCall() async {
    print("processing GET request for all tasks");
    _makeCallForController(
      _tasksController,
          () => apiClient.getAllTasks(),
    );
  }

  void getAllTasksByCategoryId(int id) async {
    print("processing GET request for all tasks by categoryId");
    _makeCallForController(
      _tasksController,
          () => apiClient.getAllTasksByCategoryId(id),
    );
  }

  void getGoneTasks(String endDateTime) async {
    print("processing GET request for gone tasks");
    _makeCallForController(
      _tasksController,
          () => apiClient.getGoneTasks(endDateTime),
    );
  }

  void getUnfinishedTasks() async {
    print("processing GET request for not completed tasks");
    _makeCallForController(
      _tasksController,
          () => apiClient.getUnfinishedTasks(),
    );
  }

  void getAllTasksDuringDays(String start, String end) async {
    print("processing GET request for all tasks during day");
    _makeCallForController(
      _tasksController,
          () => apiClient.getAllTasksDuringDays(start, end),
    );
  }

  void getAllPlannedTasks(String start) async {
    print("processing GET request for all planned tasks");
    _makeCallForController(
      _tasksController,
          () => apiClient.getAllPlannedTasks(start),
    );
  }

  void _makeCallForController<T>(
      StreamController<AppState<T>> controller,
      Future<T> Function() call,
      ) async {
    controller.add(LoadingState());
    try {
      T data = await call();
      controller.add(SuccessState(data));
    } on ApiError catch (ex) {
      controller.add(ErrorState(ex.message));
    }
  }
}
