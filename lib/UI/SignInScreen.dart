import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:movie_ticket_reserve/UI/SignUpScreen.dart';
import 'package:movie_ticket_reserve/UI/TextCard.dart';
import 'package:movie_ticket_reserve/DataCloud/SignInData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_ticket_reserve/UI/MovieList.dart';
import 'package:firebase_core/firebase_core.dart';

class SignInPage extends StatefulWidget {
  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  var SignInInstance = SignInData.SignInDataInstance;
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
        title: Center(child: Text("Sign in")),
      ),
      body: Center(
        child: ListView(shrinkWrap: true, children: [
          Row(
            children: [
              TextCard(
                  input: 'E_Mail Address',
                  fieldIcon: Icons.mail,
                  textFieldHolder: "signin"),
            ],
          ),
          Row(
            children: [
              TextCard(
                  input: 'Password',
                  fieldIcon: Icons.lock,
                  textFieldHolder: "signin"),
            ],
          ),
          new Container(
              padding: EdgeInsets.all(22.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.3),
                          side: BorderSide(color: Colors.red)),
                      onPressed: _preSignin,
                      child: Text(
                        'Sign in',
                        style: new TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                    ),
                  )
                ],
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account ?"),
              FlatButton(
                  onPressed: () {
                    navigateToSignUp();
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
          ),
        ]),
      ),
    );
  }

  _preSignin() {
    if (SignInInstance.email == null || SignInInstance.email.isEmpty == true) {
      print("here");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'email is empty please enter your email',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ));
    } else if (SignInInstance.password == null ||
        SignInInstance.password.isEmpty == true) {
      print('here');
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'password is empty please enter your password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ));
    } else {

      _Signin();
      showCircularProgress();
    }
  }

  _Signin() async {

    try {
      var user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: SignInInstance.email,
        password: SignInInstance.password,
      ))
          .user;

      print(user);
      if (user != null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/movielist', (Route<dynamic> route) => false);
      }
    } on PlatformException catch (e) {
      print("The user is not signed in yet. Asking to sign in.");
    } catch (e) {
      errorMessage(e.toString());
      print(e);
    }
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
          title: Text('Sign In'),
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

  navigateToSignUp() {
    try {
      Navigator.pushNamed(context, '/signupscreen');
    } catch (e) {
      errorMessage(e);
      print(e);
    }
  }
}
