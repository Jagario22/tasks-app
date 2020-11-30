import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/ui/pages/edit_task_page.dart';
import 'package:task_manager/app/ui/widgets/itemview/custom_list_tile.dart';
import 'package:task_manager/util/date_util.dart';

class TaskView extends StatelessWidget {
  final Task task;
  final Function onChanged;
  final Function onTap;
  final Function onLongPress;

  const TaskView({
    Key key,
    @required this.task,
    @required this.onChanged,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  Color _getStatusColor(BuildContext context) {
    final theme = Theme.of(context);
    return task.completed
        ? Theme.of(context).primaryColorDark
        : theme.primaryColorLight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2.0),
        child: Card(
          color: _getStatusColor(context),
          child: _buildTaskInfo(context),
        ));
  }

  Widget _buildTaskInfo(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
        child: _buildColoredBox(context));
  }

  Widget _buildColoredBox(BuildContext context) {
    return ColoredBox(
        color: Colors.white,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildListItem(context),
              Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
              )
            ]));
  }

  Widget _buildListItem(BuildContext context) {
    return CustomListTle(
      onTap: () {
        onTap();
      },
      onLongPress: () {
        onLongPress();
      },
      selectedTitle: Text(task.title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.lineThrough)),
      tileColor: Colors.white,
      title: Text(task.title),
      leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Theme.of(context).primaryColorDark,
          value: task.completed,
          onChanged: (bool value) {
            if (_validCheck(task)) onChanged(value);
          }),
      trailing: _buildTaskAddInfo(task),
      selected: task.completed,
    );
  }

  Widget _buildTaskAddInfo(Task task) {
    String formattedDate = task.endTime == null
        ? ""
        : new DateFormat("dd/MM")
            .format(DateUtil.dateTimeFromString(task.endTime));
    String categoryTitle = task.category == null ? "" : task.category.name;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(categoryTitle, style: TextStyle(color: Colors.grey.shade700)),
          Text(formattedDate, style: TextStyle(color: Colors.amber.shade700))
        ]);
  }

  bool _validCheck(Task task) {
    DateTime startTime = DateUtil.dateTimeFromString(task.startTime);
    DateTime now = DateTime.now();

    if (startTime.isBefore(now)) {
      if (task.endTime != null) {
        DateTime endTime = DateUtil.dateTimeFromString(task.endTime);
        if (endTime.isAfter(now)) return false;
      }
    }

    return true;
  }
}
