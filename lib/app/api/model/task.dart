import 'package:flutter/material.dart';
import 'package:task_manager/app/api/model/priority.dart';

import 'category.dart';

class Task {
  int id;
  String title;
  bool completed;
  String startTime;
  String endTime;
  Category category;
  EPriority priority;

  Task({
    this.id,
    this.title,
    this.completed,
    this.startTime,
    this.endTime,
    this.category,
    this.priority,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    completed = json['completed'];
    category = Category.fromJson(json["category"]);
    priority = EnumUtil.fromStringToEnum(json['priority']);

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['completed'] = this.completed;
    data['category'] = this.category;
    return data;
  }
}
