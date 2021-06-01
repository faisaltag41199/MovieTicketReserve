import 'package:flutter/material.dart';
import 'package:movie_ticket_reserve/DataCloud/SeatData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_ticket_reserve/UI/MovieList.dart';
import 'package:movie_ticket_reserve/UI/SignInScreen.dart';

class UserAccess extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new UserAccessState();
  }
}

class UserAccessState extends State<UserAccess> {
  User currentUser;

  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {

    if (currentUser != null) {
      return MovieList();
    } else {
      return SignInPage();
    }
  }
}
