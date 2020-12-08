import 'package:chopper/chopper.dart';
import 'package:task_manager/app/resources/api_constants.dart';

part 'category_service.chopper.dart';

@ChopperApi(baseUrl: ApiConstants.categoriesURL)
abstract class CategoryService extends ChopperService {
  static CategoryService create([ChopperClient client]) => _$CategoryService(client);

  @Get()
  Future<Response> getAllCategories();

  @Post(path: ApiConstants.deleteCategoryById)
  Future<Response> deleteById(int id);


  @Post(path: ApiConstants.addCategory)
  Future<Response> addCategory(@Body() Map<String, dynamic> category);
}