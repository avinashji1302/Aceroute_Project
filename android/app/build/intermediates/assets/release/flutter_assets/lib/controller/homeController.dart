import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  // Observables for managing state
  var selectedIndex = 0.obs;
  var counter = 0.obs;
  var selectedDate = Rxn<DateTime>();

  // Method to handle bottom navigation bar item taps
  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  // Method to increment the counter
  void incrementCounter() {
    counter.value++;
  }

  // Method to request permissions
  Future<void> requestPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasRequestedPermissions = prefs.getBool('hasRequestedPermissions') ?? false;

    if (!hasRequestedPermissions) {
      // Request location permission
      PermissionStatus locationStatus = await Permission.location.request();
      if (locationStatus.isGranted) {
        print('Location permission granted');
      } else if (locationStatus.isDenied) {
        print('Location permission denied');
        // Handle denial case
      } else if (locationStatus.isPermanentlyDenied) {
        print('Location permission permanently denied');
        // Handle permanently denied case
        openAppSettings();
      }

      // Request storage permission
      PermissionStatus storageStatus = await Permission.storage.request();
      if (storageStatus.isGranted) {
        print('Storage permission granted');
      } else if (storageStatus.isDenied) {
        print('Storage permission denied');
        // Handle denial case
      } else if (storageStatus.isPermanentlyDenied) {
        print('Storage permission permanently denied');
        // Handle permanently denied case
        openAppSettings();
      }

      // Save the flag to indicate that permissions have been requested
      await prefs.setBool('hasRequestedPermissions', true);
    }
  }
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  // Method to get the formatted date
  String getFormattedDate() {
    DateTime date = selectedDate.value ?? DateTime.now();
    return DateFormat('MMMM d, yyyy').format(date); // Example: "August 21, 2024"
  }

  // Method to get the day of the week
  String getFormattedDay() {
    DateTime date = selectedDate.value ?? DateTime.now();
    return DateFormat('EEEE').format(date); // Example: "Monday"
  }

  @override
  void onInit() {
    super.onInit();
    requestPermissions(); // Request permissions when the controller is initialized
  }


}
