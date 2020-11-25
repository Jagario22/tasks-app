import 'package:flutter/material.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/api/model/task.dart';

class CategoryView extends StatelessWidget {
  final Category category;
  final Task task;

  const CategoryView({
    Key key,
    @required this.category,
    this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2.0),
        child: InkWell(
            onTap: () {
              task.category = category;
            },
            child: Container(
              padding: EdgeInsets.all(15),
              child: Center(
                child: Text(category.name),
              ),
            )));
  }
}
