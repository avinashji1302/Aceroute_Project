import 'package:get/get.dart';
import 'fontSizeController.dart';

class DrawerControllers extends GetxController {
  final selectedFontSize = Get.find<FontSizeController>().selectedFontSize;

  void updateFontSize(String newSize) {
    Get.find<FontSizeController>().updateFontSize(newSize);
  }
}
