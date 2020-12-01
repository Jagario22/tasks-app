// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$TaskService extends TaskService {
  _$TaskService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = TaskService;

  Future<Response> getAllTasks() {
    final $url = '/tasks';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getGoneTasks(String endDateTime) {
    final $url = '/tasks/gone/${endDateTime}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> addTask(Map<String, dynamic> task) {
    final $url = '/tasks/add';
    final $body = task;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getAllTasksDuringDays(
      String start, String end) {
    final $url = '/tasks/during/days/${start}/${end}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getAllPlannedTasks(
      String startDay) {
    final $url = 'tasks/during/planned/${startDay}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> getUnfinishedTasks() {
    final $url = '/tasks/unfinished';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response> deleteTask(int taskId) {
    final $url = '/tasks/delete/id/${taskId}';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
