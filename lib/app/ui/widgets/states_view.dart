import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlocStates extends StatelessWidget {

  static Widget buildLoader() {
    return Center(child: CircularProgressIndicator());
  }

  static Widget buildError(String errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Text(
          errorMessage,
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}