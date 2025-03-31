import 'package:ace_routes/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var currentPassword = ''.obs;
  var newPassword = ''.obs;
  var reEnterPassword = ''.obs;

  var currentPasswordError = ''.obs;
  var newPasswordError = ''.obs;
  var reEnterPasswordError = ''.obs;

  void validateAndSubmit() {
    bool isValid = true;

    if (currentPassword.value.isEmpty) {
      currentPasswordError.value = 'Please enter your current password';
      isValid = false;
    } else {
      currentPasswordError.value = '';
    }

    if (newPassword.value.isEmpty) {
      newPasswordError.value = 'Please enter a new password';
      isValid = false;
    } else {
      newPasswordError.value = '';
    }

    if (reEnterPassword.value.isEmpty) {
      reEnterPasswordError.value = 'Please re-enter the new password';
      isValid = false;
    } else if (reEnterPassword.value != newPassword.value) {
      reEnterPasswordError.value = 'Passwords do not match';
      isValid = false;
    } else {
      reEnterPasswordError.value = '';
    }

    if (isValid) {
      // Simulate a password change success
      Get.defaultDialog(
        title: 'Success',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            const Text('Password changed successfully!'),
          ],
        ),
        confirm: Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Get.to(HomeScreen()),
            child: const Text('OK',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        ),
      );
    }
  }
}
