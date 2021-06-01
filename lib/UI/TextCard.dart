import 'package:flutter/material.dart';
import 'package:movie_ticket_reserve/DataCloud/SignInData.dart';
import 'package:movie_ticket_reserve/DataCloud/UserData.dart';
import 'package:movie_ticket_reserve/UI/SignInScreen.dart';

class TextCard extends StatefulWidget {
  TextCard({@required this.input, this.fieldIcon, this.textFieldHolder});
  final String input;
  final IconData fieldIcon;
  final String textFieldHolder;

  @override
  State<StatefulWidget> createState() {
    return new TextCardState(
        input: input, fieldIcon: fieldIcon, textFieldHolder: textFieldHolder);
  }
}

class TextCardState extends State<TextCard> {
  TextCardState({@required this.input, this.fieldIcon, this.textFieldHolder});
  final String input;
  final IconData fieldIcon;
  final String textFieldHolder;

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      decoration: InputDecoration(
        hintText: input,
        filled: true,
        fillColor: Colors.white,
        icon: Icon(
          fieldIcon,
          size: 25,
          color: Colors.red,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
      ),
      onChanged: _getInput,
    );

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2.0),
        padding: EdgeInsets.all(5.0),
        height: 75,
        child: field,
      ),
    );
  }

  _getInput(String textFieldInput) {
    switch (textFieldHolder) {
      case "signin":
        _setSignInData(textFieldInput);
        break;
      case "signup":
        _setSignUpData(textFieldInput);
        break;
    }
  }

  _setSignInData(String textFieldInput) {
    var instance = SignInData.SignInDataInstance;

    switch (input) {
      case "E_Mail Address":
        instance.email = textFieldInput;
        break;
      case "Password":
        instance.password = textFieldInput;
        break;
    }
  }

  _setSignUpData(String textFieldInput) {
    var instance = UserData.userDataInstance;

    switch (input) {
      case "First Name":
        instance.firstName = textFieldInput;
        break;
      case "Last Name":
        instance.lastName = textFieldInput;
        break;
      case "Username":
        instance.userName = textFieldInput;
        break;
      case "Phone Number":
        instance.phoneNumber = textFieldInput;
        break;
      case "E_Mail Address":
        instance.email = textFieldInput;
        break;
      case "Password":
        instance.password = textFieldInput;
        break;
    }
  }
}
