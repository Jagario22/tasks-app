import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/blocks/edit_page_block.dart';
import 'package:task_manager/app/blocks/state.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'add_category_page.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/view/states_view.dart';
import 'package:task_manager/app/ui/widgets/button/button_view.dart';

class CategoriesPage extends StatefulWidget {
  final Task task;

  const CategoriesPage({@required this.task});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _bloc = BlocProvider.getBloc<EditPageBlock>();

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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back_rounded)),
            SizedBox(width: 11),
            Text(AppStrings.categories,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        _buildCategoriesStream(),
        CustomButton(
          buttonText: "Add category",
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: SingleChildScrollView(child: AddCategoryPage()),
                  );
                });
          },
        ),
      ],
    );
  }

  Widget _buildCategoriesStream() {
    return StreamBuilder<AppState<List<Category>>>(
        stream: _bloc.categoriesStream, builder: _buildResponse);
  }

  Widget _buildResponse(
    BuildContext context,
    AsyncSnapshot<AppState<List<Category>>> snapshot,
  ) {
    //no data
    if (!snapshot.hasData) {
      return Center(
        child: Text(AppStrings.noData),
      );
    }

    final categories = snapshot.data;

    //initial state
    if (categories is InitialState) {
      return Center(
        child: Text(AppStrings.initialTaskStateLabel),
      );
    }

    if (categories is LoadingState) {
      return BlocStates.buildLoader();
    }

    if (categories is SuccessState) {
      return _buildCategories((categories as SuccessState).data);
    }

    //error
    if (categories is ErrorState) {
      return BlocStates.buildError((categories as ErrorState).errorMessage);
    }

    return BlocStates.buildLoader();
  }

  Widget _buildCategories(List<Category> categories) {
    return Expanded(
        child: ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: categories.length,
      itemBuilder: (_, index) => _buildCategoryItem(
        categories[index],
      ),
    ));
  }

  Widget _buildCategoryItem(Category categoryItem) {
    return Container(
        padding: EdgeInsets.all(2.0),
        child: InkWell(
            onTap: () {
              setState(() {
                widget.task.category = categoryItem;
                Navigator.of(context).pop();
              });
            },
            child: Container(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(categoryItem.name),
              ),
            )));
  }
}
