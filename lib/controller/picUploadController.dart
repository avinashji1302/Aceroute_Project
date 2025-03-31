import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PicUploadController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var images = <XFile>[].obs; // Observable list to store selected images
  var selectedIndices = <int>[].obs; // Observable list to store selected image indices

  // Method to pick an image
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      if (images.length < 6) {
        images.add(image);
      } else {
        Get.snackbar('Limit Reached', 'You can only upload up to 6 images.',
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  // Method to toggle image selection
  void toggleSelection(int index) {
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
    } else {
      selectedIndices.add(index);
    }
  }

  // Method to delete a selected image
  void deleteImage(int index) {
    images.removeAt(index);
    selectedIndices.remove(index);
  }

  // Method to clear all images
  void clearImages() {
    
    selectedIndices.clear();
  }

    void clearSelection() {
    selectedIndices.clear();
  }
}
