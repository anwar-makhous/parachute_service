import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../map_page.dart';
import 'change_email.dart';
import '/screens/HomeScreen/home_page.dart';
import '/global_state.dart';

class AccountInfo extends StatefulWidget {
  static bool addressChanged = false;

  const AccountInfo({Key? key}) : super(key: key);

  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  TextEditingController firstNameController =
      TextEditingController(text: GlobalState.thisUser.firstName.toString());
  TextEditingController lastNameController =
      TextEditingController(text: GlobalState.thisUser.lastName.toString());
  TextEditingController phoneNumberController =
      TextEditingController(text: GlobalState.thisUser.phone.toString());
  TextEditingController emailEditingController =
      TextEditingController(text: GlobalState.thisUser.email.toString());
  TextEditingController addressEditingController =
      TextEditingController(text: GlobalState.thisUser.address.toString());
  final _formKey = GlobalKey<FormState>();
  bool inProgress = false;

  // updateUserInformation(
  //     String firstName, String lastName, String phone, String address) async {
  //   setState(() {
  //     inProgress = true;
  //   });
  //   final String apiURL = "${GlobalState.hostURL}/api/auth/user";
  //   final response = await http.post(
  //     apiURL,
  //     headers: {'Authorization': 'Bearer ${GlobalState.thisUser.token}'},
  //     body: {
  //       "first_name": firstName,
  //       "last_name": lastName,
  //       "phone": phone,
  //       "address": address,
  //       "lat": GlobalState.thisUser.lat.toString(),
  //       "long": GlobalState.thisUser.long.toString(),
  //       "_method": "put",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       inProgress = false;
  //       GlobalState.toastMessage('Done');
  //       Map userInfoResponse = json.decode(response.body);
  //       User _user = User.fromJson({
  //         "first_name": userInfoResponse['success']['data']['first_name'],
  //         "last_name": userInfoResponse['success']['data']['last_name'],
  //         "email": userInfoResponse['success']['data']['email'],
  //         "phone": userInfoResponse['success']['data']['phone'],
  //         "address": userInfoResponse['success']['data']['address'],
  //         "lat": double.parse(userInfoResponse['success']['data']['lat']),
  //         "long": double.parse(userInfoResponse['success']['data']['long']),
  //         "token": GlobalState.thisUser.token,
  //       });
  //       GlobalState.logIn(_user);
  //       AccountInfo.addressChanged = false;
  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (context) => HomePage()),
  //           (Route<dynamic> route) => false);
  //     });
  //   } else {
  //     GlobalState.toastMessage('Error');
  //   }
  // }

  // Future getImage(int type) async {
  //   PickedFile pickedImage = await ImagePicker().getImage(
  //       source: type == 1 ? ImageSource.camera : ImageSource.gallery,
  //       imageQuality: 50);
  //   return pickedImage;
  // }

  @override
  void initState() {
    super.initState();
    firstNameController.text = GlobalState.thisUser.firstName;
    lastNameController.text = GlobalState.thisUser.lastName;
    phoneNumberController.text = GlobalState.thisUser.phone;
    addressEditingController.text = GlobalState.thisUser.address;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              "Account Info",
            ),
            leading: IconButton(
              iconSize: 30,
              icon: const Icon(Icons.home, color: GlobalState.logoColor),
              tooltip: 'Back to home',
              onPressed: () {
                if (!informationChanged()) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (Route<dynamic> route) => false);
                } else {
                  GlobalState.alert(context,
                      title: 'Warning',
                      message:
                          'Seems like you changed some information but did not '
                          'save your changes, do you want to save changes ?',
                      confirmText: 'Yes, save changes',
                      cancelText: 'No, discard changes', onConfirm: () async {
                    Navigator.pop(context);
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // await updateUserInformation(
                      //     firstNameController.text.toString(),
                      //     lastNameController.text.toString(),
                      //     phoneNumberController.text.toString(),
                      //     addressEditingController.text.toString());
                    }
                  }, onCancel: () {
                    setState(() {
                      inProgress = true;
                    });
                    Navigator.pop(context);
                    // GlobalState.checkLogIn();
                    setState(() {
                      inProgress = false;
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                        (Route<dynamic> route) => false);
                  });
                }
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox(
                          height: 15,
                        ),
                        firstName(),
                        const SizedBox(
                          height: 15,
                        ),
                        lastName(),
                        const SizedBox(
                          height: 15,
                        ),
                        phoneInput(),
                        const SizedBox(
                          height: 15,
                        ),
                        addressInput(),
                        const SizedBox(
                          height: 15,
                        ),
                        emailInput(),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: (informationChanged())
                              ? () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // await updateUserInformation(
                                    //     firstNameController.text.toString(),
                                    //     lastNameController.text.toString(),
                                    //     phoneNumberController.text.toString(),
                                    //     addressEditingController.text
                                    //         .toString());
                                  }
                                }
                              : null,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(14.0)),
                              color: (informationChanged())
                                  ? GlobalState.logoColor
                                  : GlobalState.logoColor.withOpacity(0.5),
                            ),
                            child: const Text(
                              "Save",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              (inProgress == true)
                  ? GlobalState.progressIndicator(context)
                  : const Center()
            ],
          )),
    );
  }

  bool informationChanged() {
    if (firstNameController.text == GlobalState.thisUser.firstName &&
        lastNameController.text == GlobalState.thisUser.lastName &&
        phoneNumberController.text == GlobalState.thisUser.phone &&
        emailEditingController.text == GlobalState.thisUser.email &&
        !AccountInfo.addressChanged) {
      setState(() {});
      return false;
    } else {
      setState(() {});
      return true;
    }
  }

  Widget firstName() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "First Name ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: firstNameController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: GlobalState.secondColor,
              filled: true,
            ),
            textInputAction: TextInputAction.next,
            onChanged: (string) {
              setState(() {});
            },
            validator: (name) {
              String pattern = r'^[A-Za-z0-9ء-ي]+(?:[ _-][A-Za-z0-9ء-ي]+)*$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(name!)) {
                return 'Invalid first Name';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget lastName() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Last Name ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: lastNameController,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: GlobalState.secondColor,
              filled: true,
            ),
            textInputAction: TextInputAction.next,
            onChanged: (string) {
              setState(() {});
            },
            validator: (name) {
              String pattern = r'^[A-Za-z0-9ء-ي]+(?:[ _-][A-Za-z0-9ء-ي]+)*$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(name!)) {
                return 'Invalid Last Name';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget phoneInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Phone Number",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              border: InputBorder.none,
              fillColor: GlobalState.secondColor,
              filled: true,
            ),
            textInputAction: TextInputAction.done,
            onChanged: (string) {
              setState(() {});
            },
            validator: (name) {
              String pattern = r'^(?:[+0]9)?[0-9]{7,20}$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(name!)) {
                return 'Invalid Phone Number';
              } else {
                return null;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget emailInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChangeEmail()));
                      },
                      child: const Text(
                        "Change Email ?",
                        style: TextStyle(
                          fontSize: 15,
                          color: GlobalState.logoColor,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            FocusScope(
              node: FocusScopeNode(),
              child: TextFormField(
                onChanged: (string) {
                  setState(() {});
                },
                enabled: false,
                controller: emailEditingController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: GlobalState.secondColor,
                  filled: true,
                ),
              ),
            )
          ]),
    );
  }

  Widget addressInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Address",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PlaceLocation.setLocation(
                                false,
                                LatLng(GlobalState.lat!, GlobalState.long!))));
                      },
                      child: const Text(
                        "Change Address ?",
                        style: TextStyle(
                          fontSize: 15,
                          color: GlobalState.logoColor,
                        ),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            FocusScope(
              node: FocusScopeNode(),
              child: TextFormField(
                onChanged: (string) {
                  setState(() {});
                },
                enabled: false,
                controller: addressEditingController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: GlobalState.secondColor,
                  filled: true,
                ),
              ),
            )
          ]),
    );
  }

// photoWidget() {
//   return Column(
//     children: [
//       Text(
//         "here is the path of the image",
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 15,
//         ),
//       ),
//       SizedBox(height: 20,),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             height: 100,
//             width: 100,
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: imageFile == null
//                         ? AssetImage(
//                         'assets/logo/facebook.png')
//                         : FileImage(File(imageFile.path)),
//                     fit: BoxFit.cover)),
//           ),
//           RaisedButton(onPressed: () async {
//             final tmpFile = await getImage(2);
//             setState(() {
//               imageFile = tmpFile;
//               print("hey look here:");
//               file=File(imageFile.path);
//               print("here is the file");
//               print(file);
//             });
//           },
//             child:
//             Text("Choose Image",style:TextStyle(
//               fontWeight: FontWeight.bold,
//               color:Colors.white,
//               fontSize: 18,)),
//           )
//         ],
//       )
//     ],
//   );
// }
}
