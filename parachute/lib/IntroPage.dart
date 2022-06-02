import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:parachute/HomePage.dart';
import 'GlobalState.dart';
import 'package:http/http.dart' as http;

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Timer _timer1;
  Timer _timer2;
  Timer _timer3;
  Timer _timer4;
  double logoBottomPosition1;
  double logoLeftPosition2;
  double logoBottomPosition3;
  bool animationDone = false;
  Map _responseMap;

  getData() async {
    String myURL = "${GlobalState.hostURL}/api/categories/";
    http.Response response = await http.get(myURL);
    if (response.statusCode == 200) {
      _responseMap = json.decode(response.body);
      GlobalState.categoriesList = _responseMap['success']['categories'];
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    logoBottomPosition1 = 1000;
    logoLeftPosition2 = -1000;
    logoBottomPosition3 = -1000;
    _timer1 = Timer(const Duration(seconds: 2), () {
      setState(() {
        logoBottomPosition1 = MediaQuery.of(context).size.height * 0.2;
      });
    });
    _timer2 = Timer(const Duration(seconds: 4), () {
      setState(() {
        logoLeftPosition2 = 0;
      });
    });
    _timer3 = Timer(const Duration(seconds: 7), () {
      setState(() {
        logoBottomPosition3 = MediaQuery.of(context).size.height * 0.2;
      });
    });
    _timer4 = Timer(const Duration(seconds: 9), () {
      setState(() {
        animationDone = true;
        getData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Container(
            color: GlobalState.logoColor,
            child: Stack(children: <Widget>[
              AnimatedPositioned(
                left: 0,
                right: 0,
                bottom: logoBottomPosition1,
                top: 0,
                curve: Curves.slowMiddle,
                duration: Duration(seconds: 4),
                child: Center(
                  child: Image(
                    image:
                        AssetImage("assets/logo/Parachute Logo on Red@2x1.png"),
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              AnimatedPositioned(
                left: logoLeftPosition2,
                right: 0,
                bottom: MediaQuery.of(context).size.height * 0.2,
                top: 0,
                curve: Curves.elasticIn,
                duration: Duration(seconds: 2),
                child: Center(
                  child: Image(
                    image:
                        AssetImage("assets/logo/Parachute Logo on Red@2x2.png"),
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              AnimatedPositioned(
                left: 0,
                right: 0,
                bottom: logoBottomPosition3,
                top: 0,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: Duration(seconds: 2),
                child: Center(
                  child: Image(
                    image:
                        AssetImage("assets/logo/Parachute Logo on Red@2x3.png"),
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                  bottom: 100,
                  left: 100,
                  right: 100,
                  child: Center(
                      child: (animationDone)
                          ? CircularProgressIndicator(
                              strokeWidth: 7,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  GlobalState.secondColor),
                            )
                          : Container()))
            ])),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer1.cancel();
    _timer2.cancel();
    _timer3.cancel();
    _timer4.cancel();
  }
}
