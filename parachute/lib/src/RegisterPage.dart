import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parachute/HomePage.dart';
import 'package:parachute/src/SocialLogin.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../GlobalState.dart';
import '../User.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController checkPasswordController = TextEditingController();
  bool securePassword = true;
  bool _inProgress = false;

  final _formKey = GlobalKey<FormState>();

  Future<User> createUser(String firstName, String lastName, String email,
      String password, String checkPassword, String phone) async {
    setState(() {
      _inProgress = true;
    });
    final String apiURL = "${GlobalState.hostURL}/api/auth/create-account";
    final response = await http.post(apiURL, body: {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "c_password": checkPassword,
      "phone": phone,
      "location_id": '1',
    });
    if (response.statusCode == 200) {
      final Map tokenResponse = json.decode(response.body);
      String token = tokenResponse['success']['token'];
      User _user = User.fromJson({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "token": token,
        "lat": GlobalState.lat,
        "long": GlobalState.long,
        "address": GlobalState.address,
      });
      setState(() {
        GlobalState.logIn(_user);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false);
      });
      setState(() {
        _inProgress = false;
      });
      return _user;
    } else {
      GlobalState.toastMessage(json.decode(response.body).toString());
      setState(() {
        _inProgress = false;
      });
      return null;
    }
  }

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
          title: Text("Register"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
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
        body: Stack(
          children: [
            Form(
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
                              height: 25,
                            ),
                            _emailPasswordWidget(),
                            SizedBox(
                              height: 20,
                            ),
                            _submitButton(),
                            SizedBox(height: 7),
                            _logInAccountLabel(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            (_inProgress) ? GlobalState.progressIndicator(context) : Center(),
          ],
        ),
      ),
    );
  }

  Widget firstNameInput(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: firstNameController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                filled: true,
                hintText: "Enter Your First Name"),
            textInputAction: TextInputAction.next,
            validator: (name) {
              Pattern pattern = r'^[A-Za-z0-9ء-ي]+(?:[ _-][A-Za-z0-9ء-ي]+)*$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(name))
                return 'Invalid first name';
              else
                return null;
            },
          ),
        ],
      ),
    );
  }

  Widget lastNameInput(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: lastNameController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                filled: true,
                hintText: "Enter Your Last Name"),
            textInputAction: TextInputAction.next,
            validator: (name) {
              Pattern pattern = r'^[A-Za-z0-9ء-ي]+(?:[ _-][A-Za-z0-9ء-ي]+)*$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(name))
                return 'Invalid Last Name';
              else
                return null;
            },
          ),
        ],
      ),
    );
  }

  Widget phoneInput(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: phoneNumberController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.phone,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                filled: true,
                hintText: "Enter Your Phone Number"),
            textInputAction: TextInputAction.next,
            validator: (name) {
              Pattern pattern = r'^(?:[+0]9)?[0-9]{7,20}$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(name))
                return 'Invalid Phone Number';
              else
                return null;
            },
          ),
        ],
      ),
    );
  }

  Widget emailInput(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) {
              setState(() {});
            },
            controller: emailController,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                hintText: "e.g abc@gmail.com",
                filled: true),
            textInputAction: TextInputAction.next,
            validator: (email) =>
                EmailValidator.validate(email) ? null : "Invalid email address",
          ),
        ],
      ),
    );
  }

  Widget passwordInput(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: securePassword,
            controller: passwordController,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                hintText: "Enter Your Password",
                filled: true,
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        securePassword = !securePassword;
                      });
                    },
                    child: securePassword
                        ? Icon(
                            Icons.lock,
                            color: Colors.black,
                          )
                        : Icon(
                            Icons.lock,
                            color: GlobalState.logoColor,
                          ))),
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              setState(() {});
            },
            validator: (password) {
              Pattern pattern = r'^([a-zA-Z0-9*.!@$%^&():;<>,?~_+-=]{8,})$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(password)) {
                GlobalState.alert(
                  context,
                  onConfirm: () {
                    Navigator.pop(context);
                  },
                  onCancel: null,
                  confirmOnly: true,
                  confirmText: 'OK',
                  title: 'Your password is weak',
                  message: 'Please change your password\n'
                      'Password must have at least 8 characters',
                );
                return 'invalid password';
              } else
                return null;
            },
          ),
        ],
      ),
    );
  }

  Widget checkPasswordInput(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: securePassword,
            controller: checkPasswordController,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                hintText: "Confirm Your Password",
                filled: true,
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        securePassword = !securePassword;
                      });
                    },
                    child: securePassword
                        ? Icon(
                            Icons.lock,
                            color: Colors.black,
                          )
                        : Icon(
                            Icons.lock,
                            color: GlobalState.logoColor,
                          ))),
            textInputAction: TextInputAction.done,
            onChanged: (_) {
              setState(() {});
            },
            validator: (password) {
              if (checkPasswordController.text.toString() ==
                  passwordController.text.toString()) {
                return null;
              } else {
                return 'Passwords doesn\'t match';
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: (firstNameController.text != '' &&
              lastNameController.text != '' &&
              phoneNumberController.text != '' &&
              emailController.text != '' &&
              passwordController.text != '' &&
              checkPasswordController.text != '')
          ? () async {
              if (_formKey.currentState.validate()) {
                if (passwordController.text.toString() ==
                    checkPasswordController.text.toString()) {
                  _formKey.currentState.save();
                  await createUser(
                      firstNameController.text.toString(),
                      lastNameController.text.toString(),
                      emailController.text.toString(),
                      passwordController.text.toString(),
                      checkPasswordController.text.toString(),
                      phoneNumberController.text.toString());
                }
              }
            }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
          color: (firstNameController.text != '' &&
                  lastNameController.text != '' &&
                  phoneNumberController.text != '' &&
                  emailController.text != '' &&
                  passwordController.text != '' &&
                  checkPasswordController.text != '')
              ? GlobalState.logoColor
              : GlobalState.logoColor.withOpacity(0.5),
        ),
        child: Text(
          'Create account',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _logInAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SocialLogin()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: GlobalState.logoColor.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        firstNameInput("First Name"),
        lastNameInput("Last Name"),
        phoneInput("Phone Number"),
        emailInput("Email"),
        passwordInput("Password"),
        checkPasswordInput("Check Password"),
      ],
    );
  }
}
