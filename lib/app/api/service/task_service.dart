import 'package:chopper/chopper.dart';
import 'package:task_manager/app/resources/api_constants.dart';

part 'task_service.chopper.dart';

@ChopperApi(baseUrl: ApiConstants.tasksURL)
abstract class TaskService extends ChopperService {


  static TaskService create([ChopperClient client]) => _$TaskService(client);

  @Get()
  Future<Response> getAllTasks();

  @Get(path: ApiConstants.getAllTasksByCategoryId)
  Future<Response> getAllTasksByCategoryId(int categoryId);

  @Post(path: ApiConstants.deleteAllByCategoryId)
  Future<Response> deleteAllByCategoryId(@Path() int categoryId);

  @Get(path: ApiConstants.getGoneTasks)
  Future<Response> getGoneTasks(String endDateTime);

  @Post(path: ApiConstants.addTask)
  Future<Response> addTask(@Body() Map<String, dynamic> task);

  @Get(path: ApiConstants.getAllTasksDuringDays)
  Future<Response> getAllTasksDuringDays(@Path() String start, @Path() String end);

  @Get(path: ApiConstants.getAllPlannedTasks)
  Future<Response> getAllPlannedTasks(@Path() String start);

  @Get(path: ApiConstants.getUnfinishedTasks)
  Future<Response> getUnfinishedTasks();

  @Delete(path: ApiConstants.deleteTask)
  Future<Response> deleteTask(@Path() int taskId);

}