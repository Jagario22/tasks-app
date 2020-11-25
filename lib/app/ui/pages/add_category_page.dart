import 'package:flutter/material.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/dialog/error_dialog.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/view/modal_action_button_view.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/textfield/text_field_view.dart';

class AddCategoryPage extends StatefulWidget {
  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _textTaskController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    _textTaskController.clear();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: _buildAddCategoryForm(),
    );
  }

  Widget _buildAddCategoryForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CustomTextField(
              controller: _textTaskController, icon: Icon(Icons.category, color: Theme.of(context).accentColor),),
        SizedBox(height: 12),
        SizedBox(
          height: 24,
        ),
        CustomModalActionButton(onClose: () {
          Navigator.of(context).pop();
        }, onSave: () async {
          if (isValidData()) {
            //Category
            Category category = new Category(name: _textTaskController.text);
            /*try {
              print("processing");
              await BlocProvider
                  .getBloc<TaskPageBlock>()
                  .apiClient
                  .addCategory(category);
            } on ApiError catch (ex) {
              return BlocStates.buildError(ex.message);
            }*/
          }
        }),
      ],
    );
  }

  bool isValidData() {
    if (_textTaskController.text == "") {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(message: "Please enter category name...").build(context);
          });
      return false;
    }
    return true;
  }

  /*Widget _buildResponse(
      BuildContext context,
      AsyncSnapshot<AppState<List<Task>>> snapshot,
      ) {
    //no data
    if (!snapshot.hasData) {
      return Center(
        child: Text(AppStrings.noData),
      );
    }

    Widget _buildLoader() {
      return BlocStates.buildLoader();
    }

    final tasks = snapshot.data;

    //initial state
    if (tasks is InitialState) {
      return Center(
        child: Text(AppStrings.initialTaskStateLabel),
      );
    }
    //loaded tasks
    if (tasks is SuccessState) {
      Navigator.of(context).pop();
    }

    //error
    if (tasks is ErrorState) {
      return BlocStates.buildError((tasks as ErrorState).errorMessage);
    }

    return _buildLoader();
  }*/


}
