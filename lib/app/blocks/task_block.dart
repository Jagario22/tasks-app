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
    _makeCallForController(
      _tasksController,
          () => apiClient.getTasks(),
    );
  }

  // TODO: Think about the improvement
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
