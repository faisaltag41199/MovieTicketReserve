import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_ticket_reserve/UI/TextCard.dart';
import 'package:movie_ticket_reserve/DataCloud/SignInData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_ticket_reserve/DataCloud/MovieData.dart';
import 'package:intl/intl.dart';
import 'package:movie_ticket_reserve/UI/Seat.dart';
import 'package:movie_ticket_reserve/UI/SeatsWidgets.dart';
import 'package:movie_ticket_reserve/DataCloud/SeatData.dart';
import 'package:movie_ticket_reserve/DataCloud/TicketData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:movie_ticket_reserve/UI/AuthPayment.dart';

//ignore: must_be_immutable
class BookScreen extends StatefulWidget {
  BookScreen(this.movieData);

  MovieData movieData;

  @override
  BookScreenState createState() => BookScreenState(movieData);
}

class BookScreenState extends State<BookScreen> {
  BookScreenState(this.movieData);

  MovieData movieData;
  List<DateTime> dateList;
  var movieshowtime, clickedTime = " ";
  int clickedtimeindex = 0, eraseAllListsDataflag;

  List<Widget> BoxesWidgetSwitcher;
  List<MaterialColor> boxColors;
  List<String> seatDateList;
  List<SeatData> seatDataList = SeatData.bookSeats;
  List<String> holdseatList = SeatData.holdSeats;
  String price = "0";
  TicketData dataOfTicket = new TicketData();
  String useriD = FirebaseAuth.instance.currentUser.uid.toString();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var holdSeatsRef = FirebaseDatabase.instance.reference().child("Holdseats");

