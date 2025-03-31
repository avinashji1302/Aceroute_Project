import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;

class LocationPermission extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    print('Checking location service...');
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('⚠️ Location services are disabled. Asking user to enable it...');
        await geo.Geolocator.openLocationSettings(); // Opens system settings
        return;
      }

      geo.LocationPermission permission =
          await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        print('Requesting location permission...');
        permission = await geo.Geolocator.requestPermission(); // System popup
        if (permission == geo.LocationPermission.denied) {
          print('❌ User denied location permission.');
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        print('❌ Location permissions are permanently denied.');
        return;
      }

      // If permissions are granted, fetch and print location
      await _fetchAndPrintLocation();
    } catch (e) {
      print('❌ Error getting location: $e');
    }
  }

  /// Fetch and print the user's current location
  Future<void> _fetchAndPrintLocation() async {
    geo.Position position = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.high);

    LatLng currentLocation = LatLng(position.latitude, position.longitude);
    print(
        '✅ User Location: ${currentLocation.latitude}, ${currentLocation.longitude}');
  }
}
