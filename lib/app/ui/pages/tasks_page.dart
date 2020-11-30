import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/app/api/api_error.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/blocks/state.dart';
import 'package:task_manager/app/blocks/task_block.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'package:task_manager/app/ui/widgets/dialog/error_dialog.dart';
import 'package:task_manager/app/ui/widgets/itemview/item_selection_view.dart';
import 'package:task_manager/app/ui/widgets/itemview/task_view.dart';
import 'package:task_manager/app/ui/widgets/view/states_view.dart';
import 'package:task_manager/util/sort_util.dart';
import 'package:task_manager/util/task_list_util.dart';

import 'edit_task_page.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPage createState() => _TasksPage();
}

class _TasksPage extends State<TasksPage> {
  final _bloc = BlocProvider.getBloc<TaskPageBlock>();
  final List<String> _sortOptions = ESortUtil.allToStringValue(ESort.values);
  List<Task> allTasks;
  int gone = 0;
  int onGoing = 0;
  int waiting = 0;
  int completed = 0;
  ESort _selectedSortOption;
  Duration alert;
  Timer timer;

  @override
  void initState() {
    _bloc.getTasksCall();
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _buildAppBar(),
      body: StreamBuilder<AppState<List<Task>>>(
        stream: _bloc.tasksStream,
        builder: _buildResponse,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "add task btn",
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) => EditTaskPage(),
              ),
            )
            .then((value) => _bloc.getTasksCall()),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(AppStrings.appName),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            onPressed: () {
              _bloc.getTasksCall();
            },
            icon: Icon(Icons.refresh)),
        Container (padding: EdgeInsets.fromLTRB(0, 0, 12, 0), child:  IconButton(
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
        ),),

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
    String sortName = sortOption.substring(0, 2) + " " + sortOption.substring(2);
    return ItemSelection(
        onTap: () {
          setState(() {
            _selectedSortOption = ESortUtil.toEnum(sortOption);
          });
          Navigator.of(context).pop();
        },
        title: "Sort " + sortName,
        selected: _selectedSortOption == null
            ? false
            : sortOptionValue.compareTo(sortOption) == 0);
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

    final tasks = snapshot.data;

    //initial state
    if (tasks is InitialState) {
      return Center(
        child: Text(AppStrings.initialTaskStateLabel),
      );
    }

    //loading tasks
    if (tasks is LoadingState) {
      return BlocStates.buildLoader();
    }

    //loaded tasks
    if (tasks is SuccessState) {
      return _buildTasks((tasks as SuccessState).data);
    }

    //error
    if (tasks is ErrorState) {
      return BlocStates.buildError((tasks as ErrorState).errorMessage);
    }

    return BlocStates.buildLoader();
  }

  Widget _buildTasks(List<Task> tasks) {
    if (_selectedSortOption != null) {
      tasks = TaskListUtil.sortTasks(_selectedSortOption, tasks);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
          child: _buildCurrentDateTime(),
        ),
        _buildCurrentTasksStatistic(tasks),
        Expanded(child: _buildTasksList(tasks)),
      ],
    );

  }

  void _countStatistic(List<Task> tasks) {
    List<int> statistic = TaskListUtil.countStatistic(tasks);
    waiting = statistic[0];
    onGoing = statistic[1];
    gone = statistic[2];
    completed = statistic[3];
  }

  Widget _buildCurrentDateTime() {
    String dateTime = DateFormat("EEEE, dd/MM").format(DateTime.now());
    return Text(dateTime, style: TextStyle(fontSize:16));
  }

  Widget _buildCurrentTasksStatistic(List<Task> tasks) {
    _countStatistic(tasks);
    return Container(
      padding: EdgeInsets.fromLTRB(12, 25, 12, 0),
      child: Column(
        children: [
          Text("The current state of affairs", style: TextStyle(fontSize: 17)),
          SizedBox(height: 12),
          const Divider(
            color: Colors.grey,
            height: 0,
            thickness: 1,
            indent: 30,
            endIndent: 30,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column (
                  children: [
                    Text(gone.toString()),
                    Text("Gone"),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column (
                  children: [
                    Text(onGoing.toString()),
                    Text("On going"),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column (
                  children: [
                    Text(waiting.toString()),
                    Text("Waiting"),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column (
                  children: [
                    Text(completed.toString()),
                    Text("Completed"),
                  ],
                ),
              ],
            ),
          )

        ],
      )
    );
  }

  Widget _buildTasksList(List<Task> tasks) {
    return  ListView.builder(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 12.0),
      itemCount: tasks.length,
      itemBuilder: (_, index) => TaskView(
        task: tasks[index],
        onLongPress: () {
          Task task = tasks[index];
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Delete"),
                content:
                Text("The task \"" + task.title + "\" will be deleted"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel")),
                  FlatButton(
                      onPressed: () {
                        _deleteTask(task.id);
                        Navigator.of(context).pop();
                      },
                      child: Text("Ok")),
                ],
              ));
        },
        onTap: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (_) => EditTaskPage(task: tasks[index]),
            ),
          )
              .then((value) => _bloc.getTasksCall());
        },
        onChanged: (bool completed) {
          setState(() {
            tasks[index].completed = completed;
            _updateTask(tasks[index]);
          });
        },
      ),
    );
  }

  Future<void> _deleteTask(int taskId) async {
    try {
      await BlocProvider.getBloc<TaskPageBlock>().apiClient.deleteTask(taskId);
      _bloc.getTasksCall();
    } on ApiError catch (ex) {
      showDialog(
          builder: (BuildContext context) {
            return ErrorDialog(
                    message: "Error. Status code: " + ex.statusCode.toString())
                .build(context);
          },
          context: context);
    }
  }

  Future<void> _updateTask(Task task) async {
    try {
      await BlocProvider.getBloc<TaskPageBlock>().apiClient.addTask(task);
    } on ApiError catch (ex) {
      showDialog(
          builder: (BuildContext context) {
            return ErrorDialog(
                    message: "Error. Status code: " + ex.statusCode.toString())
                .build(context);
          },
          context: context);
    }
  }


}
