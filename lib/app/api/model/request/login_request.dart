import 'package:flutter/material.dart';

class LoginRequest {
  String username;
  String password;

  LoginRequest({
    @required this.username,
    @required this.password,
  });

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}