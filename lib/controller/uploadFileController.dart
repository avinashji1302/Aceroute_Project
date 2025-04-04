import 'dart:io';
import 'package:ace_routes/core/colors/Constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';



class UploadFileController extends GetxController {
  var images = <File>[].obs; // List of picked images
  var imageDescriptions = <String>[].obs; // 🔹 Add this line to store descriptions

  // ✅ Pick an image from the camera
  Future<File?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      images.add(file);
      imageDescriptions.add(""); // 🔹 Add an empty description for the new image
      update();
      return file;
    }
    return null;
  }

  // ✅ Remove an image from the list
  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      imageDescriptions.removeAt(index); // 🔹 Remove the corresponding description
      update();
    }
  }

  // ✅ Upload image to API
  Future<void> uploadImage(File file, String eventId, String fileType, String description) async {
    try {
      var url = Uri.parse("https://$baseUrl/fileupload");
      var request = http.MultipartRequest("POST", url);

      request.fields['token'] = "$token";
      request.fields['nspace'] = "$nsp";
      request.fields['geo'] = "$geo";
      request.fields['rid'] = "$rid";
      request.fields['oid'] = eventId;
      request.fields['stmp'] = DateTime.now().millisecondsSinceEpoch.toString();
      request.fields['tid'] = fileType;
      request.fields['mime'] = fileType == "1" ? "mp3" : "jpg";
      request.fields['dtl'] = description; // 🔹 Send the description with the request
      request.fields['frmkey'] = "";
      request.fields['frmfldid'] = "";

      request.files.add(await http.MultipartFile.fromPath(
        'binaryFile',
        file.path,
        filename: basename(file.path),
      ));

      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      print("🔹 Response: ${response.statusCode} - $responseString");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseString);
        Get.snackbar("Success", "Image uploaded successfully!");
        print("✅ Parsed Response: $jsonResponse");
      } else {
        print("❌ Error: ${response.reasonPhrase}");
        Get.snackbar("Upload Failed", response.reasonPhrase ?? "Error");
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("Upload Error", e.toString());
    }
  }

  // ✅ Clear images when leaving the screen
  void clearImages() {
    images.clear();
    imageDescriptions.clear(); // 🔹 Clear descriptions too
    update();
  }
}


/*
class UploadFileController extends GetxController {
  var images = <File>[].obs; // Observables to track images

  // ✅ Pick an image from the camera
  Future<File?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      images.add(file);
      update(); // Update the UI
      return file;
    }
    return null;
  }

  // ✅ Remove an image from the list
  void removeImage(int index) {
    if (index >= 0 && index < images.length) {
      images.removeAt(index);
      update(); // Update UI
    }
  }

  // ✅ Upload image to API
  Future<void> uploadImage(File file, String eventId, String fileType, String description) async {
    try {
      var url = Uri.parse("https://$baseUrl/fileupload");

      var request = http.MultipartRequest("POST", url);

      request.fields['token'] = "$token";
      request.fields['nspace'] = "$nsp";
      request.fields['geo'] = "$geo";
      request.fields['rid'] = "$rid";
      request.fields['oid'] = eventId;
      request.fields['stmp'] = DateTime.now().millisecondsSinceEpoch.toString();
      request.fields['tid'] = fileType;
      request.fields['mime'] = fileType == "1" ? "mp3" : "jpg";
      request.fields['dtl'] = description;
      request.fields['frmkey'] = "";
      request.fields['frmfldid'] = "";

      request.files.add(await http.MultipartFile.fromPath(
        'binaryFile',
        file.path,
        filename: basename(file.path),
      ));

      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      print("🔹 Response: ${response.statusCode} - $responseString");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseString);
        Get.snackbar("Success", "Image uploaded successfully!");
        print("✅ Parsed Response: $jsonResponse");
      } else {
        print("❌ Error: ${response.reasonPhrase}");
        Get.snackbar("Upload Failed", response.reasonPhrase ?? "Error");
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("Upload Error", e.toString());
    }
  }

  // ✅ Clear images when leaving the screen
  void clearImages() {
    images.clear();
    update();
  }
}
*/
