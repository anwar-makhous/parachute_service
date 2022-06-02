// import 'package:flutter/material.dart';
// import 'package:google_maps_place_picker/google_maps_place_picker.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'HomePage.dart';
// import 'package:http/http.dart' as http;
// import 'AccountInfo.dart';
// import 'dart:convert';
// import 'package:google_maps_webservice/src/core.dart';
// import 'GlobalState.dart';

// // ignore: must_be_immutable
// class PlaceLocation extends StatefulWidget {
//   static LatLng initialPosition = LatLng(30.0444, 31.2357);
//   LatLng customInitialPosition;
//   final bool allowGPS;
//   static bool isSettingLocation = true;
//   static bool isChangingAccountInfo = false;

//   PlaceLocation(this.allowGPS);

//   PlaceLocation.showLocation(this.allowGPS, this.customInitialPosition) {
//     initialPosition = customInitialPosition;
//     isSettingLocation = false;
//   }

//   PlaceLocation.setLocation(this.allowGPS, this.customInitialPosition) {
//     initialPosition = customInitialPosition;
//     isSettingLocation = true;
//     isChangingAccountInfo = true;
//   }

//   @override
//   _PlaceLocationState createState() {
//     if (customInitialPosition == null)
//       return _PlaceLocationState(this.allowGPS);
//     if (isSettingLocation == false)
//       return _PlaceLocationState.showLocation(
//           this.allowGPS, this.customInitialPosition);
//     else
//       return _PlaceLocationState.setLocation(
//           this.allowGPS, this.customInitialPosition);
//   }
// }

// class _PlaceLocationState extends State<PlaceLocation> {
//   PickResult selectedPlace;
//   bool allowedLocation;
//   bool allowGPS;
//   Map _responseMap;
//   bool gettingData;
//   LatLng customInitialPosition;

//   _PlaceLocationState(this.allowGPS);

//   _PlaceLocationState.showLocation(this.allowGPS, this.customInitialPosition);

//   _PlaceLocationState.setLocation(this.allowGPS, this.customInitialPosition);

//   getData() async {
//     setState(() {
//       gettingData = true;
//     });
//     String myURL = "${GlobalState.hostURL}/api/categories/";
//     http.Response response = await http.get(myURL);
//     if (response.statusCode == 200) {
//       _responseMap = json.decode(response.body);
//       GlobalState.categoriesList = _responseMap['success']['categories'];
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) => HomePage()),
//           (Route<dynamic> route) => false);
//       setState(() {
//         gettingData = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     gettingData = false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Component> _countries = [new Component(Component.country, 'eg')];
//     return SafeArea(
//       top: true,
//       child: Stack(
//         children: [
//           Scaffold(
//               body: PlacePicker(
//             apiKey: "AIzaSyBUILBxCa5yyQZawAAOpD6HII48R3haimM",
//             initialPosition: PlaceLocation.initialPosition,
//             autocompleteComponents: _countries,
//             useCurrentLocation: allowGPS,
//             selectInitialPosition: PlaceLocation.isSettingLocation,
//             hintText: 'What are you looking for...?',
//             automaticallyImplyAppBarLeading: true,
//             selectedPlaceWidgetBuilder:
//                 (context, selectedPlace, state, isSearchBarFocused) {
//               if (selectedPlace != null) {
//                 if (selectedPlace.formattedAddress.contains('Egypt'))
//                   allowedLocation = true;
//                 else
//                   allowedLocation = false;
//               }
//               return isSearchBarFocused
//                   ? Container()
//                   // Use FloatingCard or just create your own Widget.
//                   : FloatingCard(
//                       bottomPosition: 15.0,
//                       leftPosition: MediaQuery.of(context).size.width * 0.025,
//                       rightPosition: MediaQuery.of(context).size.width * 0.025,
//                       width: MediaQuery.of(context).size.width,
//                       borderRadius: BorderRadius.circular(14.0),
//                       child: state == SearchingState.Searching
//                           ? Center(
//                               child: Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: CircularProgressIndicator(),
//                             ))
//                           : Column(
//                               children: [
//                                 if (PlaceLocation.isSettingLocation)
//                                   Container(
//                                       padding: EdgeInsets.only(
//                                           top: 10,
//                                           left: 10,
//                                           right: 10,
//                                           bottom: 5),
//                                       width: MediaQuery.of(context).size.width,
//                                       height: 75,
//                                       child: RaisedButton(
//                                         color: GlobalState.logoColor,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(14.0),
//                                             side: BorderSide(
//                                                 color: (allowedLocation)
//                                                     ? GlobalState.logoColor
//                                                     : GlobalState.secondColor)),
//                                         child: Text(
//                                           (allowedLocation)
//                                               ? 'Deliver here'
//                                               : 'Sorry, we don\'t deliver here',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 20),
//                                         ),
//                                         onPressed: (allowedLocation)
//                                             ? () {
//                                                 GlobalState.saveLocation(
//                                                     selectedPlace
//                                                         .formattedAddress,
//                                                     selectedPlace
//                                                         .geometry.location.lat,
//                                                     selectedPlace
//                                                         .geometry.location.lng);
//                                                 if (GlobalState
//                                                         .categoriesList ==
//                                                     null)
//                                                   getData();
//                                                 else if (PlaceLocation
//                                                     .isChangingAccountInfo) {
//                                                   PlaceLocation
//                                                           .isChangingAccountInfo =
//                                                       false;
//                                                   AccountInfo.addressChanged =
//                                                       true;
//                                                   Navigator.pop(context);
//                                                   Navigator.pushReplacement(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               AccountInfo()));
//                                                 } else
//                                                   Navigator.pop(context);
//                                               }
//                                             : null,
//                                       )),
//                                 Padding(
//                                   padding: EdgeInsets.only(
//                                       bottom: 10, left: 12, right: 12),
//                                   child: Text(
//                                     selectedPlace.formattedAddress,
//                                     style: TextStyle(
//                                         color: Colors.black, fontSize: 14),
//                                   ),
//                                 )
//                               ],
//                             ));
//             },
//           )),
//           (gettingData) ? GlobalState.progressIndicator(context) : Container(),
//         ],
//       ),
//     );
//   }
// }
