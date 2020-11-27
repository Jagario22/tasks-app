import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/app/api/api_error.dart';
import 'package:task_manager/app/api/model/priority.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/blocks/task_block.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/datetime/datetime_picker_view.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/textfield/text_field_view.dart';
import 'package:task_manager/app/ui/pages/categories_page.dart';
import 'package:task_manager/app/ui/pages/priority_page.dart';
import 'package:task_manager/app/ui/widgets/dialog/custom_bottom_dialog.dart';
import 'package:task_manager/app/ui/widgets/dialog/error_dialog.dart';
import 'package:task_manager/util/date_util.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({
    Key key,
    this.task,
  }) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _taskTitleController = TextEditingController();
  final _textDescriptionController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now().toLocal();
  DateTime _selectedEndDate = DateTime.now().toLocal();
  Task _newTask;

  String categoryTitle = AppStrings.category;
  String priorityTitle = AppStrings.priority;

  @override
  void initState() {
    if (widget.task == null) {
      _newTask = new Task(
        title: "",
        endTime: "",
        startTime: "",
        completed: false,
        category: null,
      );
    } else {
      _newTask = widget.task;
      _textDescriptionController.text = widget.task.description;
      _taskTitleController.text = widget.task.title;
      _selectedStartDate = DateTime.parse(widget.task.startTime);
      _selectedEndDate = DateTime.parse(widget.task.endTime);
      categoryTitle += getCategoryTitle();
      priorityTitle += getPriorityTitle();
    }
    super.initState();
  }



  String getCategoryTitle() {
    if (_newTask.category != null) {
      return ": " + _newTask.category.name;
    }
    return "";
  }

  String getPriorityTitle() {
    if (_newTask.priority != null) {
      return  ": " + EnumUtil.fromEnumToString(_newTask.priority);
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.editor),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical, child: _buildEditor()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onSave,
        child: Icon(Icons.check, color: Theme.of(context).primaryColorDark),
        backgroundColor: Colors.yellow,
      ),
    );
  }

  Widget _buildEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildColorContainer(),
        SizedBox(height: 30),
        CustomDateTimePicker(
          name: "Start date",
          icon: Icons.hourglass_bottom,
          onPressed: () async {
            FocusScope.of(context).unfocus();
            DateTime datetime = await _pickDate();
            setState(() {
              _selectedStartDate = datetime;
            });
          },
          date: new DateFormat.yMMMMd('en_US').format(_selectedStartDate),
          time: new DateFormat.jm().format(_selectedStartDate),
        ),
        SizedBox(
          height: 30,
        ),
        CustomDateTimePicker(
          name: "Deadline",
          icon: Icons.hourglass_bottom,
          onPressed: () async {
            FocusScope.of(context).unfocus();
            DateTime datetime = await _pickDate();
            setState(() {
              _selectedEndDate = datetime;
            });
          },
          date: new DateFormat.yMMMMd('en_US').format(_selectedEndDate),
          time: new DateFormat.jm().format(_selectedEndDate),
        ),
        SizedBox(
          height: 30,
        ),
        const Divider(
          color: Colors.grey,
          height: 0,
          thickness: 1,
          indent: 0,
          endIndent: 0,
        ),
        _buildAddTaskInfo(),
      ],
    );
  }

  Future<void> onSave() async {
    try {
      FocusScope.of(context).unfocus();
      if (!_isValidData()) return;
      _newTask.title = _taskTitleController.text;
      _newTask.description = _textDescriptionController.text;
      _newTask.startTime = DateUtil.formatDate(_selectedStartDate).toString();
      _newTask.endTime = DateUtil.formatDate(_selectedEndDate).toString();
      _newTask.completed = false;
      print("processing POST request for task");
      await BlocProvider.getBloc<TaskPageBlock>().apiClient.addTask(_newTask);
      Navigator.pop(context);
    } on ApiError catch (ex) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
                    message: "Error. status code: " + ex.statusCode.toString())
                .build(context);
          });
    }
  }

  bool _isValidData() {
    if (_taskTitleController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => CustomBottomDialog(
                message: "Please, enter the title of the task",
              ));
      return false;
    } else if (_selectedStartDate.isAfter(_selectedEndDate)) {
      showDialog(
          context: context,
          builder: (context) =>
              CustomBottomDialog(
                message: "The start date should be before the deadline",
              ));
      return false;
    }
    return true;
  }

  Widget _buildAddTaskInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Advance",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.yellow.shade800)),
          _buildAdvanceTaskInfo(
              categoryTitle,
              Icon(Icons.category,
                  size: 25, color: Theme.of(context).accentColor),
              _getAllCategories),
          _buildAdvanceTaskInfo(
              priorityTitle,
              Icon(Icons.label_important,
                  size: 25, color: Theme.of(context).accentColor),
              _getAllPriority),
        ],
      ),
    );
  }

  void _getAllCategories() async {
    bool shouldUpdate = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Container(
                width: 400.0,
                height: 450.0,
                child: CategoriesPage(task: _newTask),
              ));
        });
    setState(() {
      if ((shouldUpdate == true || shouldUpdate == null)) {
        if (!isNewTaskCategoryNull())
          categoryTitle = AppStrings.category + getCategoryTitle();
        else
          categoryTitle = AppStrings.category;
      }
    });
  }

  bool isNewTaskCategoryNull() {
    if (_newTask.category == null) return true;

    return false;
  }

  bool _isNewTaskPriorityNull() {
    if (_newTask.priority == null) return true;

    return false;
  }

  void _getAllPriority() async {
    bool shouldUpdate = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Container(
                  width: 100.0,
                  height: 300.0,
                  child: PriorityPage(task: _newTask)));
        });
    setState(() {
      if ((shouldUpdate == true || shouldUpdate == null)) {
        if (!_isNewTaskPriorityNull())
          priorityTitle = AppStrings.priority +  getPriorityTitle();
        else
          priorityTitle = AppStrings.priority;
      }
    });
  }

  Widget _buildAdditionInfoItem(String name, Icon icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        SizedBox(
          width: 20,
        ),
        Text(name,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
      ],
    );
  }

  Widget _buildAdvanceTaskInfo(String name, Icon icon, Function onTap) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          onTap();
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(22, 22, 0, 22),
          child: _buildAdditionInfoItem(name, icon),
        ),
      ),
    );
  }

  Widget _buildColorContainer() {
    return Container(
        padding: EdgeInsets.fromLTRB(20.0, 40, 30, 50),
        color: Colors.teal,
        child: Column(
          children: [
            _buildTextField(
                'Enter task name',
                Icon(Icons.title, color: Colors.teal.shade50),
                _taskTitleController),
            SizedBox(height: 16),
            _buildTextField(
                'Note',
                Icon(Icons.event_note_sharp, color: Colors.teal.shade50),
                _textDescriptionController)
          ],
        ));
  }

  Widget _buildTextField(
      String text, Icon icon, TextEditingController textController) {
    return Padding(
      padding: EdgeInsets.fromLTRB(40.0, 10, 0, 0),
      child: CustomTextField(
          icon: icon,
          labelText: text,
          controller: textController,
          textColor: Colors.white,
          labelColor: Colors.white70),
    );
  }

  Future<DateTime> _pickDate() async {
    DateTime datetime = _selectedStartDate;
    DateTime datepick = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now().add(Duration(days: -365)),
        lastDate: new DateTime.now().add(Duration(days: 365)));

    TimeOfDay timepick = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );

    if (datepick != null && timepick != null)
      setState(() {
        datetime = DateTime(datepick.year, datepick.month, datepick.day,
            timepick.hour, timepick.minute);
      });

    return datetime;
  }
}
