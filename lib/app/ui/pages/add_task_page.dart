import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/app/api/api_error.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/blocks/state.dart';
import 'package:task_manager/app/blocks/task_block.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/datetime/datetime_picker_view.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/dialog/error_dialog.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/view/modal_action_button_view.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/view/states_view.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/textfield/text_field_view.dart';
import 'package:time_machine/time_machine.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();
  final _textTaskController = TextEditingController();
  Task _newTask;
  String status;

  Future<DateTime> _pickDate() async {
    DateTime datetime;
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

  @override
  Widget build(BuildContext context) {
    _textTaskController.clear();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: _buildTaskInfoForm(),
    );
  }

  Widget _buildTaskInfoForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(
            child: Text(
              "Add new task",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme
                      .of(context)
                      .accentColor),
            )),
        SizedBox(
          height: 24,
        ),
        CustomTextField(
            labelText: 'Enter task name', controller: _textTaskController),
        SizedBox(height: 12),
        _getTimePicker(_selectedStartDate),
        _getTimePicker(_selectedEndDate),
        SizedBox(
          height: 24,
        ),
        CustomModalActionButton(onClose: () {
          Navigator.of(context).pop();
        }, onSave: () async {
          if (isValidData()) {
            _newTask = new Task(
                title: _textTaskController.text,
                completed: false,
                startTime: formatDate(_selectedStartDate).toString(),
                endTime: formatDate(_selectedStartDate).toString());

            try {
              print("processing");
              await BlocProvider
                  .getBloc<TaskPageBlock>()
                  .apiClient
                  .addTask(_newTask);
            } on ApiError catch (ex) {
              return BlocStates.buildError(ex.message);
            }
          }
        }),
      ],
    );
  }
  Widget _getTimePicker(DateTime value) {
    return CustomDateTimePicker(
      icon: Icons.date_range,
      onPressed: () async {
        value = await _pickDate();
      },
      date: new DateFormat.yMMMMd('en_US').format(value),
      time: new DateFormat.jm().format(value),
    );
  }

  bool isValidData() {
    if (_textTaskController.text == "") {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(message: "No data").build(context);
          });
      return false;
    } else if (_selectedStartDate.isAfter(_selectedEndDate)) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(message: "End date should be before start date")
                .build(context);
          });
      return false;
    }
    return true;
  }

  Widget _buildResponse(
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
  }

  OffsetDateTime formatDate(DateTime dateTime) {
    return OffsetDateTime(
        LocalDateTime.dateTime(dateTime, CalendarSystem.gregorian),
        Offset.duration(dateTime.timeZoneOffset));
  }
}
