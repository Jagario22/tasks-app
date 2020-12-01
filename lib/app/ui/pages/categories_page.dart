import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/blocks/edit_page_block.dart';
import 'package:task_manager/app/blocks/state.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'package:task_manager/app/ui/widgets/itemview/custom_list_tile.dart';
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
  bool _shouldChangeListView = false;
  List<Category> _categories = new List();
  List<Category> _newCategories = new List();
  bool _selectedNone;

  @override
  void initState() {
    _selectedNone = widget.task == null ? true : false;
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
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
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
          CustomListTle(
            onTap: () {
              setState(() {
                widget.task.category = null;
                _selectedNone = true;
              });
              Navigator.of(context).pop();
            },
            title: Text("None"),
            selectedTrailing: Icon(Icons.check),
            selectedColor: Theme.of(context).hoverColor,
            selected: _selectedNone,
            selectedTitle: Text(
              "None",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark),
            ),
          ),
          _buildCategoriesStream(),
          CustomButton(
            buttonText: "Add category",
            onPressed: () async {
              _shouldChangeListView = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: SingleChildScrollView(
                          child: AddCategoryPage(
                        categories: _categories,
                        newCategories: _newCategories,
                      )),
                    );
                  });
              if (_shouldChangeListView == null || _shouldChangeListView)
                setState(() {
                  _categories.addAll(_newCategories);
                });
            },
          ),
        ],
      ),
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
      this._categories = (categories as SuccessState).data;
      return _buildCategories();
    }

    //error
    if (categories is ErrorState) {
      return BlocStates.buildError((categories as ErrorState).errorMessage);
    }

    return BlocStates.buildLoader();
  }

  Widget _buildCategories() {
    return Expanded(
        child: ListView.builder(
      itemCount: _categories.length,
      itemBuilder: (_, index) => _buildCategoryItem(
        _categories[index],
      ),
    ));
  }

  Widget _buildCategoryItem(Category categoryItem) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: CustomListTle(
        onTap: () {
          setState(() {
            widget.task.category = categoryItem;
            _selectedNone = false;
            Navigator.of(context).pop();
          });
        },
        selectedTitle: Text(categoryItem.name,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark)),
        title: Text(categoryItem.name),
        selected: widget.task.category == null
            ? false
            : widget.task.category.name == categoryItem.name,
        selectedColor: Theme.of(context).hoverColor,
        selectedTrailing: Icon(Icons.check),
      ),
    );
  }
}
