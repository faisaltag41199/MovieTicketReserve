import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_ticket_reserve/DataCloud/SeatData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:movie_ticket_reserve/DataCloud/TicketData.dart';
import 'package:movie_ticket_reserve/UI//BookScreen.dart';
import 'package:movie_ticket_reserve/UI/BookedSeatTicket.dart';

//ignore: must_be_immutable
class Seat extends StatefulWidget {
  Seat(
      {@required this.seatnum,
      this.movieTitle,
      this.seatDate,
      this.updatePriceCallback,
      this.movieID});

  String seatnum;
  String movieTitle;
  String seatDate;
  VoidCallback updatePriceCallback;
  String movieID;

  @override
  State<StatefulWidget> createState() {
    return new SeatState(
        seatnum: seatnum,
        movieTitle: movieTitle,
        seatDate: seatDate,
        updatePriceCallback: updatePriceCallback,
        movieID: movieID);
  }
}

class SeatState extends State<Seat> {
  SeatState(
      {@required this.seatnum,
      this.movieTitle,
      this.seatDate,
      this.updatePriceCallback,
      this.movieID});

  String seatnum, movieTitle, seatDate, movieID;
  VoidCallback updatePriceCallback;
  int seatStatus = 0;
  var seatColor = Colors.red;
  List<SeatData> seatList = SeatData.bookSeats;
  List<String> holdseatList = SeatData.holdSeats;
  String uid;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  var bookseatData = new SeatData();
  var holdSeatsRef = FirebaseDatabase.instance.reference().child("Holdseats");
  var bookSeatsRef = FirebaseDatabase.instance.reference().child("BookedSeats");
  var seatTicketRef = FirebaseDatabase.instance.reference().child("Tickets");
  bool isAvaliable = true, fromHold = false , showTicket=false;
  DataSnapshot holdedDataSnapshot, bookedDataSnapshot;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    uid = user.uid.toString();
    holdSeatsRef
        .child(movieTitle + seatDate + seatnum)
        .once()
        .then((DataSnapshot dataSnapshot) {
      holdedDataSnapshot = dataSnapshot;
      bookSeatsRef
          .child(movieTitle + seatDate + seatnum)
          .once()
          .then((DataSnapshot dataSnapshot) {
        bookedDataSnapshot = dataSnapshot;
        seatAvailableStatus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        width: 50,
        height: 50,
        child: RaisedButton(
          color: seatColor,
          onPressed: () {
            print(seatnum + movieTitle + seatDate);
            if (isAvaliable == true ) {
              seatChangeColor();
            } else if(showTicket==true) {

              TicketData ticketData;

              bookSeatsRef.child(movieTitle + seatDate + seatnum).once().then((DataSnapshot snapshot){
                 print(snapshot.value['ticketID']);

                   seatTicketRef.child(snapshot.value['ticketID']).once().then((DataSnapshot snapshot){

                   print(snapshot.value);

                   ticketData=new TicketData();
                   ticketData.movieTitle=snapshot.value['movieTitle'];
                   ticketData.movieID=snapshot.value['movieID'];
                   ticketData.image=snapshot.value['image'];
                   ticketData.movieDate=snapshot.value['movieDate'];
                   ticketData.numOfTickts=snapshot.value['numOfTickts'];
                   ticketData.seatsNum=snapshot.value['seatsNum'];
                   ticketData.totalPrice=snapshot.value['totalPrice'];

                 }).whenComplete((){

                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => BookedSeatTicket(ticketData)),
                     );
                   });


              });

            }else{
              return;
            }
          },
          child: Text(
            seatnum,
            style: TextStyle(color: Colors.white, fontSize: 8),
          ),
        ),
      ),
    );
  }

  seatAvailableStatus() {
    if (holdedDataSnapshot.value != null) {
      if (holdedDataSnapshot.value['userID'] == uid) {
        this.setState(() {
          isAvaliable = true;
          seatStatus = 1;
          seatColor = Colors.blue;
          fromHold = true;
        });
      } else {
        this.setState(() {
          isAvaliable = false;
          seatColor = Colors.grey;
        });
      }
    } else if (bookedDataSnapshot.value != null) {
      if (bookedDataSnapshot.value['userID'] == uid) {
        this.setState(() {
          isAvaliable = false;
          showTicket=true;
          seatColor = Colors.blue;
        });
      } else {
        this.setState(() {
          isAvaliable = false;
          seatColor = Colors.grey;
        });
      }
    }
  }

  seatChangeColor() {
    if (seatStatus == 0) {
      bookseatData.movieTitle = movieTitle;
      bookseatData.movieDate = seatDate;
      bookseatData.seatNum = seatnum;
      bookseatData.userID = uid;
      bookseatData.movieID = movieID;

      seatList.add(bookseatData);

      holdSeatsRef.child(movieTitle + seatDate + seatnum).set({
        'movieTitle': movieTitle,
        'movieDate': seatDate,
        'seatNum': seatnum,
        'userID': uid,
        'movieID': movieID
      });

      holdseatList.add(movieTitle + seatDate + seatnum);

      updatePriceCallback();

      this.setState(() {
        seatColor = Colors.blue;
        seatStatus = 1;
      });
    } else if (seatStatus == 1) {
      if (fromHold == true) {
        deleteFromHoldOnTap();
      } else {
        holdSeatsRef.child(movieTitle + seatDate + seatnum).remove();

        int index = seatList.indexOf(bookseatData);
        seatList.removeAt(index);

        int indexholdseat =
            holdseatList.indexOf(movieTitle + seatDate + seatnum);
        holdseatList.removeAt(indexholdseat);

        updatePriceCallback();

        this.setState(() {
          seatColor = Colors.red;
          seatStatus = 0;
        });
      }
    }
  }

  deleteFromHoldOnTap() {
    holdSeatsRef.child(movieTitle + seatDate + seatnum).remove();

    if (seatList.isNotEmpty) {
      seatList.removeAt(indexOfBookedSeats());

      int indexholdseat = holdseatList.indexOf(movieTitle + seatDate + seatnum);
      holdseatList.removeAt(indexholdseat);
    }

    updatePriceCallback();

    this.setState(() {
      seatColor = Colors.red;
      seatStatus = 0;
    });
  }

  int indexOfBookedSeats() {
    for (int index = 0; index < seatList.length; index++) {
      var condition = seatList[index].movieTitle == movieTitle &&
          seatList[index].movieDate == seatDate &&
          seatList[index].seatNum == seatnum &&
          seatList[index].userID == uid;

      if (condition == true) {
        return index;
      }
    }
  }
}
