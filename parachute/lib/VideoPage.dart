import 'dart:async';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'GlobalState.dart';
import 'PlaceLocation.dart';

class VideoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoPage();
  }
}

class _VideoPage extends State<VideoPage> {
  Timer _timer;
  double logoBottomPosition;
  double videoBottomPosition;
  double bottomSheetBottomPosition;
  double bottomSheetTopPosition;

  @override
  void initState() {
    super.initState();
    logoBottomPosition = -1000;
    videoBottomPosition = -1200;
    bottomSheetBottomPosition = -1500;
    bottomSheetTopPosition = 1500;
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        logoBottomPosition = MediaQuery.of(context).size.height * 0.7;
        videoBottomPosition = MediaQuery.of(context).size.height * 0.1;
        bottomSheetTopPosition = MediaQuery.of(context).size.height * 0.57;
        bottomSheetBottomPosition = 0;
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
                bottom: logoBottomPosition,
                top: 0,
                curve: Curves.elasticIn,
                duration: Duration(seconds: 6),
                child: Center(
                  child: Image(
                    image: AssetImage("assets/logo/Parachute Logo on Red.png"),
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              AnimatedPositioned(
                left: 0,
                right: 0,
                bottom: videoBottomPosition,
                top: 0,
                curve: Curves.slowMiddle,
                duration: Duration(seconds: 4),
                child: Center(
                  child: Image(
                    image: AssetImage("assets/video/ParachuteGif.gif"),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              AnimatedPositioned(
                  right: 0,
                  left: 0,
                  bottom: bottomSheetBottomPosition,
                  top: bottomSheetTopPosition,
                  curve: Curves.bounceInOut,
                  duration: Duration(seconds: 6),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14.0),
                          topRight: Radius.circular(14.0)),
                      border:
                          Border.all(color: GlobalState.secondColor, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Allow Parachute To Access Your GPS ?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                              "Your location helps us to provide you with"
                              " better experience",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: GlobalState.secondColor,
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 5, left: 5),
                          child: RaisedButton(
                            color: GlobalState.logoColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                side: BorderSide(color: GlobalState.logoColor)),
                            child: Text(
                              "Yes, Share My Location",
                              maxLines: 1,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            onPressed: () {
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return PlaceLocation(true);
                              // }));
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 5, left: 5),
                          child: RaisedButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                side:
                                    BorderSide(color: GlobalState.secondColor)),
                            child: Text(
                              "No, Choose Location Manually",
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black.withOpacity(0.54)),
                            ),
                            onPressed: () {
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return PlaceLocation(false);
                              // }));
                            },
                          ),
                        ),
                      ],
                    ),
                  ))
            ])),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
