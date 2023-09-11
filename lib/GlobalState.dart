import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'User.dart';

class GlobalState {
  static const Color logoColor = Color(0xffc30101);
  static const Color secondColor = Color(0xffcccccc);
  static const String hostURL = "http://parachute-group.com";
  static const List<Color> logoGradient = [
    Color(0xffcccccc),
    Color(0xffCA9A9A),
    Color(0xffC86767),
    Color(0xffC63434),
    Color(0xffc30101)
  ];
  static const List<IconData> satisfactionIcons = [
    FontAwesomeIcons.solidFrown,
    FontAwesomeIcons.solidMeh,
    FontAwesomeIcons.solidSmileBeam,
    FontAwesomeIcons.solidGrinAlt,
    FontAwesomeIcons.solidGrinHearts
  ];
  static bool loggedIn = false;
  static User thisUser = new User();
  static String address;
  static double lat;
  static double long;
  static List categoriesList;
  static List reservationsList = [
    {
      "table_id": 15,
      "table_no": 1,
      "details": "asdadfsg",
      "people_number": 2,
      "date": "2021-01-30 11:00",
      "atvlo": 1,
      "name": 'Ahmad Shahla',
      "phone": '0966905487',
      "status": "Pending"
    },
    {
      "table_id": 27,
      "table_no": 2,
      "details": "Special Occasion : Birthday",
      "people_number": 5,
      "date": "2021-02-20 18:30",
      "atvlo": 1,
      "name": 'Mohammed Arafat',
      "phone": '0992070250',
      "status": "Pending"
    },
    {
      "table_id": 30,
      "table_no": 3,
      "details": "Special Occasion : Anniversary",
      "people_number": 2,
      "date": "2021-01-30 22:00",
      "atvlo": 0,
      "name": 'Ali Shaaban',
      "phone": '0997163631',
      "status": "Pending"
    },
  ];

