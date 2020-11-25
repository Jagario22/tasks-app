import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/api/model/priority.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/datetime/datetime_picker_view.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/textfield/text_field_view.dart';
import 'package:task_manager/app/ui/pages/categories_page.dart';
import 'package:task_manager/app/ui/pages/priority_page.dart';

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
  final _textTaskController = TextEditingController();
  final _textDescriptionController = TextEditingController();
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  Task _newTask = new Task(
    title: "",
    endTime: "",
    startTime: "",
    completed: false,
    category: null,
  );
  String categoryTitle = AppStrings.category;
  String priorityTitle = AppStrings.priority;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.editor),
        centerTitle: true,
      ),
      body: _buildEditor(),
      floatingActionButton: FloatingActionButton(
        onPressed: onSave,
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _buildEditor() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical, child: _buildEditInfoColumn());
  }

  Widget _buildEditInfoColumn() {
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
            DateTime datetime = await _pickDate();
            setState(() {
              _selectedStartDate = datetime;
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

  void onSave() {}

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
                  size: 25, color: Theme.of(context).accentColor), _getAllCategories),
           _buildAdvanceTaskInfo(
              priorityTitle,
              Icon(Icons.label_important,
                  size: 25, color: Theme.of(context).accentColor), _getAllPriority),
        ],
      ),
    );
  }

  String getCategoryTitle() {
    if (widget.task == null) {
      if (_newTask.category != null) {
        return _newTask.category.name;
      }
    } else {
      if (widget.task.category != null) {
        return widget.task.category.name;
      }
    }
    return "";
  }

  String getPriorityTitle() {
    if (widget.task == null) {
      if (_newTask.priority != null) {
        return EnumUtil.fromEnumToString(_newTask.priority);
      }
    } else {
      if (widget.task.category != null) {
        return EnumUtil.fromEnumToString(widget.task.priority);
      }
    }
    return "";
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
                width: 100.0,
                height: 250.0,
                child: widget.task == null
                    ? CategoriesPage(task: _newTask)
                    : CategoriesPage(task: widget.task),
              ));
        });
    setState(() {
      if (shouldUpdate == true || shouldUpdate == null)
        categoryTitle = AppStrings.category + ": " + getCategoryTitle();
    });
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
                height: 250.0,
                child: widget.task == null
                    ? PriorityPage(task: _newTask)
                    : PriorityPage(task: widget.task),
              ));
        });
    setState(() {
      if (shouldUpdate == true || shouldUpdate == null)
        priorityTitle = AppStrings.priority + ": " + getPriorityTitle();
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
                _textTaskController),
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
