import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/app/resources/theme/colors/light_colors.dart';
import 'package:task_manager/util/task_page_mode.dart';
import '../../api/api_error.dart';
import '../../api/model/page_status.dart';
import '../../api/model/priority.dart';
import '../../api/model/task.dart';
import '../../blocks/task_block.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'package:task_manager/app/ui/pages/selection/select_categories_page.dart';
import 'package:task_manager/app/ui/pages/selection/select_priority_page.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/datetime/datetime_picker_view.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/textfield/custom_text_field.dart';
import 'package:task_manager/app/ui/widgets/dialog/custom_bottom_dialog.dart';
import 'package:task_manager/app/ui/widgets/dialog/error_dialog.dart';
import 'package:task_manager/util/date_util.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  final PageStatus status;
  final EMode pageMode;

  const EditTaskPage({
    Key key,
    this.task,
    this.status,
    this.pageMode,
  }) : super(key: key);

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _taskTitleController = TextEditingController();
  final _textDescriptionController = TextEditingController();

  DateTime _selectedStartDate = DateTime.now().toLocal();
  DateTime _selectedEndDate;
  Task _newTask;

  Duration alert;
  Timer timer;

  String categoryTitle = AppStrings.category;
  String priorityTitle = AppStrings.priority;

  @override
  void dispose() {
    if (timer != null) timer.cancel();
    super.dispose();
  }

  void _setFields() {
    _newTask = widget.task;
    _textDescriptionController.text = widget.task.description;
    _taskTitleController.text = widget.task.title;
    _selectedStartDate = DateUtil.dateTimeFromString(widget.task.startTime);
    _selectedEndDate = widget.task.endTime == null
        ? null
        : DateUtil.dateTimeFromString(widget.task.endTime);
    categoryTitle += getCategoryTitle();
    priorityTitle += getPriorityTitle();
  }

  Task _getNewTask() {
    return new Task(
      title: "",
      endTime: "",
      startTime: "",
      completed: false,
      category: null,
    );
  }

  bool isAddingTask() => widget.task == null;

  String getCategoryTitle() {
    if (_newTask.category != null) {
      return ": " + _newTask.category.name;
    }
    return "";
  }

  String getPriorityTitle() {
    if (_newTask.priority != null) {
      return ": " + EPriorityUtil.fromEnumToString(_newTask.priority);
    }
    return "";
  }

  @override
  void initState() {
    if (isAddingTask()) {
      _newTask = _getNewTask();
    } else {
      _setFields();

      if (_newTask.endTime != null)
        _buildClock(DateUtil.dateTimeFromString(_newTask.endTime));
    }

    if (isAddingTask() && widget.pageMode != null) {
      if (widget.pageMode == EMode.TODAY) {
        _selectedStartDate = DateTime.now();
      } else if (widget.pageMode == EMode.TOMORROW) {
        _selectedStartDate = DateUtil.getTomorrowDay(DateTime.now());
      } else if (widget.pageMode == EMode.NEXT_WEEK)
        _selectedStartDate = DateUtil.getNextWeekFirstDate(DateTime.now());
      else if (widget.pageMode == EMode.PLANNED) {
        _selectedStartDate = DateUtil.getPlannedFromDate(DateTime.now());
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(AppStrings.editTaskTitle),
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
        heroTag: "button save",
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
        _buildStartDateTimePicker(),
        SizedBox(height: 30),
        _buildEndDateTimePicker(),
        SizedBox(height: 15),
        ListTile(
            leading: Icon(Icons.refresh,
                color: Theme.of(context).accentColor, size: 30),
            title: Text(AppStrings.resetPickerTitle),
            onTap: () {
              setState(() {
                _selectedEndDate = null;
              });
            }),
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

  Widget _buildColorContainer() {
    return Container(
        padding: EdgeInsets.fromLTRB(20.0, 40, 30, 40),
        color: Theme.of(context).accentColor,
        child: Column(
          children: [
            _buildTextField(
                AppStrings.enterTaskNameHint,
                Icon(Icons.title, color: Colors.teal.shade50),
                _taskTitleController),
            SizedBox(height: 16),
            _buildTextField(
                AppStrings.enterTaskNoteHint,
                Icon(Icons.event_note_sharp, color: Colors.teal.shade50),
                _textDescriptionController),
            SizedBox(height: 30),
            _selectedEndDate == null
                ? _buildTimeLeftText(AppStrings.selectDateTimePickerHint)
                : _buildTimeLeft(),
          ],
        ));
  }

  Widget _buildTextField(
      String text, Icon icon, TextEditingController textController) {
    return Container(
      padding: EdgeInsets.fromLTRB(40.0, 10, 0, 0),
      child: CustomTextField(
          icon: icon,
          labelText: text,
          controller: textController,
          textColor: Colors.white,
          labelColor: Colors.white70),
    );
  }

  Widget _buildStartDateTimePicker() {
    return CustomDateTimePicker(
      name: AppStrings.startDatePickerTitle,
      icon: Icons.hourglass_bottom,
      onPressed: () async {
        FocusScope.of(context).unfocus();
        DateTime datetime = await _pickDate(_selectedStartDate);
        setState(() {
          _selectedStartDate = datetime;
        });
      },
      date: new DateFormat.yMMMMd('en_US').format(_selectedStartDate),
      time: new DateFormat.jm().format(_selectedStartDate),
    );
  }

  Widget _buildEndDateTimePicker() {
    return CustomDateTimePicker(
      name: AppStrings.endDateTimePickerTitle,
      value: AppStrings.selectDateTimePickerHint,
      icon: Icons.hourglass_bottom,
      onPressed: () async {
        FocusScope.of(context).unfocus();
        DateTime datetime = _selectedEndDate == null
            ? await _pickDate(DateTime.now())
            : await _pickDate(_selectedEndDate);
        setState(() {
          if (timer != null) timer.cancel();
          _selectedEndDate = datetime;
          _buildClock(_selectedEndDate);
        });
      },
      date: _selectedEndDate == null
          ? null
          : new DateFormat.yMMMMd('en_US').format(_selectedEndDate),
      time: _selectedEndDate == null
          ? null
          : new DateFormat.jm().format(_selectedEndDate),
    );
  }

  Future<DateTime> _pickDate(DateTime dateTime) async {
    DateTime selectedDateTime = dateTime;
    DateTime datepick = await showDatePicker(
        context: context,
        initialDate: selectedDateTime,
        firstDate: selectedDateTime.add(Duration(days: -365)),
        lastDate: selectedDateTime.add(Duration(days: 365)));

    if (datepick == null) return dateTime;

    TimeOfDay timePick = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );

    if (datepick != null && timePick != null)
      setState(() {
        selectedDateTime = DateTime(datepick.year, datepick.month, datepick.day,
            timePick.hour, timePick.minute);
      });

    return selectedDateTime;
  }

  Widget _buildAddTaskInfo() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.addTaskInfoProperties,
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

  void _getAllCategories() async {
    bool shouldUpdate = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Container(
                width: 400.0,
                height: 450.0,
                child: CategoriesSelectionPage(task: _newTask),
              ));
        });
    setState(() {
      if (shouldUpdate == true || shouldUpdate == null) {
        if (!isNewTaskCategoryNull())
          categoryTitle = AppStrings.category + getCategoryTitle();
        else
          categoryTitle = AppStrings.category;
      }
    });
  }

  void _getAllPriority() async {
    bool shouldUpdate = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Container(
                  width: 100.0,
                  height: 300.0,
                  child: PrioritySelectionPage(task: _newTask)));
        });
    setState(() {
      if (shouldUpdate == true || shouldUpdate == null) {
        if (!_isNewTaskPriorityNull())
          priorityTitle = AppStrings.priority + getPriorityTitle();
        else
          priorityTitle = AppStrings.priority;
      }
    });
  }

  Future<void> onSave() async {
    final _bloc = BlocProvider.getBloc<TaskPageBlock>();
    try {
      if (widget.status != null) widget.status.requiredUpdate = true;
      FocusScope.of(context).unfocus();

      if (!_isValidData()) return;
      _setNewTaskFields();

      print("processing POST request for task");
      await _bloc.apiClient.addTask(_newTask);

      _bloc.dispose();
      Navigator.pop(context);
    } on ApiError catch (ex) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
                    message:
                        AppStrings.errorAlertText + ex.statusCode.toString())
                .build(context);
          });
      _bloc.dispose();
    }
  }

  void _setNewTaskFields() {
    _newTask.title = _taskTitleController.text;
    _newTask.description = _textDescriptionController.text;
    _newTask.startTime = DateUtil.formatDate(_selectedStartDate).toString();
    _newTask.endTime = _selectedEndDate == null
        ? null
        : DateUtil.formatDate(_selectedEndDate).toString();
    _newTask.completed = false;
  }

  bool _isValidData() {
    if (_taskTitleController.text.isEmpty) {
      showDialogMessage(
        AppStrings.hintToEnterTitle,
      );
      return false;
    } else if (_selectedEndDate != null &&
        _selectedStartDate.isAfter(_selectedEndDate)) {
      showDialogMessage(
        AppStrings.hintStartTimeBeforeDeadline,
      );
      return false;
    }
    return true;
  }

  void showDialogMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => CustomBottomDialog(
              message: message,
            ));
  }

  bool isNewTaskCategoryNull() {
    if (_newTask.category == null) return true;

    return false;
  }

  bool _isNewTaskPriorityNull() {
    if (_newTask.priority == null) return true;

    return false;
  }

  Widget _buildTimeLeftText(String text) {
    return Text(
      AppStrings.timeLeftTitle + text,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).backgroundColor,
      ),
    );
  }

  void _buildClock(DateTime endTime) {
    if (endTime == null) return;
    DateTime deadline = endTime;
    alert = deadline.difference(DateTime.now());

    if (alert.isNegative) {
      return;
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();

      setState(() {
        if (now.isBefore(deadline)) {
          alert = deadline.difference(now);
        } else {
          timer.cancel();
        }
      });
    });
  }

  Widget _buildTimeLeft() {
    if (alert == null || alert.isNegative)
      return _buildTimeLeftText("${0}d ${0}h ${0}m ${0}s");

    int minutes = alert.inMinutes;
    int minsInDay = 24 * 60;
    int days = (minutes / (minsInDay)).floor();
    int mins = minutes - minsInDay * days;
    int sec =
        (alert.inSeconds - 60 * (minsInDay * (minutes / (minsInDay)))).floor();

    int hours = 0;
    while (mins >= 60) {
      mins -= 60;
      hours++;
    }

    return _buildTimeLeftText("${days}d ${hours}h ${mins}m ${sec}s");
  }

  String formatDuration(Duration d) {
    d += Duration(microseconds: 999999);

    int minutes = d.inMinutes;
    int minsInDay = 24 * 60;
    int days = (minutes / (minsInDay)).floor();
    int mins = minutes - minsInDay * days;
    int secs = mins - 60;
    int hours = 0;

    while (mins > 60) {
      mins -= 60;
      hours++;
    }

    String f(int n) {
      return n.toString().padLeft(2, '0');
    }

    return "${f(hours)}:${f(minutes % 60)}:${f(secs)}";
  }
}
