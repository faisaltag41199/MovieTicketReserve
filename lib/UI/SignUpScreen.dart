import 'package:flutter/material.dart';
import 'package:movie_ticket_reserve/UI/TextCard.dart';
import 'package:movie_ticket_reserve/DataCloud/SignInData.dart';
import 'package:movie_ticket_reserve/DataCloud/UserData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  var userInstance = UserData.userDataInstance;
  //user reference in firebase database
  var userRef = FirebaseDatabase.instance.reference().child("Users");
  var userId;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(child: Text("Sign Up")),
      ),
      body: Center(
        child: ListView(shrinkWrap: true, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextCard(
                  input: 'First Name',
                  fieldIcon: Icons.person,
                  textFieldHolder: "signup"),
              TextCard(
                  input: 'Last Name',
                  fieldIcon: Icons.person,
                  textFieldHolder: "signup"),
            ],
          ),
          Row(
            children: [
              TextCard(
                  input: 'Username',
                  fieldIcon: Icons.person,
                  textFieldHolder: "signup"),
            ],
          ),
          Row(
            children: [
              TextCard(
                  input: 'Phone Number',
                  fieldIcon: Icons.phone,
                  textFieldHolder: "signup"),
            ],
          ),
          Row(
            children: [
              TextCard(
                  input: 'E_Mail Address',
                  fieldIcon: Icons.mail,
                  textFieldHolder: "signup"),
            ],
          ),
          Row(
            children: [
              TextCard(
                  input: 'Password',
                  fieldIcon: Icons.lock,
                  textFieldHolder: "signup"),
            ],
          ),
          Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 30.0)),
              SizedBox(
                width: 150,
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.3),
                      side: BorderSide(color: Colors.red)),
                  onPressed: _Signup,
                  child: Text(
                    'Sign Up',
                    style: new TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                ),
              )
            ],
          )
        ]),
      ),
    );
  }

  _Signup() async {
    try {
      if (userInstance.firstName == null ||
          userInstance.firstName.isEmpty == true) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'firstName is empty please enter your firstName',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ));
      } else if (userInstance.lastName == null ||
          userInstance.lastName.isEmpty == true) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'lastName is empty please enter your lastName',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ));
      } else if (userInstance.userName == null ||
          userInstance.userName.isEmpty == true) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'userName is empty please enter your userName',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ));
      } else if (userInstance.phoneNumber == null ||
          userInstance.phoneNumber.isEmpty == true) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'phoneNumber is empty please enter your phoneNumber',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ));
      } else if (userInstance.email == null ||
          userInstance.email.isEmpty == true) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'email is empty please enter your email',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ));
      } else if (userInstance.password == null ||
          userInstance.password.isEmpty == true) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'password is empty please enter your password',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ));
      } else {
        showCircularProgress();
        var user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userInstance.email,
          password: userInstance.password,
        )).user;

        if (user != null) {
          userId = user.uid.toString();
          _SaveUserInfo();
        }
      }
    } catch (e) {
 Navigator.pop(context);
 errorMessage(e.toString());
    }
  }

  _SaveUserInfo() {
    userRef.child(userId).set({
      'firstname': userInstance.firstName,
      'lastname': userInstance.lastName,
      'username': userInstance.userName,
      'phonenumber': userInstance.phoneNumber,
      'email': userInstance.email
    }).whenComplete(() {
      Navigator.pop(context);
      doneMessage();

    } );
  }

  Future<void> doneMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(width: 100,height: 100,child: Image.asset(
                  'assets/true-mark.png',
                  height: 150,
                  width: 150,
                ),)
                ,
                Text('your account has been created successfully')
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signinscreen');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> errorMessage(String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showCircularProgress() async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Up'),
          content: Row(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}
