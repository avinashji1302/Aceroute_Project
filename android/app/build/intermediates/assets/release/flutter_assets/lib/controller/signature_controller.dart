import 'dart:typed_data';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class SignatureController extends GetxController {
  RxList<ui.Image> signatures = <ui.Image>[].obs;
  final int maxSignatures = 6;

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

        signatureData.add(String.fromCharCodes(bytes));
      }
    }

    prefs.setStringList('signatures', signatureData);
  }

  void addSignature(ui.Image signature) {
    if (signatures.length >= maxSignatures) {
      // signatures.removeAt(0); // Remove the oldest signature
    
      print('Can not accepts');
    } else {
      print('Can not accepts');
    }
    signatures.add(signature);
    _saveSignatures(); // Save the updated signatures
  }

  void deleteSignature(index) {
    signatures.removeAt(index);
  }
}
