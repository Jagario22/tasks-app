import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final Icon icon;
  final TextEditingController controller;
  final Color textColor;
  final Color labelColor;

  CustomTextField(
      {this.labelText,
      this.controller,
      this.icon,
      this.textColor,
      this.labelColor});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        icon: icon == null ? Icon(Icons.title) : icon,
        labelText: labelText,
        contentPadding:
            const EdgeInsets.only(left: 20.0, bottom: 8.0, top: 8.0),
        alignLabelWithHint: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade50),
          borderRadius: BorderRadius.circular(25.7),
        ),
        labelStyle: TextStyle(
            color: labelColor == null ? Colors.black : labelColor,
            fontSize: 14),
      ),
      autofocus: false,
      style: TextStyle(
          fontSize: 18.0,
          color: textColor == null ? Colors.black : textColor,
          fontWeight: FontWeight.normal),
    );
  }
}
