import 'package:ace_routes/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var accountName = ''.obs;
  var workerId = ''.obs;
  var password = ''.obs;
  var isPasswordVisible = false.obs;
  var rememberMe = false.obs;

  var accountNameError = ''.obs;
  var workerIdError = ''.obs;
  var passwordError = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool validateFields() {
    bool isValid = true;

    if (accountName.value.isEmpty) {
      accountNameError.value = 'This field is required';
      isValid = false;
    } else {
      accountNameError.value = '';
    }

    if (workerId.value.isEmpty) {
      workerIdError.value = 'This field is required';
      isValid = false;
    } else {
      workerIdError.value = '';
    }

    if (password.value.isEmpty) {
      passwordError.value = 'This field is required';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }

  void login(BuildContext context) {
    if (validateFields()) {
      // Navigate to HomeScreen if validation passes
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
      );
    }
  }

  void clearFields() {
    accountName.value = '';
    workerId.value = '';
    password.value = '';
    isPasswordVisible.value = false;
    rememberMe.value = false;

    accountNameError.value = '';
    workerIdError.value = '';
    passwordError.value = '';
  }
}