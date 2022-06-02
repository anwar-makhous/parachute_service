// import 'package:flutter/material.dart';
// import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:parachute/GlobalState.dart';
// import 'package:parachute/HomePage.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../User.dart';

// class LoginToFaceBook extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _LoginToFaceBook();
//   }
// }

// class _LoginToFaceBook extends State<LoginToFaceBook> {
//   bool _isLoggedIn = false;
//   Map userProfile;
//   String bearerToken;
//   final facebookLogin = FacebookLogin();
//   String apiURL;
//   User _user;



//   @override
//   void initState() {
//     super.initState();
//     apiURL = "${GlobalState.hostURL}/api/auth/social_login";
//   }

//   static String firstName;
//   static String lastName;
//   static String accountID;
//   static String email;
//   static const String type_account = "facebook";

//   loginWithFB() async {
//     final result = await facebookLogin.logIn(['email']);
//     switch (result.status) {
//       case FacebookLoginStatus.loggedIn:
//         final token = result.accessToken.token;
//         final graphResponse = await http.get(
//             'https://graph.facebook.com/v2.12/me?fields=name,picture.height(200),email&access_token=$token');
//         final profile = json.decode(graphResponse.body);

//         setState(() {
//           userProfile = profile;
//           _isLoggedIn = true;
//           GlobalState.loggedIn = _isLoggedIn;
//         });
//         break;

//       case FacebookLoginStatus.cancelledByUser:
//         setState(() => _isLoggedIn = false);
//         break;
//       case FacebookLoginStatus.error:
//         setState(() => _isLoggedIn = false);
//         break;
//     }
//   }

//   _readInfo() async {
//     String names = userProfile['name'];
//     var name = names.split(" ");
//     firstName = name.first;
//     lastName = name.last;
//     email = userProfile['email'];
//     accountID = userProfile['id'];
//     final response = await http.post(apiURL, body: {
//       "first_name": firstName,
//       "last_name": lastName,
//       "email": email,
//       "type_account": type_account, //"facebook" or "google"
//       "account_id": accountID,
//     });
//     if (response.statusCode == 200) {
//       final Map tokenResponse = json.decode(response.body);
//       bearerToken = tokenResponse['token'];
//       final response2 = await http.get(
//         "${GlobalState.hostURL}/api/auth/user",
//         headers: {'Authorization': 'Bearer $bearerToken'},
//       );
//       final Map _userInfo = json.decode(response2.body);
//       _user = User.fromJson({
//         "first_name": _userInfo['success']['first_name'],
//         "last_name": _userInfo['success']['last_name'],
//         "email": _userInfo['success']['email'],
//         "password": null,
//         "phone": _userInfo['success']['phone'],
//         "token": bearerToken,
//         "lat":GlobalState.lat,
//         "long":GlobalState.long,
//         "address": GlobalState.address,
//       });
//       GlobalState.logIn(_user);
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => HomePage()),
//           (Route<dynamic> route) => false);
//     } else {
//       GlobalState.toastMessage(json.decode(response.body).toString());
//     }
//   }

//   // _logOut(){
//   //   facebookLogin.logOut();
//   //   setState(() {
//   //     _isLoggedIn = false;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: true,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Text(
//             "Log-In With Facebook",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//           backgroundColor: Color(0xff475993),
//         ),
//         body: Center(
//           child: SingleChildScrollView(
//             child: _isLoggedIn
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         height: 200.0,
//                         width: 200.0,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                             fit: BoxFit.fill,
//                             image: NetworkImage(
//                               userProfile['picture']['data']['url'],
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Text(
//                         userProfile['name'],
//                         style:
//                             TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Text(
//                         "You have signed up in Parachute using Facebook",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       SizedBox(
//                         height: 14,
//                       ),
//                       RaisedButton(
//                         child: Text(
//                           "Back To Parachute",
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         color: Color(0xff2872ba).withOpacity(0.48),
//                         onPressed: () {
//                           setState(() {
//                             _readInfo();
//                             Navigator.of(context).pushAndRemoveUntil(
//                                 MaterialPageRoute(
//                                     builder: (context) => HomePage()),
//                                 (Route<dynamic> route) => false);
//                           });
//                         },
//                       )
//                     ],
//                   )
//                 : Column(children: <Widget>[
//                     SizedBox(
//                       height: 40,
//                     ),
//                     Image.asset(
//                       "assets/logo/facebook.png",
//                       width: 150,
//                       height: 150,
//                     ),
//                     SizedBox(
//                       height: 100,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: Text(
//                           "When you Log-In with Facebook, Parachute application "
//                           "will get the following information:\n"
//                           "     1-name.\n"
//                           "     2-Picture.\n"
//                           "     3-Email.",
//                           style: TextStyle(
//                               fontSize: 15, fontWeight: FontWeight.bold)),
//                     ),
//                     SizedBox(
//                       height: 22,
//                     ),
//                     FacebookSignInButton(
//                       text: "Log-In With Facebook",
//                       onPressed: () {
//                         loginWithFB();
//                       },
//                     ),
//                   ]),
//           ),
//         ),
//       ),
//     );
//   }
// }
