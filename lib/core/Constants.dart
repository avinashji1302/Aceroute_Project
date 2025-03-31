import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../database/Tables/terms_data_table.dart';
import '../model/terms_model.dart';

var initURL = 'https://portal.aceroute.com';
// var initURL = 'https://qa.aceroute.com';




class AllTerms extends GetxController {
  static final namespace = "".obs;
  static final locationCode = "".obs;
  static final formName = "".obs;
  static final partName = "".obs;
  static final assetName = "".obs;
  static final pictureLabel = "".obs;
  static final audioLabel = "".obs;
  static final signatureLabel = "".obs;
  static final fileLabel = "".obs;
  static final workLabel = "".obs;
  static final customerLabel = "".obs;
  static final orderLabel = "".obs;
  static final customerReferenceLabel = "".obs;
  static final registrationLabel = "".obs;
  static final odometerLabel = "".obs;
  static final detailsLabel = "".obs;
  static final faultDescriptionLabel = "".obs;
  static final notesLabel = "".obs;
  static final summaryLabel = "".obs;
  static final orderGroupLabel = "".obs;
  static final fieldOrderRules = "".obs;
  static final invoiceEmailLabel = "".obs;

  static Future<void> getTerm() async {
    List<TermsDataModel> dataList = await TermsDataTable.fetchTermsData();

    for (var data in dataList) {
      namespace.value = data.namespace;
      locationCode.value = data.locationCode;
      formName.value = data.formName;
      partName.value = data.partName;
      assetName.value = data.assetName;
      pictureLabel.value = data.pictureLabel;
      audioLabel.value = data.audioLabel;
      signatureLabel.value = data.signatureLabel;
      fileLabel.value = data.fileLabel;
      workLabel.value = data.workLabel;
      customerLabel.value = data.customerLabel;
      orderLabel.value = data.orderLabel;
      customerReferenceLabel.value = data.customerReferenceLabel;
      registrationLabel.value = data.registrationLabel;
      odometerLabel.value = data.odometerLabel;
      detailsLabel.value = data.detailsLabel;
      faultDescriptionLabel.value = data.faultDescriptionLabel;
      notesLabel.value = data.notesLabel;
      summaryLabel.value = data.summaryLabel;
      orderGroupLabel.value = data.orderGroupLabel;
      fieldOrderRules.value = data.fieldOrderRules;
      invoiceEmailLabel.value = data.invoiceEmailLabel;

      // Print each label to confirm
      // print("Namespace: ${namespace.value}");
      // print("Location Code: ${locationCode.value}");
      // print("Form Name: ${formName.value}");
      // Add more print statements if needed
    }
  }
}




