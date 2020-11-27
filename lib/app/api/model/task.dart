import 'package:task_manager/app/api/model/priority.dart';
import 'category.dart';

class Task {
  int id;
  String title;
  String description;
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
    this.description,
  });

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    completed = json['completed'];
    category = json[category] == null ? null : Category.fromJson(json["category"]);
    priority = json[priority] == null ? null : EnumUtil.fromStringToEnum(json['priority']);
    description = json['description'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['completed'] = this.completed;
    data['category'] = category == null ? null : this.category.toJson();
    data['priority'] = this.priority == null ? null : EnumUtil.fromEnumToString(this.priority);
    data['description'] = this.description;
    return data;
  }
}
