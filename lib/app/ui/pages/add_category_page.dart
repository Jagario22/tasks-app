import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app/api/api_error.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/api/model/page_status.dart';
import 'package:task_manager/app/blocks/categories_page_block.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/dialog/error_dialog.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/view/modal_action_button_view.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/textfield/custom_text_field.dart';
import 'package:task_manager/app/resources/strings.dart';

class AddCategoryPage extends StatefulWidget {
  final List<Category> categories;
  final Category category;
  final PageStatus status;

  const AddCategoryPage({Key key, this.categories, this.status, this.category})
      : super(key: key);

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final _textTaskController = TextEditingController();

  @override
  void initState() {
    if (widget.category != null) {
      _textTaskController.text = widget.category.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        }, onSave: () async {
          _saveCategory();
        }),
      ],
    );
  }

  Future<void> _saveCategory() async {
    FocusScope.of(context).unfocus();
    if (isValidData()) {
      Category result;
      final _bloc = BlocProvider.getBloc<CategoriesPageBlock>();
      try {
        if (widget.category == null)
          result = new Category(name: _textTaskController.text);
        else {
          result = widget.category;
          result.name = _textTaskController.text;
        }
        await _bloc.apiClient.addCategory(result);
      } on ApiError catch (ex) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                      message:
                          AppStrings.errorAlertText + ex.statusCode.toString())
                  .build(context);
            });
      }
      _bloc.dispose();
      if (widget.status != null) widget.status.requiredUpdate = true;
    }
    Navigator.of(context).pop();
  }

  bool isValidData() {
    _textTaskController.text = _textTaskController.text.trim();
    if (_textTaskController.text == "") {
      _showErrorDialog(AppStrings.enterCategoryHint);
      return false;
    }
    if (widget.categories != null) {
      for (int i = 0; i < widget.categories.length; i++) {
        if (widget.categories[i].name == _textTaskController.text) {
          _showErrorDialog(AppStrings.categoryAlreadyExist);
          return false;
        }
      }
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(message: message)
              .build(context);
        });
  }
}
