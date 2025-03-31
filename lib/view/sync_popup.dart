import 'package:ace_routes/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/fontSizeController.dart'; // Import GetX for navigation

class SyncPopup extends StatelessWidget {
  const SyncPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSizeController = Get.find<FontSizeController>();
    // Start a timer to close the dialog and navigate to HomeScreen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close the dialog
      // Navigate to HomeScreen
      Get.to(() => HomeScreen());
    });

    return AlertDialog(
      title: Text(
        'Sync Data',
        style: TextStyle(color: Colors.green,fontSize: fontSizeController.fontSize,),
      ),
      content: SizedBox(
        height: 100, // Adjust the height as needed
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}