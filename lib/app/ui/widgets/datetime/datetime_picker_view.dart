import 'package:flutter/material.dart';
import 'package:task_manager/app/resources/strings.dart';

class CustomDateTimePicker extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String date;
  final String time;
  final String name;
  final String value;

  CustomDateTimePicker(
      {@required this.onPressed,
      @required this.icon,
      @required this.date,
      this.time,
      this.name, this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      onTap: () {
        onPressed();
      },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontSize: 14)),
          date == null
              ? Text(value,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.normal))
              : Text(date + "  " + time,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.normal))
        ],
      ),
    );
  }

  Widget _buildDateTimeItem(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.only(left: 12.0),
        child: Row(children: <Widget>[
          Icon(icon, color: Theme.of(context).accentColor, size: 30),
          SizedBox(
            width: 36,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontSize: 14)),
              date == null
                  ? Text(AppStrings.selectDateTimePickerHint,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.normal))
                  : Text(date + "  " + time,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.normal))
            ],
          ),
        ]),
      ),
    );
  }
}