  static void saveLocation(
      String newAddress, double newLat, double newLong) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    address = newAddress;
    lat = newLat;
    long = newLong;
    prefs.setString('location', address);
    prefs.setDouble('lat', lat);
    prefs.setDouble('lng', long);
    if (loggedIn == true) {
      thisUser.address = newAddress;
      thisUser.lat = newLat;
      thisUser.long = newLong;
      logIn(thisUser);
    }
  }

  static Future<String> getLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    address = prefs.getString('location');
    lat = prefs.getDouble('lat');
    long = prefs.getDouble('lng');
    if (address == null) {
      address = 'nowhere';
    }
    return address;
  }

  static void logIn(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedIn = true;
    thisUser = user;
    address = thisUser.address;
    lat = thisUser.lat;
    long = thisUser.long;
    Map userMap = thisUser.toJson();
    prefs.setBool('loggedIn', loggedIn);
    prefs.setString('User', json.encode(userMap));
  }

  static void logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedIn = false;
    thisUser = new User();
    prefs.setBool('loggedIn', loggedIn);
    prefs.setString('User', '');
  }

  static void checkLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedIn = prefs.getBool('loggedIn');
    if (loggedIn == true) {
      String userString = prefs.getString('User');
      Map userMap = json.decode(userString);
      thisUser = User.fromJson(userMap);
      final String getUserInfoURL = "$hostURL/api/auth/user";
      final response = await http.get(
        getUserInfoURL,
        headers: {'Authorization': 'Bearer ${thisUser.token}'},
      );
      if (response.statusCode == 200) {
        final Map _userInfo = json.decode(response.body);
        logIn(User.fromJson({
          "first_name": _userInfo['success']['first_name'],
          "last_name": _userInfo['success']['last_name'],
          "email": _userInfo['success']['email'],
          "phone": _userInfo['success']['phone'],
          "token": thisUser.token,
          "lat": double.parse(_userInfo['success']['lat']),
          "long": double.parse(_userInfo['success']['long']),
          "address": _userInfo['success']['address'],
        }));
      }
    } else {
      loggedIn = false;
    }
  }

  static void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 5,
      fontSize: 16.0,
      backgroundColor: Colors.black,
    );
  }

  static Widget rateWithIcon(var rate,
      {Text text = const Text('Rate',
          style: TextStyle(
            fontSize: 16,
            color: secondColor,
          )),
      bool isRow = true}) {
    int index;
    (rate is double) ? index = rate.floor() : index = rate;
    if (rate == 5) index = 4;
    return (isRow)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text,
              SizedBox(
                width: 15,
              ),
              Icon(satisfactionIcons[index], color: logoGradient[index]),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(satisfactionIcons[index], color: logoGradient[index]),
              SizedBox(
                width: 15,
              ),
              text,
            ],
          );
  }

  static Widget rateWithColoredStars(var rate,
      {Text text = const Text('Rate',
          style: TextStyle(
            fontSize: 16,
            color: secondColor,
          )),
      bool isRow = true}) {
    int index;
    (rate is double) ? index = rate.floor() : index = rate;
    if (rate == 5) index = 4;
    return (isRow)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text,
              SizedBox(
                width: 15,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    for (int i = 0; i <= index; i++)
                      WidgetSpan(
                        child:
                            Icon(Icons.star, size: 18, color: logoGradient[i]),
                      ),
                  ],
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    for (int i = 0; i <= index; i++)
                      WidgetSpan(
                        child:
                            Icon(Icons.star, size: 18, color: logoGradient[i]),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              text
            ],
          );
  }

  static Widget rateWithBlackStars(var rate) {
    int index;
    (rate is double) ? index = rate.floor() : index = rate;
    if (rate == 5) index = 4;
    return RichText(
      text: TextSpan(
        children: [
          for (int i = 0; i <= index; i++)
            WidgetSpan(
              child: Icon(Icons.star, size: 18, color: Colors.black),
            ),
        ],
      ),
    );
  }

  static Widget progressIndicator(BuildContext context,{bool transparent = true}) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      width: MediaQuery.of(context).size.width,
      color: (transparent)?Colors.transparent:Colors.white,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: GlobalState.secondColor.withOpacity(0.5),
            borderRadius: BorderRadius.all(Radius.circular(14.0)),
          ),
          padding: EdgeInsets.all(25),
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            strokeWidth: 7,
          ),
        ),
      ),
    );
  }

  static Widget parachuteIcon({double size = 24, void Function() onPress}) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            color: logoColor,
            shape: BoxShape.circle,
            border: Border.all(color: logoColor)),
        width: size,
        height: size,
        child: Image.asset(
          'assets/logo/Parachute Logo on Red@2x c only Circular.png',
        ),
      ),
      onTap: onPress,
    );
  }

  static void alert(BuildContext context,
      {@required void Function() onConfirm,
      @required void Function() onCancel,
      String title = 'Title',
      String message = 'Message',
      bool confirmOnly = false,
      String confirmText = 'Yes',
      String cancelText = 'No'}) {
    Widget confirmButton = FlatButton(
        onPressed: onConfirm,
        child: Text(confirmText, style: TextStyle(color: logoColor)));

    Widget cancelButton = FlatButton(
        onPressed: onCancel,
        child: Text(cancelText, style: TextStyle(color: secondColor)));

    AlertDialog alert = AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: GlobalState.logoColor),
      ),
      content: Text(message, style: TextStyle(color: secondColor)),
      actions: [confirmButton, if (!confirmOnly) cancelButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  
  static Widget reservationStatusIcon(String status,{double size = 24.0}) {
    return Icon(
      (status.toLowerCase() == "pending")
          ? Icons.pending
          : (status.toLowerCase() == "accepted")
          ? Icons.done
          : Icons.cancel,
      color: (status.toLowerCase() == "pending")
          ? GlobalState.secondColor
          : (status.toLowerCase() == "accepted")
          ? Colors.green
          : GlobalState.logoColor,
      size: size,
    );
  }
}
