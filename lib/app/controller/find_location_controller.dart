/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V8
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2025-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user/app/backend/api/handler.dart';
import 'package:user/app/backend/models/google_places_model.dart';
import 'package:user/app/backend/parse/find_location_parse.dart';
import 'package:user/app/controller/account_controller.dart';
import 'package:user/app/controller/booking_controller.dart';
import 'package:user/app/controller/categories_controller.dart';
import 'package:user/app/controller/home_controller.dart';
import 'package:user/app/controller/near_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/router.dart';
import 'package:user/app/helper/uuid_generator.dart';
import 'package:user/app/util/theme.dart';
import 'package:user/app/util/toast.dart';

class FindLocationController extends GetxController implements GetxService {
  final FindLocationParser parser;

  final Set<Marker> markers = {};
  final searchbarText = TextEditingController();
  List<GooglePlacesModel> _getList = <GooglePlacesModel>[];
  List<GooglePlacesModel> get getList => _getList;

  double myLat = 13.724381;
  double myLng = 100.3034506;

  bool isConfirmed = false;

  LatLng selectedLatLng = LatLng(13.724381, 100.3034506);

  FindLocationController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    selectedLatLng = LatLng(myLat, myLng);
    updateMarkerPosition(selectedLatLng);
  }

  void onMarkerDragEnd(LatLng position) {
  selectedLatLng = position;
    isConfirmed = true;
    getAddressFromLatLng(position);
    update();
}

Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = [
          place.name,
          place.street,
          place.locality,
          place.administrativeArea,
          place.postalCode,
          place.country
        ].where((part) => part?.isNotEmpty ?? false).join(', ');
        searchbarText.text = address;
        update();
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
  }

void updateMarkerPosition(LatLng position) {
  selectedLatLng = position;
  isConfirmed = true;
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('selected-location'),
        position: position,
        draggable: true,
        onDragEnd: (newPosition) {
          onMarkerDragEnd(newPosition);
        },
      ),
    );
    update();
  }

  void getLocation() async {
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(child: Text("Featching Location".tr, style: const TextStyle(fontFamily: 'bold'))),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );
    _determinePosition().then((value) async {
      Get.back();
      debugPrint(value.toString());
      List<Placemark> newPlace = await placemarkFromCoordinates(value.latitude, value.longitude);
      Placemark placeMark = newPlace[0];
      String name = placeMark.name.toString();
      String subLocality = placeMark.subLocality.toString();
      String locality = placeMark.locality.toString();
      String administrativeArea = placeMark.administrativeArea.toString();
      String postalCode = placeMark.postalCode.toString();
      String country = placeMark.country.toString();
      String address = "$name,$subLocality,$locality,$administrativeArea,$postalCode,$country";
      debugPrint(address);
      parser.saveLatLng(value.latitude, value.longitude, address);

      Get.delete<TabsController>(force: true);
      Get.delete<HomeController>(force: true);
      Get.delete<NearController>(force: true);
      Get.delete<CategoriesController>(force: true);
      Get.delete<BookingController>(force: true);
      Get.delete<AccountController>(force: true);
      Get.offAndToNamed(AppRouter.getTabsBarRoute());
    }).catchError((error) async {
      Get.back();
      showToast(error.toString());
      await Geolocator.openLocationSettings();
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.'.tr);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied'.tr);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.'.tr);
    }
    return await Geolocator.getCurrentPosition();
  }

  void onMapCreated(GoogleMapController controller) {
    updateMarkerPosition(selectedLatLng);
  // selectedLatLng = LatLng(myLat, myLng); // Initialize the selected location
  // markers.add(
  //   Marker(
  //     markerId: const MarkerId('selected-location'),
  //     position: selectedLatLng,
  //     draggable: true,
  //     onDragEnd: (newPosition) {
  //       onMarkerDragEnd(newPosition); // Update the selected location
  //     },
  //   ),
  // );
  // update();
}

  void onSearchChanged(String value) {
    debugPrint(value);
    if (value.isNotEmpty) {
      getPlacesList(value);
    }
  }

  Future<void> getPlacesList(String value) async {
    String googleURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    var sessionToken = Uuid().generateV4();
    var googleKey = Environments.googleMapsKey;
    String request = '$googleURL?input=$value&key=$googleKey&sessiontoken=$sessionToken&types=locality';

    '$googleURL?input=$value&key=$Environments.googleMapsKey&sessiontoken=$sessionToken';
    Response response = await parser.getPlacesList(request);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['predictions'];
      _getList = [];
      body.forEach((data) {
        GooglePlacesModel datas = GooglePlacesModel.fromJson(data);
        _getList.add(datas);
      });
      isConfirmed = false;
      update();
      debugPrint(_getList.length.toString());
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getLatLngFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      _getList = [];
      searchbarText.text = address;
      selectedLatLng = LatLng(locations[0].latitude, locations[0].longitude);
      isConfirmed = true;
      updateMarkerPosition(selectedLatLng);
    }
  }

  void onConfirmLocation() {
    parser.saveLatLng(
      selectedLatLng.latitude,
      selectedLatLng.longitude,
      searchbarText.text,
    );
    // parser.saveLatLng(myLat, myLng, searchbarText.text);
    Get.delete<TabsController>(force: true);
    Get.delete<HomeController>(force: true);
    Get.delete<NearController>(force: true);
    Get.delete<CategoriesController>(force: true);
    Get.delete<BookingController>(force: true);
    Get.delete<AccountController>(force: true);
    Get.offAndToNamed(AppRouter.getTabsBarRoute());
  }
}


