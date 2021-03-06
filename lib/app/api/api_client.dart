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
    baseUrl: ApiConstants.host,
    services: [
      TaskService.create(),
      CategoryService.create(),
    ],
    converter: JsonConverter(),
  );

  static final taskService = _chopperClient.getService<TaskService>();

  static final categoryService = _chopperClient.getService<CategoryService>();

  Future<List<Task>> getAllTasks() async {
    Response<dynamic> response =
        await _makeCheckedCall(() => taskService.getAllTasks());
    print("GET request is succeed");
    final rawTasks = response.body as List<dynamic>;
    final tasks = rawTasks.map((rawTasks) => Task.fromJson(rawTasks)).toList();

    return tasks;
  }

  Future<List<Task>> getAllTasksByCategoryId(int categoryId) async {
    Response<dynamic> response = await _makeCheckedCall(
        () => taskService.getAllTasksByCategoryId(categoryId));
    print("GET request is succeed");
    final rawTasks = response.body as List<dynamic>;
    final tasks = rawTasks.map((rawTasks) => Task.fromJson(rawTasks)).toList();

    return tasks;
  }

  Future<List<Task>> getGoneTasks(String endDateTime) async {
    Response<dynamic> response =
        await _makeCheckedCall(() => taskService.getGoneTasks(endDateTime));
    print("GET request is succeed");
    final rawTasks = response.body as List<dynamic>;
    final tasks = rawTasks.map((rawTasks) => Task.fromJson(rawTasks)).toList();

    return tasks;
  }

  Future<List<Task>> getUnfinishedTasks() async {
    Response<dynamic> response =
        await _makeCheckedCall(() => taskService.getUnfinishedTasks());
    print("GET request is succeed");
    final rawTasks = response.body as List<dynamic>;
    final tasks = rawTasks.map((rawTasks) => Task.fromJson(rawTasks)).toList();

    return tasks;
  }

  Future<List<Task>> getAllTasksDuringDays(String start, String end) async {
    Response<dynamic> response = await _makeCheckedCall(
        () => taskService.getAllTasksDuringDays(start, end));
    print("GET request is succeed");
    final rawTasks = response.body as List<dynamic>;
    final tasks = rawTasks.map((rawTasks) => Task.fromJson(rawTasks)).toList();

    return tasks;
  }

  Future<List<Task>> getAllPlannedTasks(String start) async {
    Response<dynamic> response =
        await _makeCheckedCall(() => taskService.getAllPlannedTasks(start));
    print("GET request is succeed");
    final rawTasks = response.body as List<dynamic>;
    final tasks = rawTasks.map((rawTasks) => Task.fromJson(rawTasks)).toList();

    return tasks;
  }

  Future<List<Category>> getCategories() async {
    Response<dynamic> response =
        await _makeCheckedCall(() => categoryService.getAllCategories());
    print("GET request for all categories");
    final rawCategories = response.body as List<dynamic>;
    final categories = rawCategories
        .map((rawCategories) => Category.fromJson(rawCategories))
        .toList();

    return categories;
  }

  Future addTask(Task task) async {
    try {
      await _makeCheckedCall(() => taskService.addTask(task.toJson()));
    } on ApiError catch (ex) {
      rethrow;
    } on SocketException catch (ex) {
      rethrow;
    } catch (ex) {
      rethrow;
    }
    print("POST request for task");
  }

  Future deleteTask(int taskId) async {
    try {
      await _makeCheckedCall(() => taskService.deleteTask(taskId));
    } on ApiError catch (ex) {
      rethrow;
    } on SocketException catch (ex) {
      rethrow;
    } catch (ex) {
      rethrow;
    }
    print("DELETE request for task");
  }

  Future deleteAllTasksByCategoryId(int categoryId) async {
    try {
      await _makeCheckedCall(() => taskService.deleteAllByCategoryId(categoryId));
    } on ApiError catch (ex) {
      rethrow;
    } on SocketException catch (ex) {
      rethrow;
    } catch (ex) {
      rethrow;
    }
    print("DELETE request for task");
  }

  Future deleteCategoryById(int categoryId) async {
    try {
      await _makeCheckedCall(() => categoryService.deleteById(categoryId));
    } on ApiError catch (ex) {
      rethrow;
    } on SocketException catch (ex) {
      rethrow;
    } catch (ex) {
      rethrow;
    }
    print("DELETE request for category");
  }

  Future addCategory(Category category) async {
    try {
      await _makeCheckedCall(
          () => categoryService.addCategory(category.toJson()));
      print("POST request for category");
    } on ApiError catch (ex) {
      rethrow;
    } on SocketException catch (ex) {
      throw ApiError(message: ex.osError.toString());
    } catch (ex) {
      throw ApiError(message: AppStrings.generalErrorMessage);
    }
  }

  Future<Response> _makeCheckedCall(Future<Response> Function() call) async {
    try {
      final response = await call();

      if (response.statusCode >= 400) {
        print(response.error.toString());
        throw ApiError(
          statusCode: response.statusCode,
          message: response.error.toString(),
        );
      }
      return response;
    } on ApiError catch (ex) {
      rethrow;
    } on SocketException catch (ex) {
      rethrow;
    } catch (ex) {
      rethrow;
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
