import 'package:flutter/material.dart';
// import 'package:email_validator/email_validator.dart';
import '../../global_state.dart';
import 'social_login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

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
  bool inProgress = false;

  final _formKey = GlobalKey<FormState>();

  // Future<User> createUser(String firstName, String lastName, String email,
  //     String password, String checkPassword, String phone) async {
  //   setState(() {
  //     _inProgress = true;
  //   });
  //   final String apiURL = "${GlobalState.hostURL}/api/auth/create-account";
  //   final response = await http.post(apiURL, body: {
  //     "first_name": firstName,
  //     "last_name": lastName,
  //     "email": email,
  //     "password": password,
  //     "c_password": checkPassword,
  //     "phone": phone,
  //     "location_id": '1',
  //   });
  //   if (response.statusCode == 200) {
  //     final Map tokenResponse = json.decode(response.body);
  //     String token = tokenResponse['success']['token'];
  //     User _user = User.fromJson({
  //       "first_name": firstName,
  //       "last_name": lastName,
  //       "email": email,
  //       "phone": phone,
  //       "token": token,
  //       "lat": GlobalState.lat,
  //       "long": GlobalState.long,
  //       "address": GlobalState.address,
  //     });
  //     setState(() {
  //       GlobalState.logIn(_user);
  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (context) => HomePage()),
  //           (Route<dynamic> route) => false);
  //     });
  //     setState(() {
  //       _inProgress = false;
  //     });
  //     return _user;
  //   } else {
  //     GlobalState.toastMessage(json.decode(response.body).toString());
  //     setState(() {
  //       _inProgress = false;
  //     });
  //     return null;
  //   }
  // }

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
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text("Register"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          toolbarTextStyle: const TextTheme(
              headline6: TextStyle(
            color: Colors.black,
            fontSize: 18,
          )).bodyText2,
          titleTextStyle: const TextTheme(
              headline6: TextStyle(
            color: Colors.black,
            fontSize: 18,
          )).headline6,
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: SizedBox(
                height: height,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              height: 25,
                            ),
                            _emailPasswordWidget(),
                            const SizedBox(
                              height: 20,
                            ),
                            _submitButton(),
                            const SizedBox(height: 7),
                            _logInAccountLabel(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            (inProgress)
                ? GlobalState.progressIndicator(context)
                : const Center(),
          ],
        ),
      ),
    );
  }

  Widget firstNameInput(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: firstNameController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            onChanged: (_) {
              setState(() {});
            },
            decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                filled: true,
                hintText: "Enter Your First Name"),
            textInputAction: TextInputAction.next,
            validator: (name) {
              // Pattern pattern = r'^[A-Za-z0-9ء-ي]+(?:[ _-][A-Za-z0-9ء-ي]+)*$';
              // RegExp regex = RegExp(pattern);
              // if (!regex.hasMatch(name)) {
              //   return 'Invalid first name';
              // } else {
              //   return null;
              // }
            },
          ),
        ],
      ),
    );
  }

  Widget lastNameInput(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: lastNameController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            onChanged: (_) {
              setState(() {});
            },
            decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                filled: true,
                hintText: "Enter Your Last Name"),
            textInputAction: TextInputAction.next,
            validator: (name) {
              // Pattern pattern = r'^[A-Za-z0-9ء-ي]+(?:[ _-][A-Za-z0-9ء-ي]+)*$';
              // RegExp regex = RegExp(pattern);
              // if (!regex.hasMatch(name)) {
              //   return 'Invalid Last Name';
              // } else {
              //   return null;
              // }
            },
          ),
        ],
      ),
    );
  }

  Widget phoneInput(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: phoneNumberController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.phone,
            onChanged: (_) {
              setState(() {});
            },
            decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                filled: true,
                hintText: "Enter Your Phone Number"),
            textInputAction: TextInputAction.next,
            validator: (name) {
              // Pattern pattern = r'^(?:[+0]9)?[0-9]{7,20}$';
              // RegExp regex = RegExp(pattern);
              // if (!regex.hasMatch(name)) {
              //   return 'Invalid Phone Number';
              // } else {
              //   return null;
              // }
            },
          ),
        ],
      ),
    );
  }

  Widget emailInput(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) {
              setState(() {});
            },
            controller: emailController,
            decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: GlobalState.secondColor,
                hintText: "e.g abc@gmail.com",
                filled: true),
            textInputAction: TextInputAction.next,
            validator: (email) =>
                // EmailValidator.validate(email) ? null : "Invalid email address",
                null,
          ),
        ],
      ),
    );
  }

  Widget passwordInput(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
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
                        ? const Icon(
                            Icons.lock,
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.lock,
                            color: GlobalState.logoColor,
                          ))),
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              setState(() {});
            },
            validator: (password) {
              // Pattern pattern = r'^([a-zA-Z0-9*.!@$%^&():;<>,?~_+-=]{8,})$';
              // RegExp regex = RegExp(pattern);
              // if (!regex.hasMatch(password)) {
              //   GlobalState.alert(
              //     context,
              //     onConfirm: () {
              //       Navigator.pop(context);
              //     },
              //     onCancel: null,
              //     confirmOnly: true,
              //     confirmText: 'OK',
              //     title: 'Your password is weak',
              //     message: 'Please change your password\n'
              //         'Password must have at least 8 characters',
              //   );
              //   return 'invalid password';
              // } else {
              //   return null;
              // }
            },
          ),
        ],
      ),
    );
  }

  Widget checkPasswordInput(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
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
                        ? const Icon(
                            Icons.lock,
                            color: Colors.black,
                          )
                        : const Icon(
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
              if (_formKey.currentState!.validate()) {
                if (passwordController.text.toString() ==
                    checkPasswordController.text.toString()) {
                  // _formKey.currentState.save();
                  // await createUser(
                  //     firstNameController.text.toString(),
                  //     lastNameController.text.toString(),
                  //     emailController.text.toString(),
                  //     passwordController.text.toString(),
                  //     checkPasswordController.text.toString(),
                  //     phoneNumberController.text.toString());
                }
              }
            }
          : null,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14.0)),
          color: (firstNameController.text != '' &&
                  lastNameController.text != '' &&
                  phoneNumberController.text != '' &&
                  emailController.text != '' &&
                  passwordController.text != '' &&
                  checkPasswordController.text != '')
              ? GlobalState.logoColor
              : GlobalState.logoColor.withOpacity(0.5),
        ),
        child: const Text(
          'Create account',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _logInAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SocialLogin()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
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
