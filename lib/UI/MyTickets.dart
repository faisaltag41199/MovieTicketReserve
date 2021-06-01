import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_ticket_reserve/DataCloud/TicketData.dart';

class MyTickets extends StatefulWidget {
  MyTickets(this.userTickets);
  List userTickets;
  @override
  State<StatefulWidget> createState() {
    return MyTicketsState(userTickets);
  }

}

class MyTicketsState extends State<MyTickets>{
  MyTicketsState(this.userTickets);
  List userTickets;

  @override
  void initState() {


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (
        margin: EdgeInsets.only(left:85.0,top: 60),
        width: 500,
        height: 600,
        child:Center(child: ListView.builder(

            scrollDirection: Axis.horizontal,
            itemCount: userTickets.length,itemBuilder: (context,i){
          return Center(

              child:Container(child: Card(
                color: Colors.white,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                        child: Image.network(
                          userTickets[i].image,
                          width: 150.0,
                          height: 150.0,
                        )),
                    Text(
                      '${userTickets[i].movieTitle}',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                    Text(
                      '${userTickets[i].movieDate}',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                    Text(
                      '${userTickets[i].numOfTickts} seats',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                    Text(
                      'seats:${userTickets[i].seatsNum}',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),
                    Text(
                      '${userTickets[i].totalPrice} LE',
                      style: TextStyle(
                        fontSize: 30.0,
                      ),
                    ),

                  ],
                ),
              ) ,));
        }),) ,),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/movielist');
          },
          label: const Text('All Movies'),
          icon: const Icon(Icons.movie),
          backgroundColor: Colors.red,
        )

    );
  }



}