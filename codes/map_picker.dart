import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' hide Location;
import 'package:location/location.dart';
import 'package:yallaharek_mobile/core/constant.dart';
import 'package:yallaharek_mobile/core/localized_keys.dart';
import 'package:yallaharek_mobile/core/res.dart';
import 'package:yallaharek_mobile/core/theme/app_colors.dart';
import 'package:yallaharek_mobile/core/widgets/buttons/custom_elevated_button.dart';
import 'package:yallaharek_mobile/core/widgets/scroll/scroll_configuration.dart';
import 'package:yallaharek_mobile/core/widgets/spaces/custom_space.dart';
import 'package:yallaharek_mobile/core/widgets/textFields/text_from_field.dart';
import 'package:yallaharek_mobile/core/widgets/texts/localized_text.dart';
import 'package:yallaharek_mobile/pages/profile_page/controller/profile_edit_controller.dart';

class MapPicker extends StatefulWidget {
  const MapPicker({Key? key}) : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final ProfileEditController profileEditController =
      Get.find(tag: "Edit_Profile_Page_Controller");

  final String googleMapApiKey = "AIzaSyA-YdfpnEwbwjCblVr_JhPcl_C02MILuE4";
  LatLng? initialLocation;
  GoogleMapController? mapController;
  Set<Marker> tappedMarkers = <Marker>{};
  BitmapDescriptor? markerBitmap;
  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? searchDelay;
  TextEditingController searchEditingController = TextEditingController();
  Location location = Location();
  final LatLng dubaiLatLng = const LatLng(25.0699068, 54.9423627);

  @override
  void initState() {
    super.initState();
    profileEditController.loadStateData();
    initialLocation = LatLng(
      profileEditController.accountAddressResModel.value?.latitude ??
          dubaiLatLng.latitude,
      profileEditController.accountAddressResModel.value?.longitude ??
          dubaiLatLng.longitude,
    );
    googlePlace = GooglePlace(googleMapApiKey);
  }

