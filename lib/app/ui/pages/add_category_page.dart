import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app/api/api_error.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/blocks/edit_page_block.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/dialog/error_dialog.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/view/modal_action_button_view.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/textfield/text_field_view.dart';
import 'package:task_manager/app/ui/pages/edit_task_page.dart';
import 'package:task_manager/app/ui/widgets/view/states_view.dart';

class AddCategoryPage extends StatefulWidget {
  final List<Category> categories;
  final List<Category> newCategories;
  const AddCategoryPage({Key key, @required this.categories, @required this.newCategories}) : super(key: key);

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
          controller: _textTaskController,
          icon: Icon(Icons.category, color: Theme.of(context).accentColor),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 24,
        ),
        CustomModalActionButton(onClose: () {
          Navigator.of(context).pop();
        }, onSave: () async {
          if (isValidData()) {
            Category category = new Category(name: _textTaskController.text);
            try {
              await BlocProvider.getBloc<EditPageBlock>()
                  .apiClient
                  .addCategory(category);
            } on ApiError catch (ex) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                            message: "Error. status code: " +
                                ex.statusCode.toString())
                        .build(context);
                  });
            }
              widget.newCategories.add(category);
              _textTaskController.clear();
          }
        }),
      ],
    );
  }

  bool isValidData() {
    _textTaskController.text = _textTaskController.text.trim();
    if (_textTaskController.text == "") {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(message: "Please enter category name...")
                .build(context);
          });
      return false;
    }

    for (int i = 0; i < widget.categories.length; i++) {
      if (widget.categories[i].name == _textTaskController.text) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(message: "This category already exist")
                  .build(context);
            });
        return false;
      }
    }
    return true;
  }
}
