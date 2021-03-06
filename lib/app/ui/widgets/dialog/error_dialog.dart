import 'package:flutter/material.dart';
import 'package:task_manager/app/resources/strings.dart';

class ErrorDialog extends StatelessWidget {
  final String message;

  const ErrorDialog({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Error", style: TextStyle(fontSize: 16, color: Colors.red)),
        content: Text(message,
        style: TextStyle(fontSize: 14, color: Colors.red)),
        actions: [
          TextButton(
            child: Text(AppStrings.okAlert),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],

    );
  }

}