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
import 'package:task_manager/util/sort_util.dart';

import 'edit_task_page.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPage createState() => _TasksPage();
}

class _TasksPage extends State<TasksPage> {
  final _bloc = BlocProvider.getBloc<TaskPageBlock>();
  final List<String> _sortOptions = ESortUtil.allToStringValue(ESort.values);
  List<Task> allTasks;
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
        IconButton(
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
          _selectedSortOption = ESortUtil.toEnum(sortOption);
          _bloc.getTasksCall();
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
      return _buildLoader();
    }

    //loaded tasks
    if (tasks is SuccessState) {
      return _buildTasks((tasks as SuccessState).data);
    }

    //error
    if (tasks is ErrorState) {
      return _buildError((tasks as ErrorState).errorMessage);
    }

    return _buildLoader();
  }

  Widget _buildLoader() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildTasks(List<Task> tasks) {
    if (_selectedSortOption != null) {
      tasks = ESortUtil.sortTasks(_selectedSortOption, tasks);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
          child: _buildCurrentDateTime(),
        ),
        _buildCurrentTasksStatistic(),
        Expanded(child: _buildTasksList(tasks)),

      ],
    );

  }

  Widget _buildCurrentDateTime() {
    String dateTime = DateFormat("EEEE, dd/MM").format(DateTime.now());
    return Text(dateTime, style: TextStyle(fontSize:16));
  }

  Widget _buildCurrentTasksStatistic() {
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
            endIndent: 0,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(70, 12, 0, 0),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column (
                  children: [
                    Text("0"),
                    Text("Gone"),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column (
                  children: [
                    Text("6"),
                    Text("On going"),
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column (
                  children: [
                    Text("0"),
                    Text("Waiting"),
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
      padding: EdgeInsets.fromLTRB(30, 15, 15, 15.0),
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
                      child: Text("Yes")),
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

  Widget _buildError(String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          errorMessage,
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
