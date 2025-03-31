import 'package:get/get.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarcodeController extends GetxController {
  String result = '';
  var scannedData = ''.obs; // Observable variable for scanned data

  void updateSkuController(String data) {
    scannedData.value = data;
    print("Scanned Data: $data");
  }

  Future<void> scanBarcode() async {
    print('scanBarcode method called'); // Debugging print
    var res = await Get.to(() => SimpleBarcodeScannerPage(
          lineColor: "#ff6666",
          cancelButtonText: "Cancel",
          isShowFlashIcon: true,
        ));

    if (res != null && res is String) {
      result = res;
      print('Scanned Barcode: $result'); // Print the scanned barcode

      // Update SKU controller with scanned data
       updateSkuController(res);
    } else {
      print('No barcode scanned');
     
    }
  }
}
