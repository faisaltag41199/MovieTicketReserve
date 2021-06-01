import 'package:flutter/material.dart';

class SignInData {
  String _email;
  String _password;

  static final SignInData SignInDataInstance = new SignInData();

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }
}
