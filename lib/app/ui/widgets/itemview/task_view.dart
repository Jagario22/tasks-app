import 'package:flutter/material.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/ui/pages/edit_task_page.dart';

class TaskView extends StatelessWidget {
  final Task task;
  final Function onChanged;

  const TaskView({
    Key key,
    @required this.task,
    @required this.onChanged,
  }) : super(key: key);

  Color _getStatusColor(BuildContext context) {
    final theme = Theme.of(context);
    return task.completed ? theme.primaryColor : theme.primaryColorLight;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(2.0),
        child: Card(
          color: _getStatusColor(context),
          child: _buildTaskInfo(context),
    ));
  }

  Widget _buildTaskInfo(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EditTaskPage(task: task),
            ),
          );
        },
        hoverColor: Colors.black,
        child: Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: _buildColoredBox()));
  }

  Widget _buildColoredBox() {
    return ColoredBox(
        color: Colors.white,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTaskCheck(),
              _buildAddTaskInfo(),
            ]));
  }

  Widget _buildAddTaskInfo() {
    return Padding(
        padding: EdgeInsets.fromLTRB(6, 0, 0, 2),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddText("1d 12h 34m 15s to the End"),
              _buildAddText("Category"),
            ]));
  }

  Widget _buildAddText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2, 0, 0, 0),
      child: Text(text),
    );
  }

  Widget _buildTaskCheck() {
    return Row(
      children: <Widget>[
        Checkbox(
            value: task.completed,
            onChanged: (bool value) {
              if (!task.completed) onChanged(value);
            }),
        Text(task.title),
      ],
    );
  }
}
