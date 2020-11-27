import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/api/model/priority.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/blocks/edit_page_block.dart';
import 'package:task_manager/app/blocks/state.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/view/states_view.dart';
import 'package:task_manager/app/ui/widgets/itemview/custom_list_tile.dart';

class PriorityPage extends StatefulWidget {
  final Task task;

  const PriorityPage({@required this.task});

  @override
  _PriorityPageState createState() => _PriorityPageState();
}

class _PriorityPageState extends State<PriorityPage> {
  bool _selectedNone;

  @override
  void initState() {
    _selectedNone = widget.task.priority == null ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_rounded)),
                SizedBox(width: 25),
                Text(AppStrings.priority,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            CustomListTle(
              onTap: () {
                setState(() {
                  widget.task.priority = null;
                  _selectedNone = true;
                });
              },
              title: Text("None"),
              selectedIcon: Icon(Icons.check),
              selectedColor: Theme.of(context).hoverColor,
              selected: _selectedNone,
              selectedTitle: Text(
                "None",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark),
              ),
            ),
            _buildPriorities(),
          ],
        ));
  }

  Widget _buildPriorities() {
    List<EPriority> priorities = EPriority.values;
    return Expanded(
        child: ListView.builder(
      itemCount: priorities.length,
      itemBuilder: (_, index) => _buildPriorityItem(
        priorities[index],
      ),
    ));
  }

  Widget _buildPriorityItem(EPriority priority) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: CustomListTle(
        onTap: () {
          setState(() {
            widget.task.priority = priority;
            _selectedNone = false;
          });
        },
        selectedTitle: Text(EnumUtil.fromEnumToString(priority),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark)),
        title: Text(EnumUtil.fromEnumToString(priority)),
        selected: widget.task.priority == null
            ? false
            : widget.task.priority == priority,
        selectedColor: Theme.of(context).hoverColor,
        selectedIcon: Icon(Icons.check),
      ),
    );
  }
}
