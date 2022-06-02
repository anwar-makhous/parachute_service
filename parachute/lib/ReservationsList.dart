import 'package:flutter/material.dart';
import 'package:parachute/GlobalState.dart';
import 'ReservationResult.dart';

class ReservationsList extends StatefulWidget {
  @override
  _ReservationsListState createState() => _ReservationsListState();
}

class _ReservationsListState extends State<ReservationsList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text('Reservations Log'),
            toolbarTextStyle: TextTheme(
                headline6: TextStyle(
              color: Colors.black,
              fontSize: 18,
            )).bodyText2,
            titleTextStyle: TextTheme(
                headline6: TextStyle(
              color: Colors.black,
              fontSize: 18,
            )).headline6,
          ),
          backgroundColor: Colors.white,
          body: mainBody(),
        ));
  }

  Widget mainBody() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: GlobalState.reservationsList.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              GlobalState.getShopByID(
                  GlobalState.reservationsList[index]['shop_id'])['name'],
            ),
            subtitle: Text(GlobalState.reservationsList[index]['date']
                .toString()
                .substring(0, 16)),
            trailing: GlobalState.reservationStatusIcon(
                GlobalState.reservationsList[index]['status'],
                size: 35),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationResult.fromLog(
                        GlobalState.reservationsList[index],
                        GlobalState.getShopByID(
                            GlobalState.reservationsList[index]['shop_id']),
                        GlobalState.reservationsList[index]["status"],
                        GlobalState.reservationsList[index]['id']),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
