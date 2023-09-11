import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'GlobalState.dart';
import 'HomePage.dart';

// ignore: must_be_immutable
class ReservationInfo extends StatefulWidget {
  int _index;

  ReservationInfo(index) {
    _index = index;
  }

  @override
  _ReservationInfoState createState() => _ReservationInfoState(_index);
}

class _ReservationInfoState extends State<ReservationInfo> {
  Map _reservationInfo;
  int _index;

  _ReservationInfoState(index) {
    _index = index;
    _reservationInfo = GlobalState.reservationsList[index];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            title: Text(
              'Reservation Information',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: mainBody(),
              ),
              if (_reservationInfo['status'] == "Pending")
                Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.025,
                    width: MediaQuery.of(context).size.width,
                    child: actionButtons())
            ],
          ),
        ));
  }

  Widget actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FloatingActionButton(
          backgroundColor: Colors.green,
          tooltip: 'Accept this reservation request',
          child: Icon(
            Icons.done_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            GlobalState.reservationsList[_index]['status'] = "Accepted";
            print('Accepted, sending to server....');
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
          },
          heroTag: 'accept_reservation',
        ),
        FloatingActionButton(
          backgroundColor: GlobalState.logoColor,
          child: Icon(
            FontAwesomeIcons.times,
            color: Colors.white,
          ),
          tooltip: 'Decline this reservation request',
          onPressed: () {
            print('Declined, sending to server....');
            GlobalState.reservationsList[_index]['status'] = "Declined";
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
          },
          heroTag: 'decline_reservation',
        ),
      ],
    );
  }

  Widget mainBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.symmetric(horizontal: 3),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Name : \n${_reservationInfo['name']}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GlobalState.reservationStatusIcon(_reservationInfo['status'],
                      size: 35),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${_reservationInfo['status']}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Phone : \n${_reservationInfo['phone']}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Date : \n${DateFormat('EEEE d MMMM').format(DateTime.parse(_reservationInfo['date']))}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            '${DateFormat('jm').format(DateTime.parse(_reservationInfo['date']))}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Number of people : \n${_reservationInfo['people_number']}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Table# : \n${_reservationInfo['table_no']}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          (_reservationInfo['details'].toString() == '')
              ? SizedBox()
              : Text(
                  'Details : \n${_reservationInfo['details']}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
          (_reservationInfo['details'].toString() == '')
              ? SizedBox()
              : SizedBox(
                  height: 5,
                ),
          Text(
            'Live Location Access :\n'
            '${(_reservationInfo['atvlo'] == 1) ? 'Yes' : 'No'}',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          if (_reservationInfo['status'] == "Pending")
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
        ],
      ),
    );
  }
}
