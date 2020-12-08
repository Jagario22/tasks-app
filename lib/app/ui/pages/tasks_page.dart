import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app/api/api_error.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/api/model/statistic.dart';
import 'package:task_manager/app/api/model/page_status.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/blocks/state.dart';
import 'package:task_manager/app/blocks/task_block.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'package:task_manager/app/ui/widgets/dialog/error_dialog.dart';
import 'package:task_manager/app/ui/widgets/itemview/item_selection_view.dart';
import 'package:task_manager/app/ui/widgets/itemview/task_view.dart';
import 'package:task_manager/app/ui/widgets/navdrawer.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/states_view.dart';
import 'package:task_manager/util/date_util.dart';
import 'package:task_manager/util/sort_util.dart';
import 'package:task_manager/util/task_list_util.dart';
import 'package:task_manager/util/task_page_mode.dart';

import 'edit_task_page.dart';

class TasksPage extends StatefulWidget {
  final EMode pageMode;
  final Category category;

  const TasksPage({Key key, this.pageMode, this.category}) : super(key: key);

  @override
  _TasksPage createState() => _TasksPage();
}

class _TasksPage extends State<TasksPage> {
  final _bloc = BlocProvider.getBloc<TaskPageBlock>();
  final List<String> _sortOptions = ESortUtil.allToStringValue(ESort.values);

  ESort _selectedSortOption;
  final Statistic _statistic = new Statistic();

