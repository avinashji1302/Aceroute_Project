import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Show a reusable no internet dialog
void showNoInternetDialog() {
  Get.dialog(
    AlertDialog(
      title: const Text('No Internet Connection'),
      content: const Text(
        'Internet connection is required to perform this action. Please enable your internet and try again.',
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(), // Close dialog
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _openInternetSettings();
            Get.back();
          },
          child: const Text('Open Settings'),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

/// Open WiFi/Internet settings
void _openInternetSettings() async {
  const url = 'android.settings.WIFI_SETTINGS';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not open internet settings');
  }
}
