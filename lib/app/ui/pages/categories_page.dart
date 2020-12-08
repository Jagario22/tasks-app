import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app/api/api_error.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/api/model/page_status.dart';
import 'package:task_manager/app/blocks/categories_page_block.dart';
import 'package:task_manager/app/blocks/state.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'package:task_manager/app/resources/theme/colors/light_colors.dart';
import 'package:task_manager/app/ui/pages/add_category_page.dart';
import 'package:task_manager/app/ui/pages/tasks_page.dart';
import 'package:task_manager/app/ui/widgets/dialog/error_dialog.dart';
import 'package:task_manager/app/ui/widgets/itemview/category_view.dart';
import 'package:task_manager/app/ui/widgets/navdrawer.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/states_view.dart';
import 'package:task_manager/util/task_page_mode.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _bloc = BlocProvider.getBloc<CategoriesPageBlock>();
  final PageStatus pageStatus = new PageStatus();
  Category _selectedCategory;
  AppBar _appBar;

  Widget _buildDefaultBar() {
    return AppBar(
      iconTheme: IconThemeData(color: LightColors.kDarkBlue),
      backgroundColor: LightColors.kDarkYellow,
      title: Text(AppStrings.categories),
      actions: <Widget>[
        IconButton(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            onPressed: () {
              _bloc.getCategoriesAll();
            },
            icon: Icon(Icons.refresh)),
      ],
    );
  }

  Widget _buildSelectedBar(Category category) {
    return AppBar(
      iconTheme: IconThemeData(color: LightColors.kDarkBlue),
      backgroundColor: LightColors.kDarkYellow,
      title: Text(category.name),
      actions: <Widget>[
        IconButton(
            padding: EdgeInsets.all(10),
            icon: Icon(Icons.edit),
            iconSize: 25,
            onPressed: () {
              _showSaveCategoryDialog(category);
            }),
        IconButton(
            padding: EdgeInsets.all(10),
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _showDialog(category).then((value) {
                  setState(() {
                    _resetSelectOptions();
                  });
                });
              });
            }),
        IconButton(
            padding: EdgeInsets.all(10),
            icon: Icon(Icons.close),
            iconSize: 30,
            onPressed: () {
              setState(() {
                _resetSelectOptions();
              });
            }),
      ],
    );
  }

  void _resetSelectOptions() {
     _appBar = _buildDefaultBar();
    _selectedCategory = null;
  }

  @override
  void initState() {
    _bloc.getCategoriesAll();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      drawer: NavDrawer(),
      appBar: _appBar == null ? _buildDefaultBar() : _appBar,
      body: _buildStreamBuilder(),
      floatingActionButton: FloatingActionButton(
        heroTag: "add category btn",
        onPressed: () {
          _showSaveCategoryDialog(null);
        },
        child: Icon(Icons.add, color: Theme.of(context).primaryColorDark),
        backgroundColor: Colors.yellow,
      ),
    );
  }

  void _showSaveCategoryDialog(Category category) {
    showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: SingleChildScrollView(
                    child: AddCategoryPage(
                  status: pageStatus,
                  category: category,
                )),
              );
            })
        .then((value) => {
              if (pageStatus.requiredUpdate == true)
                {_bloc.getCategoriesAll(), pageStatus.requiredUpdate = false}
            })
        .then((value) {
      setState(() {
        _resetSelectOptions();
      });
    });
  }

  Widget _buildStreamBuilder() {
    return StreamBuilder<AppState<List<Category>>>(
      stream: _bloc.categoriesStream,
      builder: _buildResponse,
    );
  }

  Widget _buildCategories(List<Category> categories) {
    return Container(
        padding: EdgeInsets.all(12.0),
        child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (_, index) {
              Category category = categories[index];
              return CategoryView(
                  isSelected: category == _selectedCategory,
                  category: category,
                  onLongPress: () {
                    setState(() {
                      _selectedCategory = category;
                      _appBar = _buildSelectedBar(category);
                    });
                    //_showDialog(category);
                  },
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TasksPage(
                            pageMode: EMode.OF_CATEGORY,
                            category: category),
                      ),
                    );
                  });
            }));
  }

  Future<dynamic> _showDialog(Category category) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(AppStrings.deleteAlertTitle),
              content: Text("All the tasks of category \"" +
                  category.name +
                  "\" will be deleted with this category"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppStrings.cancelAlert)),
                FlatButton(
                    onPressed: () {
                      _deleteCategory(category.id);
                      Navigator.of(context).pop();
                    },
                    child: Text(AppStrings.okAlert)),
              ],
            ));
  }

  Future<void> _deleteCategory(int categoryId) async {
    try {
      await _bloc.apiClient.deleteAllTasksByCategoryId(categoryId);
      print(
          "the request to delete all tasks of category $categoryId was completed successfully");
      await _bloc.apiClient.deleteCategoryById(categoryId);
      _bloc.getCategoriesAll();
    } on ApiError catch (ex) {
      showDialog(
          builder: (BuildContext context) {
            return ErrorDialog(
                    message: AppStrings.errorAlertText + ex.statusCode.toString())
                .build(context);
          },
          context: context);
    }
  }

  Widget _buildResponse(
    BuildContext context,
    AsyncSnapshot<AppState<List<Category>>> snapshot,
  ) {
    if (!snapshot.hasData) {
      return Center(
        child: Text(AppStrings.noData),
      );
    }

    final categories = snapshot.data;

    if (categories is LoadingState) {
      return BlocStates.buildLoader();
    }

    if (categories is SuccessState) {
      return _buildCategories((categories as SuccessState).data);
    }

    if (categories is ErrorState) {
      return BlocStates.buildError((categories as ErrorState).errorMessage);
    }

    return BlocStates.buildLoader();
  }
}
