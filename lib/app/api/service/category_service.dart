import 'package:chopper/chopper.dart';
import 'package:task_manager/app/resources/api_constants.dart';

part 'category_service.chopper.dart';

@ChopperApi(baseUrl: AppConstants.categoriesURL)
abstract class CategoryService extends ChopperService {
  static CategoryService create([ChopperClient client]) => _$CategoryService(client);

  @Get()
  Future<Response> getAllCategories();

  @Post(path: "/add")
  Future<Response> addCategory(@Body() Map<String, dynamic> category);

/*
  @Get(path: '/{id}')
  Future<Response> getTodoById(@Path() int id);*/
}