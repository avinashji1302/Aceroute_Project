import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();

    _connectivity.onConnectivityChanged.listen(_updateConnectivity);
  }

  void _updateConnectivity(List<ConnectivityResult> connectivityResults) {
    print("Checking internet connection...");

    if (connectivityResults.contains(ConnectivityResult.none)) {
      Get.rawSnackbar(
        messageText: Text(
          "Please check the internet connectivity",
          style: TextStyle(color: Colors.red),
        ),
        isDismissible: false,
        duration: Duration(days: 1),
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
