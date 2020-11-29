import 'package:chopper/chopper.dart';
import 'package:task_manager/app/resources/api_constants.dart';

part 'task_service.chopper.dart';

@ChopperApi(baseUrl: AppConstants.tasksURL)
abstract class TaskService extends ChopperService {
  static TaskService create([ChopperClient client]) => _$TaskService(client);

  @Get()
  Future<Response> getAllTasks();

  @Post(path: "/add")
  Future<Response> addTask(@Body() Map<String, dynamic> task);

  @Post()
  Future<Response> login(@Body() Map<String, dynamic> loginRequest);

  @Delete(path: "/delete/id/{taskId}")
  Future<Response> deleteTask(@Path() int taskId);
/*
  @Get(path: '/{id}')
  Future<Response> getTodoById(@Path() int id);*/
}