  @override
  void initState() {
    _makeTasksCall();
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
      drawer: widget.category == null ? NavDrawer() : null,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _buildAppBar(),
      body: StreamBuilder<AppState<List<Task>>>(
        stream: _bloc.tasksStream,
        builder: _buildResponse,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "add task btn",
        child: Icon(Icons.add),
        onPressed: () async {
          PageStatus pageStatus = new PageStatus();
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => EditTaskPage(
                      status: pageStatus, pageMode: widget.pageMode),
                ),
              )
              .then((value) =>
                  {if (pageStatus.requiredUpdate == true) _makeTasksCall()});
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(getTitle(),
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontSize: 18)),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            onPressed: () {
              _makeTasksCall();
            },
            icon: Icon(Icons.refresh)),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 12, 0),
          child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 250,
                      child: _buildSortOptionList(),
                    );
                  });
            },
            icon: Icon(Icons.sort),
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptionList() {
    return ListView.builder(
      itemCount: _sortOptions.length,
      itemBuilder: (_, index) => _buildSortOptionItem(
        context,
        _sortOptions[index],
      ),
    );
  }

  Widget _buildSortOptionItem(BuildContext context, String sortOption) {
    String sortOptionValue = ESortUtil.toStringValue(_selectedSortOption);
    String sortName =
        sortOption.substring(0, 2) + " " + sortOption.substring(2);
    return ItemSelection(
        onTap: () {
          setState(() {
            _selectedSortOption = ESortUtil.toEnum(sortOption);
          });
          Navigator.of(context).pop();
        },
        title: AppStrings.sort + sortName,
        selected: _selectedSortOption == null
            ? false
            : sortOptionValue.compareTo(sortOption) == 0);
  }

  Widget _buildResponse(
    BuildContext context,
    AsyncSnapshot<AppState<List<Task>>> snapshot,
  ) {
    if (!snapshot.hasData) {
      return Center(
        child: Text(AppStrings.noData),
      );
    }

    final tasks = snapshot.data;

    if (tasks is LoadingState) {
      return BlocStates.buildLoader();
    }

    if (tasks is SuccessState) {
      return _buildTasks((tasks as SuccessState).data);
    }

    if (tasks is ErrorState) {
      return BlocStates.buildError((tasks as ErrorState).errorMessage);
    }

    return BlocStates.buildLoader();
  }

  Widget _buildTasks(List<Task> tasks) {
    if (_selectedSortOption != null) {
      tasks = TaskListUtil.sortTasks(_selectedSortOption, tasks);
    }

    tasks = TaskListUtil.sortTasks(ESort.byCompletedStatus, tasks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: _buildTasksStatisticContainer(tasks),
        ),
        Expanded(child: _buildTasksList(tasks)),
      ],
    );
  }

  void _countStatistic(List<Task> tasks) {
    List<int> statistic = TaskListUtil.countStatistic(tasks);
    _statistic.waiting = statistic[0];
    _statistic.onGoing = statistic[1];
    _statistic.gone = statistic[2];
    _statistic.completed = statistic[3];
  }

  Widget _buildTasksStatisticContainer(List<Task> tasks) {
    _countStatistic(tasks);

    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: [
          Text(AppStrings.statisticTitle,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade400)),
          SizedBox(height: 12),
          const Divider(
            color: Colors.brown,
            height: 5,
            thickness: 3,
            indent: 0,
            endIndent: 0,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: _buildStatisticRow(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            _buildStatisticItem(_statistic.gone.toString(), Colors.red),
            _getStatisticLabel(AppStrings.gone),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            _buildStatisticItem(_statistic.onGoing.toString(), Colors.amber),
            _getStatisticLabel(AppStrings.onGoing),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            _buildStatisticItem(
                _statistic.waiting.toString(), Colors.blueGrey.shade400),
            _getStatisticLabel(AppStrings.onWaiting),
          ],
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            _buildStatisticItem(
                _statistic.completed.toString(), Colors.green.shade800),
            _getStatisticLabel(AppStrings.completed),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticItem(String text, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(text,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Text _getStatisticLabel(String text) {
    return Text(text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.brown.shade400));
  }

  Widget _buildTasksList(List<Task> tasks) {
    return ListView.builder(
      itemCount: tasks.length,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      itemBuilder: (_, index) => _buildTasksListItem(index, tasks),
    );
  }

  Widget _buildTasksListItem(index, List<Task> tasks) {
    return TaskView(
      task: tasks[index],
      onLongPress: () {
        Task task = tasks[index];
        showDialog(
            context: context,
            builder: (context) => _buildDeleteAlert(task));
      },
      onTap: () {
        PageStatus pageStatus = new PageStatus();
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (_) =>
                EditTaskPage(task: tasks[index], status: pageStatus),
          ),
        )
            .then((value) {
          if (pageStatus.requiredUpdate == true) _makeTasksCall();
        });
      },
      onChanged: (bool completed) {
        setState(() {
          tasks[index].completed = completed;
          _updateTask(tasks[index]);
        });
      },
    );
  }

  AlertDialog _buildDeleteAlert(Task task) {
    return  AlertDialog(
      title: Text(AppStrings.deleteAlertTitle),
      content:
      Text("The task \"" + task.title + "\" will be deleted"),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppStrings.cancelAlert)),
        FlatButton(
            onPressed: () {
              _deleteTask(task.id);
              Navigator.of(context).pop();
            },
            child: Text(AppStrings.okAlert)),
      ],
    );
  }

  Future<void> _deleteTask(int taskId) async {
    try {
      await _bloc.apiClient.deleteTask(taskId);
      _makeTasksCall();
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

  Future<void> _updateTask(Task task) async {
    try {
      await _bloc.apiClient.addTask(task);
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

  void _makeTasksCall() {
    EMode pageMode = widget.pageMode;

    if (pageMode == EMode.TODAY) {
      _makeTodayCall();
    } else if (pageMode == EMode.NEXT_WEEK) {
      _makeNextWeekCall();
    } else if (pageMode == EMode.TOMORROW) {
      _makeTomorrowCall();
    } else if (pageMode == EMode.PLANNED) {
      _makePlannedCall();
    } else if (pageMode == EMode.GONE)
      _bloc.getGoneTasks(DateUtil.formatDate(DateTime.now()).toString());
    else if (pageMode == EMode.OF_CATEGORY && widget.category != null)
      _bloc.getAllTasksByCategoryId(widget.category.id);
    else
      _bloc.getTasksCall();
  }

  void _makePlannedCall() {
    DateTime now = DateTime.now();
    DateTime plannedStartDate = DateUtil.getPlannedFromDate(now);

    _bloc.getAllPlannedTasks(DateUtil.formatDate(plannedStartDate).toString());
  }

  void _makeNextWeekCall() {
    DateTime now = DateTime.now();
    DateTime startDate = DateUtil.getNextWeekFirstDate(now);
    DateTime endDate =
        DateUtil.getTomorrowDay(DateUtil.getNextWeekFirstDate(startDate));

    _bloc.getAllTasksDuringDays(DateUtil.formatDate(startDate).toString(),
        DateUtil.formatDate(endDate).toString());
  }

  void _makeTodayCall() {
    DateTime now = DateTime.now();
    String today =
        DateUtil.formatDate(DateUtil.getTodayDayFromDate(now)).toString();
    String tomorrow =
        DateUtil.formatDate(DateUtil.getTomorrowDay(now)).toString();
    _bloc.getAllTasksDuringDays(today, tomorrow);
  }

  void _makeTomorrowCall() {
    DateTime now = DateTime.now();
    DateTime tomorrow = DateUtil.getTomorrowDay(now);
    String dayAfterTomorrow =
        DateUtil.formatDate(DateUtil.getTomorrowDay(tomorrow)).toString();
    _bloc.getAllTasksDuringDays(
        DateUtil.formatDate(tomorrow).toString(), dayAfterTomorrow);
  }

  String getTitle() {
    EMode pageMode = widget.pageMode;

    if (pageMode == EMode.ALL_TASKS || pageMode == null) {
      return AppStrings.allTasksTitle;
    } else if (pageMode == EMode.TODAY) {
      return AppStrings.todayTasksTitle;
    } else if (pageMode == EMode.NEXT_WEEK) {
      return AppStrings.nextWeekTasksTitle;
    } else if (pageMode == EMode.TOMORROW) {
      return AppStrings.tomorrowTasksTitle;
    } else if (pageMode == EMode.PLANNED) {
      return AppStrings.plannedTasksTitle;
    } else if (pageMode == EMode.GONE)
      return AppStrings.goneTasksTitle;
    else if (pageMode == EMode.OF_CATEGORY) {
      return widget.category.name;
    }
    return null;
  }
}