  @override
  void initState() {
    setDateList();
    setSeatDate();
    intiateBoxesWidgetSwitcher();
    boxColors = [Colors.blue, Colors.red, Colors.red, Colors.red, Colors.red];
  }

// the ui screen code ********
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _CancelBooking(),
        child: Scaffold(
            key: _scaffoldKey,
            body: Container(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    height: 120,
                    width: double.maxFinite,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10.0),
                        itemCount: dateList.length,
                        itemBuilder: (context, position) {
                          return Column(
                            children: [
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: boxColors[position],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: InkWell(
                                      child: Column(
                                        children: [
                                          Text(
                                            DateFormat('EEEE')
                                                .format(dateList[position]),
                                            style: TextStyle(
                                              color: boxColors[position],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                              dateList[position]
                                                      .day
                                                      .toString() +
                                                  "-" +
                                                  dateList[position]
                                                      .month
                                                      .toString() +
                                                  "-" +
                                                  dateList[position]
                                                      .year
                                                      .toString(),
                                              style: TextStyle(
                                                color: boxColors[position],
                                              )),
                                          Text(movieshowtime,
                                              style: TextStyle(
                                                color: boxColors[position],
                                              ))
                                        ],
                                      ),
                                      onTap: () {
                                        this.setState(() {
                                          clickedtimeindex = position;
                                          print(clickedtimeindex);
                                          setTabDateColor(position);
                                        });
                                      },
                                    )),
                              )
                            ],
                          );
                        }),
                  ),
                  // the screen
                  Padding(padding: EdgeInsets.only(top: 30.0)),
                  Center(
                      child: Column(
                    children: [
                      Text(
                        "Vip Screen",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 120,
                        child: Card(
                            elevation: 7,
                            child: FittedBox(
                              child: Image.network(movieData.image),
                              fit: BoxFit.fill,
                            )),
                      ),
                    ],
                  )),
                  // the seats
                  BoxesWidgetSwitcher[clickedtimeindex],
                  // book now
                  Container(
                      child: Center(
                          child: ElevatedButton(

                        onPressed: () {
                          bookNow();
                        },
                        child: Text(
                          "Book Now $price LE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      )),
                      width: 75),
                ],
              ),
            )));
  }

  setDateList() {
    var DateTimeSplit = movieData.movieTime.split(" ");

    var DateSplit = DateTimeSplit[0].split("-");

    var TimeSplit = DateTimeSplit[1].split(":");

    var day = DateSplit[0];
    var month = getMonthAsNum(DateSplit[1].toString());
    print(month);
    var year = DateSplit[2];

    final items = List<DateTime>.generate(
        5,
        (i) => DateTime.utc(
              int.parse(year),
              month,
              int.parse(day),
            ).add(Duration(days: i)));

    this.setState(() {
      dateList = items;
      movieshowtime = DateTimeSplit[1];
    });
  }

  int getMonthAsNum(monthName) {
    Map map = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12
    };

    return map[monthName];
  }

  _SaveMovieTime(dateTime) {
    print(dateTime);
    return;
  }

  setSeatDate() {
    seatDateList = List<String>.generate(
        5,
        (i) =>
            dateList[i].day.toString() +
            "-" +
            dateList[i].month.toString() +
            "-" +
            dateList[i].year.toString() +
            " " +
            movieshowtime);
  }

  setTabDateColor(int position) {
    for (int i = 0; i < boxColors.length; i++) {
      if (i == position) {
        this.setState(() {
          boxColors[i] = Colors.blue;
        });
        continue;
      }

      this.setState(() {
        boxColors[i] = Colors.red;
      });
    }
  }

  bookNow() {
    if (SeatData.bookSeats.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'please choose a seat ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ));
    } else {
      if (seatDataList.length == 1) {
        dataOfTicket.movieTitle = movieData.title;
        dataOfTicket.image = movieData.image;
        dataOfTicket.userID = useriD;
        dataOfTicket.movieDate = seatDataList[0].movieDate;
        dataOfTicket.numOfTickts = seatDataList.length.toString();
        dataOfTicket.movieID = movieData.id;
        dataOfTicket.totalPrice = price;
        var seatsNums = "";
        for (int n = 0; n < seatDataList.length; n++) {
          seatsNums += seatDataList[n].seatNum + " ";
        }
        dataOfTicket.seatsNum = seatsNums;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AuthPayment(dataOfTicket)),
        );
      } else {
        var data1 = seatDataList[0].movieDate.split(' ')[0];
        var data2 = seatDataList[1].movieDate.split(' ')[0];

        if (data2 != data1) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'you allow only to book seats from the same day in one ticket',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
          ));
        } else {
          dataOfTicket.movieTitle = movieData.title;
          dataOfTicket.image = movieData.image;
          dataOfTicket.userID = useriD;
          dataOfTicket.movieDate = seatDataList[0].movieDate;
          dataOfTicket.numOfTickts = seatDataList.length.toString();
          dataOfTicket.totalPrice = price;
          dataOfTicket.movieID = movieData.id;

          var seatsNums = "";
          for (int n = 0; n < seatDataList.length; n++) {
            seatsNums += seatDataList[n].seatNum + " ";
          }
          dataOfTicket.seatsNum = seatsNums;

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthPayment(dataOfTicket)),
          );
        }
      }
    }
  }


  intiateBoxesWidgetSwitcher() {
    BoxesWidgetSwitcher = [
      new seatWidgetDateA(
          movieTitle: movieData.title,
          seatDate: seatDateList[0],
          updatePriceCallback: () {
            updatePrice();
          },
          movieID: movieData.id),
      new seatWidgetDateB(
          movieTitle: movieData.title,
          seatDate: seatDateList[1],
          updatePriceCallback: () {
            updatePrice();
          },
          movieID: movieData.id),
      new seatWidgetDateC(
          movieTitle: movieData.title,
          seatDate: seatDateList[2],
          updatePriceCallback: () {
            updatePrice();
          },
          movieID: movieData.id),
      new seatWidgetDateD(
          movieTitle: movieData.title,
          seatDate: seatDateList[3],
          updatePriceCallback: () {
            updatePrice();
          },
          movieID: movieData.id),
      new seatWidgetDateE(
          movieTitle: movieData.title,
          seatDate: seatDateList[4],
          updatePriceCallback: () {
            updatePrice();
          },
          movieID: movieData.id),
    ];
  }

  void updatePrice() {
    var newPrice = seatDataList.length * 80;
    this.setState(() {
      price = newPrice.toString();
    });
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
                Text('Are you sure that you want to cancel booking ?')
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

  cancel() {
    if (SeatData.bookSeats.isNotEmpty) {
      for (int i = 0; i < holdseatList.length; i++) {
        eraseAllListsDataflag = i;
        holdSeatsRef.child(holdseatList[i]).remove().whenComplete(() => () {
              if (eraseAllListsDataflag == (holdseatList.length - 1)) {
                SeatData.bookSeats = [];
                SeatData.holdSeats = [];

                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/movielist', (Route<dynamic> route) => false);
              } else {
                return;
              }
            });
      }
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/movielist', (Route<dynamic> route) => false);
    }
  }
}
