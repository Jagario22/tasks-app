import 'package:flutter/material.dart';
import 'package:task_manager/app/api/model/category.dart';
import 'package:task_manager/app/resources/theme/colors/light_colors.dart';

class CategoryView extends StatelessWidget {
  final Category category;
  final Function onTap;
  final Function onLongPress;
  final bool isSelected;

  const CategoryView({
    Key key,
    @required this.category,
    this.onTap,
    this.onLongPress,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildICardView(context);
  }

  Widget _buildICardView(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: !isSelected ? Colors.purple.shade100 : Colors.purple.shade200,
      elevation: 8.0,
      child: _buildListTile(context),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onLongPress: onLongPress == null ? null : onLongPress,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.category_outlined, color: LightColors.kDarkBlue),
        ),
        title: Text(
          category.name,
          style: TextStyle(color: LightColors.kDarkBlue),
        ),
        onTap: onTap,
        trailing:
            Icon(Icons.keyboard_arrow_right, color:  LightColors.kDarkBlue, size: 30.0));
  }
}
