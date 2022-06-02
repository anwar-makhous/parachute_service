import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'VideoPage.dart';
import 'IntroPage.dart';
import 'package:parachute/GlobalState.dart';
import 'package:flutter/services.dart';

String checkLocation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkLocation = await GlobalState.getLocation();
  // checkLocation = 'HAHAHAHAHA';
  GlobalState.checkLogIn();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Parachute',
      debugShowCheckedModeBanner: false,
      color: GlobalState.logoColor,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: GlobalState.logoColor)),
      home: (checkLocation == 'nowhere') ? VideoPage() : IntroPage(),
    );
  }
}
