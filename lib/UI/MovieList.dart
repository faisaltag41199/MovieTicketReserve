import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:movie_ticket_reserve/DataCloud/MovieData.dart';
import 'package:movie_ticket_reserve/DataCloud/TicketData.dart';
import 'package:movie_ticket_reserve/UI/MovieInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_ticket_reserve/UI/SignInScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_ticket_reserve/UI/MyTickets.dart';


class MovieList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  var movieRef = FirebaseDatabase.instance.reference().child("Movies");
  List<MovieData> AllMoviesList;
  var ticketRef = FirebaseDatabase.instance.reference().child("Tickets");
  String userID = FirebaseAuth.instance.currentUser.uid.toString();

  StreamSubscription<Event> onMovieAddedEvent;

  @override
  void initState() {
    super.initState();

    AllMoviesList = new List();
    onMovieAddedEvent = FirebaseDatabase.instance
        .reference()
        .child('Movies')
        .onChildAdded
        .listen(_onMovieAdded);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    onMovieAddedEvent.cancel();
    super.dispose();
  }

  selectedMenuItem(String selected){
    if(selected=='My Tickets'){
      List userTickets=[];
      ticketRef.once().then((DataSnapshot snapshot){
        Map allTickets =snapshot.value;
        if(allTickets!=null){
          allTickets.forEach((key, value) {
            if(value['userID']==userID){

              TicketData ticketData=new TicketData();
              ticketData.movieTitle=value['movieTitle'];
              ticketData.movieID=value['movieID'];
              ticketData.image=value['image'];
              ticketData.movieDate=value['movieDate'];
              ticketData.numOfTickts=value['numOfTickts'];
              ticketData.seatsNum=value['seatsNum'];
              ticketData.totalPrice=value['totalPrice'];
              userTickets.add(ticketData);

            }
          });
        }
      }).whenComplete((){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyTickets(userTickets)),
        );
      });

    }else if(selected=='Logout'){
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/signinscreen');
    }else{
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Avaliable Movies",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.arrow_drop_down_circle_outlined,color: Colors.white,),
            onSelected: selectedMenuItem,
            itemBuilder: (BuildContext context) {
              return ['My Tickets','Logout','Exit'].map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
          ),
        ],

      ),
      body: new Center(
        child: ListView.builder(
            itemCount: AllMoviesList.length,
            padding: EdgeInsets.only(top: 12.0),
            itemBuilder: (context, position) {
              if (AllMoviesList.isNotEmpty) {
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Image.network(AllMoviesList[position].image,
                            width: 200, height: 200),
                      ),
                      Container(
                        margin:EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Text(
                                AllMoviesList[position].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Padding(padding: EdgeInsets.only(top: 15.0)),
                              new Text(
                                AllMoviesList[position].movieTime,
                                style: TextStyle(color: Colors.grey),
                              ),
                              Padding(padding: EdgeInsets.only(top: 15.0)),
                              OutlineButton(
                                  child: new Text("More"),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MovieInfo(
                                              movieData:
                                              AllMoviesList[position])),
                                    );
                                  },
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                      new BorderRadius.circular(30.0)))
                            ],
                          ))
                    ],
                  ),
                );
              }else{
                return CircularProgressIndicator();
              }

            }),
      ),
    );
  }

  _onMovieAdded(Event event) {
    var movieobj = new MovieData();
    movieobj.title = event.snapshot.value['title'];
    movieobj.description = event.snapshot.value['description'];
    movieobj.movieTime = event.snapshot.value['movieTime'];
    movieobj.image = event.snapshot.value['image'];
    movieobj.numberOfSeats = event.snapshot.value['numberOfSeats'];
    movieobj.id = event.snapshot.key;

    this.setState(() {
      AllMoviesList.add(movieobj);
    });
  }

  bool _isUserSign() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }
}
