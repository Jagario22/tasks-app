import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/api/service/category_service.dart';
import 'package:task_manager/app/api/service/task_service.dart';
import 'package:task_manager/app/resources/api_constants.dart';
import 'package:task_manager/app/resources/strings.dart';

import 'api_error.dart';
import 'model/task.dart';

class ApiClient {
  static final ChopperClient _chopperClient = ChopperClient(
    baseUrl: AppConstants.tasksManagerApiURL,
    services: [
      TaskService.create(),
      CategoryService.create(),
    ],
    converter: JsonConverter(),
  );

  static final taskService = _chopperClient.getService<TaskService>();

  static final categoryService = _chopperClient.getService<CategoryService>();

  Future<List<Task>> getTasks() async {
    Response<dynamic> response =
        await _makeCheckedCall(() => taskService.getAllTasks());
    final rawTasks = response.body as List<dynamic>;
    final tasks = rawTasks.map((rawTasks) => Task.fromJson(rawTasks)).toList();

    return tasks;
  }

  Future<List<Category>> getCategories() async {
    Response<dynamic> response =
        await _makeCheckedCall(() => categoryService.getAllCategories());
    final rawCategories = response.body as List<dynamic>;
    final categories = rawCategories
        .map((rawCategories) => Category.fromJson(rawCategories))
        .toList();

    return categories;
  }

  Future addTask(Task task) async {
    await _makeCheckedCall(() => taskService.addTask(task.toJson()));
  }

  Future<Response> _makeCheckedCall(Future<Response> Function() call) async {
    try {
      final response = await call();
      print("processing " + call.toString());

      if (response.statusCode >= 400) {
        print(response.error.toString());
        throw ApiError(
          statusCode: response.statusCode,
          message: response.error.toString(),
        );
      }

      return response;
    } on ApiError catch (ex) {
      throw ex;
    } on SocketException catch (ex) {
      throw ApiError(message: ex.osError.toString());
    } catch (ex) {
      throw ApiError(message: AppStrings.generalErrorMessage);
    }
  }
}

/* Future<String> login() async {
    LoginRequest loginRequest =
        LoginRequest(username: "vlada@gmail.com", password: "12345678");
    final rawTasks =
        (await _makeCheckedCall(() => taskService.login(loginRequest.toJson())))
            .headers
            .values as List<dynamic>;

    final token = rawTasks[0];

    return token;
  }*/
