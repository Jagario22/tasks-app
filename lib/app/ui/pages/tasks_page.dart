import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app/api/api_error.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/blocks/state.dart';
import 'package:task_manager/app/blocks/task_block.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'package:task_manager/app/ui/widgets/dialog/error_dialog.dart';
import 'package:task_manager/app/ui/widgets/itemview/task_view.dart';

import 'edit_task_page.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPage createState() => _TasksPage();
}

class _TasksPage extends State<TasksPage> {
  final _bloc = BlocProvider.getBloc<TaskPageBlock>();

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
      appBar: AppBar(
        title: Text(AppStrings.appName),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _bloc.getTasksCall();
                },
                child: Icon(
                  Icons.refresh,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: StreamBuilder<AppState<List<Task>>>(
        stream: _bloc.tasksStream,
        builder: _buildResponse,
      ),
      floatingActionButton: FloatingActionButton(
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
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: tasks.length,
      itemBuilder: (_, index) => TaskView(
        task: tasks[index],
        onChanged: (bool completed) {
          setState(() {
            tasks[index].completed = completed;
            _updateTask(tasks[index]);
          });
        },
      ),
    );
  }

  Future<void> _updateTask(Task task) async {
    try {
      await BlocProvider.getBloc<TaskPageBlock>().apiClient.addTask(task);
      print("POST request for task");
    } on ApiError catch (ex) {
      showDialog(
          builder: (BuildContext context) {
            return ErrorDialog(
                    message: "Error. status code: " + ex.statusCode.toString())
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
