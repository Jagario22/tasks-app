import 'package:chopper/chopper.dart';
import 'package:task_manager/app/resources/api_constants.dart';

part 'task_service.chopper.dart';

@ChopperApi(baseUrl: AppConstants.tasksURL)
abstract class TaskService extends ChopperService {


  static TaskService create([ChopperClient client]) => _$TaskService(client);

  @Get()
  Future<Response> getAllTasks();

  @Get(path: "/gone/{endDateTime}")
  Future<Response> getGoneTasks(String endDateTime);

  @Post(path: "/add")
  Future<Response> addTask(@Body() Map<String, dynamic> task);

  @Get(path: "/during/days/{start}/{end}")
  Future<Response> getAllTasksDuringDays(@Path() String start, @Path() String end);

  @Get(path: "/during/planned/{startDay}")
  Future<Response> getAllPlannedTasks(@Path() String start);

  @Get(path: "/unfinished")
  Future<Response> getUnfinishedTasks();

  @Delete(path: "/delete/id/{taskId}")
  Future<Response> deleteTask(@Path() int taskId);

}