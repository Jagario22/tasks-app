import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/api/model/priority.dart';
import 'package:task_manager/app/api/model/task.dart';
import 'package:task_manager/app/blocks/edit_page_block.dart';
import 'package:task_manager/app/blocks/state.dart';
import 'package:task_manager/app/resources/strings.dart';
import 'file:///D:/flutterProjects/task_manager/lib/app/ui/widgets/view/states_view.dart';

class PriorityPage extends StatefulWidget {
  final Task task;

  const PriorityPage({@required this.task});

  @override
  _PriorityPageState createState() => _PriorityPageState();
}

class _PriorityPageState extends State<PriorityPage> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back_rounded)),
            SizedBox(width: 11),
            Text(AppStrings.priority,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        _buildPriorities(),
      ],
    );
  }


  Widget _buildPriorities() {
    List<EPriority> priorities = EPriority.values;
    return Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: priorities.length,
          itemBuilder: (_, index) => _buildPriorityItem(
            priorities[index],
          ),
        ));
  }

  Widget _buildPriorityItem(EPriority priority) {
    return Container(
        padding: EdgeInsets.all(2.0),
        child: InkWell(
            onTap: () {
              setState(() {
                widget.task.priority = priority;
                Navigator.of(context).pop();
              });
            },
            child: Container(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(EnumUtil.fromEnumToString(priority)),
              ),
            )));
  }
}