  @override
  void dispose() {
    super.dispose();
    searchDelay?.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setMarkerBitmap();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialLocation!,
          zoom: 14,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        markers: tappedMarkers,
        onTap: moveMarkerToLocation,
        zoomControlsEnabled: false,
      ),
      Positioned(
        top: 29.h,
        left: 26.w,
        right: 26.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 43.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: AppColors.white,
              ),
              child: CustomTextFormField(
                textEditingController: searchEditingController,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.black,
                ),
                onChange: (value) async {
                  await searchForLocationAsync(value);
                },
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                textAlign: TextAlign.center,
                hintLocalizedKey:
                    LocalizedKeys.ProfileEdit_MapSearchPlaceHolder,
              ),
            ),
            xxxSmallSpaceW(),
            Visibility(
              visible: predictions.isNotEmpty,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  color: AppColors.white,
                ),
                child: NoGlowScroller(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: predictions.length,
                    itemBuilder: (context, index) => ListTile(
                      tileColor: AppColors.white,
                      leading: const Icon(
                        Icons.location_pin,
                        color: AppColors.mainAppColor,
                      ),
                      title: Text(predictions[index].description!),
                      onTap: () async {
                        await goToSearchResultAsync(index);
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      Positioned(
        bottom: 25.h,
        left: 13.w,
        right: 13.w,
        child: Visibility(
          visible: predictions.isEmpty,
          child: Container(
            height: 109.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              color: AppColors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: LocalizedText(
                    LocalizedKeys.ProfileEdit_MapInstructionMessage,
                    size: 16.sp,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      width: 88.w,
                      height: 40.h,
                      borderRadius: 12.r,
                      elevation: 0,
                      color: Colors.transparent,
                      child: LocalizedText(
                        LocalizedKeys.ProfileEdit_MapCancelBtn,
                        size: FontSizes.mid,
                        textColor: AppColors.fontDark,
                      ),
                    ),
                    CustomElevatedButton(
                      color: AppColors.buttonColor,
                      onPressed: () async {
                        await onConfirmMapAsync();
                      },
                      width: 88.w,
                      height: 40.h,
                      borderRadius: 12.r,
                      elevation: 0,
                      child: LocalizedText(
                        LocalizedKeys.ProfileEdit_MapConfirmBtn,
                        size: FontSizes.mid,
                        textColor: AppColors.fontLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 140.h,
        right: 14.w,
        child: Visibility(
          visible: predictions.isEmpty,
          child: GestureDetector(
            onTap: () async {
              await goToCurrentLocationAsync();
            },
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.mainAppColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.r))),
              child: Icon(
                Icons.my_location,
                color: AppColors.mainAppColor,
                size: 17.w,
              ),
            ),
          ),
        ),
      )
    ]);
  }

  searchForLocationAsync(String value) {
    if (searchDelay?.isActive ?? false) {
      searchDelay?.cancel();
    }
    searchDelay = Timer(
      const Duration(seconds: 1),
      () async {
        if (value.isNotEmpty) {
          await autoCompleteSearchAsync(value);
        } else {
          setState(() {
            predictions.clear();
          });
        }
      },
    );
  }

  Future<void> goToSearchResultAsync(int index) async {
    await googlePlace?.details.get(predictions[index].placeId!).then(
      (detailsResponse) {
        if (detailsResponse != null &&
            detailsResponse.result != null &&
            mounted) {
          //clear search results
          predictions.clear();
          searchEditingController.clear();
          double? lat = detailsResponse.result?.geometry?.location?.lat;
          double? lng = detailsResponse.result?.geometry?.location?.lng;
          moveMarkerToLocation(
            LatLng(lat!, lng!),
          );
          //close the keyboard
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
    );
  }

  Future<void> onConfirmMapAsync() async {
    GeoData? address;
    try {
      address = await Geocoder2.getDataFromCoordinates(
          latitude: tappedMarkers.first.position.latitude,
          longitude: tappedMarkers.first.position.longitude,
          googleMapApiKey: googleMapApiKey);
    } catch (e) {
      //Todo: Null response sometimes
      //potential cause: some lat,lng coordinates does not have data
      debugPrint(e.toString());
      debugPrint("city: ${address?.city}");
      debugPrint("country: ${address?.country}");
      debugPrint("country code: ${address?.countryCode}");
      debugPrint("postal code: ${address?.postalCode}");
      debugPrint("state: ${address?.state}");
      debugPrint("street number: ${address?.street_number}");
      debugPrint("lat: ${address?.latitude}");
      debugPrint("long: ${address?.longitude}");
    }
    if (address != null) {
      bool done = await profileEditController.onConfirmUpdateAdress(
          address.country,
          address.state == "" ? address.city : address.state,
          address.address,
          address.longitude,
          address.latitude);
      if (done) {
        Get.back();
      }
    }
  }

  ///to get a custom marker from image
  setMarkerBitmap() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load(Res.mapMarker);
    markerBitmap = BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
    setState(() {
      tappedMarkers.add(
        Marker(
          markerId: const MarkerId("initial_location"),
          position: initialLocation!,
          icon: markerBitmap!,
        ),
      );
    });
  }

  void moveMarkerToLocation(LatLng tappedLocation) {
    tappedMarkers.clear();
    mapController
        ?.animateCamera(CameraUpdate.newLatLngZoom(tappedLocation, 14));
    setState(() {
      tappedMarkers.add(
        Marker(
          markerId: const MarkerId("user_address"),
          position: tappedLocation,
          icon: markerBitmap!,
        ),
      );
    });
  }

  autoCompleteSearchAsync(String value) async {
    var result = await googlePlace?.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  goToCurrentLocationAsync() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await location.getLocation().then((_locationData) {
      moveMarkerToLocation(
        LatLng(_locationData.latitude!, _locationData.longitude!),
      );
    });
  }
}
