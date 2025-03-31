import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddBwFormController extends GetxController {
  // State for form fields
  var selectedValue = ''.obs; // For single-select dropdown
  var selectedValues = <String>{}.obs; // For multi-select checkboxes
  var selectedImage = Rx<XFile?>(null); // Reactive variable for the image
  var textEditingControllers = <String, TextEditingController>{}.obs; // Map for form fields

  // Initialize text editing controllers for dynamic fields
  void initializeTextControllers(List fields) {
    for (var field in fields) {
      if (field['nm'] == 'tech') {
        textEditingControllers[field['nm']] =
            TextEditingController(); // Create a controller
      }
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      selectedImage.value = image;
    }
  }
}
