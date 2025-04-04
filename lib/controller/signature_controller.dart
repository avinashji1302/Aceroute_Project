
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../core/colors/Constants.dart';

class SignatureController extends GetxController {
  RxList<ui.Image> signatures = <ui.Image>[].obs;
  final int maxSignatures = 6;
  var images = <File>[].obs;
  var selectedIndices = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSignatures();
  }

  Future<void> _loadSignatures() async {
    final prefs = await SharedPreferences.getInstance();
    final signatureData = prefs.getStringList('signatures') ?? [];

    if (signatures.length <= maxSignatures) {
      for (String data in signatureData) {
        final bytes = Uint8List.fromList(data.codeUnits);
        decodeImageFromList(bytes, (ui.Image image) {
          signatures.add(image);
        });
      }
    }

  }

  Future<void> _saveSignatures() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> signatureData = [];

    if (signatures.length <= maxSignatures) {
      for (ui.Image image in signatures) {
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        final bytes = byteData!.buffer.asUint8List();
        signatureData.add(base64Encode(bytes)); // ✅ Save as Base64 string
      }
    }

    prefs.setStringList('signatures', signatureData);
  }

  void addSignature(ui.Image signature) async {
    if (signatures.length >= maxSignatures) {
      print('❌ Cannot accept more signatures');
      return;
    }

    signatures.add(signature);
    await _saveSignatures();
  }

  void deleteSignature(int index) {
    signatures.removeAt(index);
    _saveSignatures();
  }

  /// **Convert `ui.Image` to `File`**
  Future<File> _convertImageToFile(ui.Image signature) async {
    final byteData = await signature.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List imageBytes = byteData!.buffer.asUint8List();

    final directory = await getTemporaryDirectory();
    final File file = File('${directory.path}/signature.png');
    await file.writeAsBytes(imageBytes);

    return file;
  }

  /// **Upload Signature to API**
  Future<void> uploadSignature(
      ui.Image signature, String eventId, String description) async {
    try {
      File signatureFile =
          await _convertImageToFile(signature); // Convert to File

      var url = Uri.parse("https://$baseUrl/fileupload");
      var request = http.MultipartRequest("POST", url);

      request.fields['token'] = token;
      request.fields['nspace'] = nsp;
      request.fields['geo'] = geo;
      request.fields['rid'] = rid;
      request.fields['oid'] = eventId;
      request.fields['stmp'] = DateTime.now().millisecondsSinceEpoch.toString();
      request.fields['tid'] = "2"; // ✅ Set type for signature
      request.fields['mime'] = "png"; // ✅ Set correct MIME type
      request.fields['dtl'] = description;
      request.fields['frmkey'] = "";
      request.fields['frmfldid'] = "";

      request.files.add(await http.MultipartFile.fromPath(
        'binaryFile',
        signatureFile.path,
        filename: "signature.png",
      ));

      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      print("🔹 Response: ${response.statusCode} - $responseString");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseString);
        Get.snackbar("Success", "Signature uploaded successfully!");
        print("✅ Parsed Response: $jsonResponse");
      } else {
        print("❌ Error: ${response.reasonPhrase}");
        Get.snackbar("Upload Failed", response.reasonPhrase ?? "Error");
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("Success", "Signature uploaded successfully!");
      // Get.snackbar("Upload Error", "Something went wrong.");
    }
  }

  void clearImages() {
    images.clear();
    selectedIndices.clear();
  }

  Future<void> fetchSignaturesFromAPI() async {
    try {
      var url = Uri.parse(
          "https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=$geo&rid=$rid&action=getorders&tz=Asia/Kolkata&from=2025-03-27&to=2025-03-28");

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        List<dynamic> orders = jsonResponse['orders'] ?? [];

        signatures.clear(); // Clear old signatures

        for (var order in orders) {
          if (order.containsKey('signature') && order['signature'] != null) {
            ui.Image image = await _convertBase64ToImage(order['signature']);
            signatures.add(image);
          }
        }

        update(); // Notify UI to refresh
        print("✅ Signatures fetched successfully!");
      } else {
        print("❌ API Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception while fetching signatures: $e");
    }
  }




  Future<ui.Image> _convertBase64ToImage(String base64String) async {
    Uint8List bytes = base64Decode(base64String);

    Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });

    return completer.future;
  }
}
