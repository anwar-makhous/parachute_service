import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_place_picker_mb/providers/place_provider.dart';
import 'package:google_maps_place_picker_mb/providers/search_provider.dart';
import '/screens/HomeScreen/home_page.dart';
// import 'package:http/http.dart' as http;
import '/screens/HomeScreen/Drawer/account_info.dart';
import 'dart:convert';
import 'package:google_maps_webservice/src/core.dart';
import '/global_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class PlaceLocation extends StatefulWidget {
  static LatLng initialPosition = const LatLng(30.0444, 31.2357);
  LatLng? customInitialPosition;
  final bool allowGPS;
  static bool isSettingLocation = true;
  static bool isChangingAccountInfo = false;

  PlaceLocation(this.allowGPS, {Key? key}) : super(key: key);

  PlaceLocation.showLocation(this.allowGPS, this.customInitialPosition) {
    initialPosition = customInitialPosition!;
    isSettingLocation = false;
  }

  PlaceLocation.setLocation(this.allowGPS, this.customInitialPosition) {
    initialPosition = customInitialPosition!;
    isSettingLocation = true;
    isChangingAccountInfo = true;
  }

  @override
  _PlaceLocationState createState() {
    if (customInitialPosition == null) {
      return _PlaceLocationState(allowGPS);
    }
    if (isSettingLocation == false) {
      return _PlaceLocationState.showLocation(allowGPS, customInitialPosition!);
    } else {
      return _PlaceLocationState.setLocation(allowGPS, customInitialPosition!);
    }
  }
}

class _PlaceLocationState extends State<PlaceLocation> {
  PickResult? selectedPlace;
  bool allowedLocation = false;
  bool allowGPS = false;
  Map responseMap = {};
  bool gettingData = false;
  LatLng? customInitialPosition;

  _PlaceLocationState(this.allowGPS);

  _PlaceLocationState.showLocation(this.allowGPS, this.customInitialPosition);

  _PlaceLocationState.setLocation(this.allowGPS, this.customInitialPosition);

  // getData() async {
  //   setState(() {
  //     gettingData = true;
  //   });
  //   String myURL = "${GlobalState.hostURL}/api/categories/";
  //   http.Response response = await http.get(myURL);
  //   if (response.statusCode == 200) {
  //     _responseMap = json.decode(response.body);
  //     GlobalState.categoriesList = _responseMap['success']['categories'];
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => HomePage()),
  //         (Route<dynamic> route) => false);
  //     setState(() {
  //       gettingData = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    gettingData = false;
  }

  @override
  Widget build(BuildContext context) {
    List<Component> _countries = [Component(Component.country, 'eg')];
    return SafeArea(
      top: true,
      child: Stack(
        children: [
          Scaffold(
              body: PlacePicker(
            apiKey: "AIzaSyBUILBxCa5yyQZawAAOpD6HII48R3haimM",
            initialPosition: PlaceLocation.initialPosition,
            autocompleteComponents: _countries,
            useCurrentLocation: allowGPS,
            selectInitialPosition: PlaceLocation.isSettingLocation,
            hintText: 'What are you looking for...?',
            automaticallyImplyAppBarLeading: true,
            selectedPlaceWidgetBuilder:
                (context, selectedPlace, state, isSearchBarFocused) {
              if (selectedPlace != null) {
                if (selectedPlace.formattedAddress!.contains('Egypt')) {
                  allowedLocation = true;
                } else {
                  allowedLocation = false;
                }
              }
              return isSearchBarFocused
                  ? Container()
                  // Use FloatingCard or just create your own Widget.
                  : FloatingCard(
                      bottomPosition: 15.0,
                      leftPosition: MediaQuery.of(context).size.width * 0.025,
                      rightPosition: MediaQuery.of(context).size.width * 0.025,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: BorderRadius.circular(14.0),
                      child: state == SearchingState.Searching
                          ? const Center(
                              child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ))
                          : Column(
                              children: [
                                if (PlaceLocation.isSettingLocation)
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 10,
                                          right: 10,
                                          bottom: 5),
                                      width: MediaQuery.of(context).size.width,
                                      height: 75,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: GlobalState.logoColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                              side: BorderSide(
                                                  color: (allowedLocation)
                                                      ? GlobalState.logoColor
                                                      : GlobalState
                                                          .secondColor)),
                                        ),
                                        child: Text(
                                          (allowedLocation)
                                              ? 'Deliver here'
                                              : 'Sorry, we don\'t deliver here',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: (allowedLocation)
                                            ? () {
                                                GlobalState.saveLocation(
                                                    selectedPlace!
                                                        .formattedAddress!,
                                                    selectedPlace
                                                        .geometry!.location.lat,
                                                    selectedPlace.geometry!
                                                        .location.lng);
                                                // if (GlobalState
                                                //         .categoriesList ==
                                                //     null)
                                                //   getData();
                                                if (PlaceLocation
                                                    .isChangingAccountInfo) {
                                                  PlaceLocation
                                                          .isChangingAccountInfo =
                                                      false;
                                                  AccountInfo.addressChanged =
                                                      true;
                                                  Navigator.pop(context);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AccountInfo()));
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              }
                                            : null,
                                      )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 12, right: 12),
                                  child: Text(
                                    selectedPlace!.formattedAddress.toString(),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                )
                              ],
                            ));
            },
          )),
          (gettingData) ? GlobalState.progressIndicator(context) : Container(),
        ],
      ),
    );
  }
}
