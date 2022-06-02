import 'package:flutter/material.dart';
import 'package:parachute/GlobalState.dart';
import 'package:parachute/src/LoginPage.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'LogInFacebook.dart';

class SocialLogin extends StatefulWidget {
  SocialLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SocialLoginState createState() => _SocialLoginState();
}

class _SocialLoginState extends State<SocialLogin> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      top: true,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Login",
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
          body: Form(
            key: _formKey,
            child: Container(
              height: height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(height: height * .07),
                          Image.asset("assets/logo/Parachute Logo On White.png",
                              width: 200, height: 200),
                          SizedBox(height: height * .07),
                          Text(
                            "Login or create an account",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Login or create an account to receive rewards "
                            "and\nsave your details for a faster "
                            "checkout experience.",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withAlpha(150),
                            ),
                          ),
                          SizedBox(height: height * .07),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: FacebookSignInButton(
                                borderRadius: 14.0,
                                onPressed: () {
                                  // Navigator.push(context,
                                  //     MaterialPageRoute(builder: (context) {
                                  //   return LoginToFaceBook();
                                  // }));
                                  // call authentication logic
                                }),
                          ),
                          _divider(),
//                    AppleSignInButton(
//                        onPressed: () {}, style: AppleButtonStyle.whiteOutline),
//                    _divider(),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withAlpha(20), width: 1),
                            ),
                            height: 50,
                            child: GoogleSignInButton(
                              borderRadius: 14.0,
                              text: "Continue with Google",
                              onPressed: () {
                                /* ... */
                              },
                              splashColor: Colors.white,
                              // setting splashColor to Colors.transparent will remove button ripple effect.
                            ),
                          ),
                          _divider(),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black.withAlpha(20),
                                    width: 1),
                              ),
                              height: 50,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0),
                                    side: BorderSide(
                                        color: GlobalState.logoColor)),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return LoginPage();
                                  }));
                                },
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.email,
                                      color: GlobalState.logoColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "Continue with Email",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Colors.black.withOpacity(0.54)),
                                    )
                                  ],
                                ),
                              )),
//                    SizedBox(height: height * .055),
//                    _createAccountLabel(),
                        ],
                      ),
                    ),
                  ),
//            Positioned(top: 40, left: 0, child: _backButton()),
                ],
              ),
            ),
          )),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
