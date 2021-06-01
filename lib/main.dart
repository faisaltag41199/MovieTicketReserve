import 'package:flutter/material.dart';
import 'package:movie_ticket_reserve/UI/BookedSeatTicket.dart';
import 'package:movie_ticket_reserve/UI/MyTickets.dart';
import 'package:movie_ticket_reserve/UI/SignInScreen.dart';
import 'package:movie_ticket_reserve/UI/SignUpScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_ticket_reserve/UI/MovieList.dart';
import 'package:movie_ticket_reserve/UI/UserAccess.dart';
import 'package:movie_ticket_reserve/UI/AuthPayment.dart';
import 'package:movie_ticket_reserve/DataCloud/TicketData.dart';


void main() {


  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp().whenComplete((){

    runApp(new MaterialApp(

        home: UserAccess(),
        routes:{
          '/useraccess':(context) =>  UserAccess(),
          '/movielist':(context) => MovieList(),
          '/signinscreen':(context) => SignInPage(),
          '/signupscreen': (context) => SignUpPage(),

        }
    ));

  });

 /* TicketData dataOfTicket = new TicketData();
  dataOfTicket.movieTitle = 'avenngers';
  dataOfTicket.image = 'https://cdn2.lamag.com/wp-content/uploads/sites/6/2019/04/avengers-endgame-disney.jpg';
  dataOfTicket.userID = '444444441544';
  dataOfTicket.movieDate = '12-12-2020';
  dataOfTicket.numOfTickts = '3';
  dataOfTicket.totalPrice='80*3';
  dataOfTicket.seatsNum = "30,20,40";*/

}

