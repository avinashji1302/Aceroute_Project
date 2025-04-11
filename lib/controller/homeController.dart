import 'dart:async';

import 'package:ace_routes/core/colors/Constants.dart';
import 'package:ace_routes/database/Tables/api_data_table.dart';
import 'package:ace_routes/database/Tables/login_response_table.dart';
import 'package:ace_routes/database/databse_helper.dart';
import 'package:ace_routes/model/login_model/login_response.dart';
import 'package:ace_routes/model/login_model/token_api_response.dart';
import 'package:ace_routes/model/order_data_model.dart';
import 'package:ace_routes/controller/pubnub/pubnub_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:location/location.dart' as locationLib;
import 'package:permission_handler/permission_handler.dart'
    as permissionHandlerLib;
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart' as geo;
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();
  String userNsp = '';
  String subKey = '';

  LatLng currentLocation = LatLng(0, 0);

  @override
  void onInit() async {
    super.onInit();
    print("🚀 Initializing PubNub...");
    await _pubnubInitialize();
  }

  Future<void> _pubnubInitialize() async {
    List<LoginResponse> loginDataList =
        await LoginResponseTable.fetchLoginResponses();
    List<TokenApiReponse> loginResponseData = await ApiDataTable.fetchData();

    if (loginDataList.isEmpty) {
      print("⚠️ No login data found!");
      return;
    }

    for (var data in loginDataList) {
      subKey = data.subkey;

      print("🔑 Retrieved SubKey: $subKey");
    }

    for (var data in loginResponseData) {
      userNsp = data.nspId;

      print("📡 Retrieved Namespace: $userNsp");
    }

    if (subKey.isEmpty || userNsp.isEmpty) {
      print("❌ Error: Missing Subscribe Key or Namespace");
      return;
    }

    PubNubService pubnubService = PubNubService(
      userId: userNsp + "-" + rid,
      namespace: userNsp,
      subscriptionKey: subKey,
    );

    print("✅ PubNub Service Initialized: $pubnubService");
  }

  Future<void> getCurrentLocation() async {
    print('up');
    try {
      bool serviceEnabled;
      geo.LocationPermission permission;
      print('try');

      // Check if the location service is enabled
      serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('error');
        return Future.error('Location services are disabled.');
      }

      // Check for location permissions
      permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          return Future.error('Location permissions are denied.');
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // Get the current position
      geo.Position position = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.high);

      // Update the observable variable directly
      currentLocation = LatLng(position.latitude, position.longitude);
      print('Current Location: $currentLocation');

      // Animate the camera to the new location
      final GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newLatLng(currentLocation));
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  //----------------------------------------------------------------------------------

  // Observables for managing state
  var selectedIndex = 0.obs;
  var selectedDate = Rxn<DateTime>();

  // Method to handle bottom navigation bar item taps
  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // Method to get the formatted date
  String getFormattedDate() {
    DateTime date = selectedDate.value ?? DateTime.now();
    return DateFormat('MMMM d, yyyy')
        .format(date); // Example: "August 21, 2024"
  }

  // Method to get the day of the week
  String getFormattedDay() {
    DateTime date = selectedDate.value ?? DateTime.now();
    return DateFormat('EEEE').format(date); // Example: "Monday"
  }
}
