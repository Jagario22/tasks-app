import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:task_manager/app/api/api_client.dart';
import 'package:task_manager/app/api/api_error.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/blocks/state.dart';

class EditPageBlock extends BlocBase {
  final ApiClient apiClient;

  EditPageBlock(this.apiClient);

  final _categoriesController = StreamController<AppState<List<Category>>>()
    ..add(InitialState());

  Stream<AppState<List<Category>>> get categoriesStream =>
      _categoriesController.stream;

  @override
  void dispose() {
    _categoriesController.close();
    super.dispose();
  }

  void getCategoriesAll() async {
    _makeCallForController(
      _categoriesController,
      () => apiClient.getCategories(),
    );
  }

  void addCategory(Category category) async {
    _makeCallForController(_categoriesController, () => apiClient.addCategory(category));
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
