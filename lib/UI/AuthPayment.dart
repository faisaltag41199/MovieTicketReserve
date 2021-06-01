import 'package:flutter/material.dart';
import 'package:movie_ticket_reserve/DataCloud/TicketData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:movie_ticket_reserve/DataCloud/SeatData.dart';

//ignore: must_be_immutable
class AuthPayment extends StatefulWidget {
  AuthPayment(this.ticketData);

  TicketData ticketData;

  @override
  State<StatefulWidget> createState() {
    return new AuthPaymentState(ticketData);
  }
}

class AuthPaymentState extends State<AuthPayment> {
  AuthPaymentState(this.ticketData);
  TicketData ticketData;
  var ticketRef = FirebaseDatabase.instance.reference().child("Tickets");
  var bookSeatsRef = FirebaseDatabase.instance.reference().child("BookedSeats");
  var holdSeatsRef = FirebaseDatabase.instance.reference().child("Holdseats");
  var notificationRef =
      FirebaseDatabase.instance.reference().child("notification");
  List<SeatData> seatList = SeatData.bookSeats; //booked seats;
  List<String> holdseatList = SeatData.holdSeats;
  int savebookflag, eraseAllListsDataflag;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _CancelBooking(),
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Center(child: Text("Authenticating Payment")),
          ),
          body: Container(
            child: Card(
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                      child: Image.network(
                    ticketData.image,
                    width: 150.0,
                    height: 150.0,
                  )),
                  Text(
                    '${ticketData.movieTitle}',
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    '${ticketData.movieDate}',
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    '${ticketData.numOfTickts} seats',
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    'seats:${ticketData.seatsNum}',
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                  Text(
                    '${ticketData.totalPrice} LE',
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 120.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              bookTicket();
                            },
                            child: Text(
                              'Confirm',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 30.0)),
                          ElevatedButton(
                            onPressed: () {
                              _CancelBooking();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ));
  }

  bookTicket() {
    showCircularProgress();
    ticketRef
        .child(ticketData.movieTitle +
            ticketData.movieDate +
            ticketData.seatsNum +
            ticketData.userID)
        .set({
      "movieTitle": ticketData.movieTitle,
      "movieDate": ticketData.movieDate,
      "numOfTickts": ticketData.numOfTickts,
      "seatsNum": ticketData.seatsNum,
      "image": ticketData.image,
      "totalPrice": ticketData.totalPrice,
      "userID": ticketData.userID,
      "movieID": ticketData.movieID
    }).whenComplete(() {
      notificationRef
          .child(ticketData.movieTitle +
              ticketData.movieDate +
              ticketData.seatsNum +
              ticketData.userID)
          .set({
        "movieTitle": ticketData.movieTitle,
        "movieDate": ticketData.movieDate,
        "numOfTickts": ticketData.numOfTickts,
        "seatsNum": ticketData.seatsNum,
        "image": ticketData.image,
        "totalPrice": ticketData.totalPrice,
        "userID": ticketData.userID,
        "movieID": ticketData.movieID
      }).whenComplete(() => savebookedSeats());
    });
  }

  savebookedSeats() {

    for (int i = 0; i < seatList.length; i++) {
      savebookflag = i;
      bookSeatsRef
          .child(seatList[i].movieTitle +
              seatList[i].movieDate +
              seatList[i].seatNum)
          .set({
        'movieTitle': seatList[i].movieTitle,
        'movieDate': seatList[i].movieDate,
        'seatNum': seatList[i].seatNum,
        'userID': seatList[i].userID,
        'movieID': seatList[i].movieID,
        'ticketID':ticketData.movieTitle+ticketData.movieDate+ticketData.seatsNum+ticketData.userID
      }).whenComplete(() => eraseAllListsData());
    }
  }

  eraseAllListsData() {
    if (savebookflag == (seatList.length - 1)) {
      for (int i = 0; i < holdseatList.length; i++) {
        eraseAllListsDataflag = i;
        holdSeatsRef.child(holdseatList[i]).remove().whenComplete(() {
          if (eraseAllListsDataflag == (holdseatList.length - 1)) {
            SeatData.bookSeats = [];
            SeatData.holdSeats = [];

            Navigator.pop(context);
            confirmMessage();
          } else {
            return;
          }
        });
      }
    } else {
      return;
    }
  }

  Future<void> confirmMessage() async {
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
                Text('the Ticket has been booked')
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/movielist');
              },
            ),
          ],
        );
      },
    );
  }

  cancel() {
    for (int i = 0; i < holdseatList.length; i++) {
      eraseAllListsDataflag = i;
      holdSeatsRef.child(holdseatList[i]).remove().whenComplete(() {
        if (eraseAllListsDataflag == (holdseatList.length - 1)) {
          SeatData.bookSeats = [];
          SeatData.holdSeats = [];
          Navigator.pushReplacementNamed(context, '/movielist');
        } else {
          return;
        }
      });
    }
  }

  Future<void> _CancelBooking() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure that you want to cancel booking')
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                cancel();
              },
            ),
            TextButton(
              child: Text('No'),
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
          title: Text('book ticket'),
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
