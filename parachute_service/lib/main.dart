import 'package:flutter/material.dart';
import './EditReservation.dart';
import './HomePage.dart';
import './EnterPage.dart';
import './GlobalState.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parachute_Service',
      debugShowCheckedModeBanner: false,
      color: GlobalState.logoColor,
      theme: ThemeData(accentColor: GlobalState.logoColor),
      home: HomePage(),
    );
  }
}
