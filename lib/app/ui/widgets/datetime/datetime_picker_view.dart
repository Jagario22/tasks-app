import 'package:flutter/material.dart';

class CustomDateTimePicker extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String date;
  final String time;
  final String name;

  CustomDateTimePicker(
      {@required this.onPressed,
      @required this.icon,
      @required this.date,
      this.time, this.name});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Row(
          children: <Widget>[
            Icon(icon, color: Theme.of(context).accentColor, size: 30),
            SizedBox(
              width: 36,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 14)),
                Text(date + "  " + time,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.normal))
              ],
            )
          ],
        ),
      ),
    );
  }
}
