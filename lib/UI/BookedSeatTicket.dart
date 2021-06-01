import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:movie_ticket_reserve/DataCloud/TicketData.dart';


class BookedSeatTicket extends StatefulWidget{

  BookedSeatTicket(this.ticketData);
  TicketData ticketData;
  @override
  State<StatefulWidget> createState() {
     return BookedSeatTicketState(ticketData);
  }


}
class BookedSeatTicketState extends State<BookedSeatTicket>{

  BookedSeatTicketState(this.ticketData);

  var seatTicketRef = FirebaseDatabase.instance.reference().child("Tickets");
  TicketData ticketData;
  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 50.0,bottom: 30.0),

          child: Card(
            color: Colors.white,
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                    child:Image.network(
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

              ],
            ),
          ),
        )
      ),
    );
  }


}

