import 'package:get/get.dart';

class FontSizeController extends GetxController {
  var selectedFontSize = 'medium'.obs; // Default font size


  double get fontSize {
    switch (selectedFontSize.value) {
      case 'extra_small':
        return 12.0;
      case 'small':
        return 14.0;
      case 'medium':
        return 16.0;
      case 'large':
        return 18.0;
      case 'extra_large':
        return 20.0;
      default:
        return 16.0;
    }
  }

  void updateFontSize(String newSize) {
    selectedFontSize.value = newSize;
  }

  void applyFontSize() {}
}
