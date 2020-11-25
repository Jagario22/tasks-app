import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/blocks/state.dart';
import 'package:task_manager/app/blocks/task_block.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'package:task_manager/app/ui/pages/add_task_page.dart';
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
      appBar: AppBar(
        title: Text(AppStrings.appName),
        centerTitle: true,
      ),
      body: StreamBuilder<AppState<List<Task>>>(
        stream: _bloc.tasksStream,
        builder: _buildResponse,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EditTaskPage(),
          ),
        ),
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
          });
        },
      ),
    );
  }

  void _addTask() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: AddTaskPage(),
              ));
        });
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
