class TermsDataModel {
  final String namespace;
  final String locationCode;
  final String formName;
  final String partName;
  final String assetName;
  final String pictureLabel;
  final String audioLabel;
  final String signatureLabel;
  final String fileLabel;
  final String workLabel;
  final String customerLabel;
  final String orderLabel;
  final String customerReferenceLabel;
  final String registrationLabel;
  final String odometerLabel;
  final String detailsLabel;
  final String faultDescriptionLabel;
  final String notesLabel;
  final String summaryLabel;
  final String orderGroupLabel;
  final String fieldOrderRules;
  final String invoiceEmailLabel;

  TermsDataModel({
    required this.namespace,
    required this.locationCode,
    required this.formName,
    required this.partName,
    required this.assetName,
    required this.pictureLabel,
    required this.audioLabel,
    required this.signatureLabel,
    required this.fileLabel,
    required this.workLabel,
    required this.customerLabel,
    required this.orderLabel,
    required this.customerReferenceLabel,
    required this.registrationLabel,
    required this.odometerLabel,
    required this.detailsLabel,
    required this.faultDescriptionLabel,
    required this.notesLabel,
    required this.summaryLabel,
    required this.orderGroupLabel,
    required this.fieldOrderRules,
    required this.invoiceEmailLabel,
  });

  // Convert the model to JSON (Map) for database insertion
  Map<String, dynamic> toJson() {
    return {
      'namespace': namespace,
      'locationCode': locationCode,
      'formName': formName,
      'partName': partName,
      'assetName': assetName,
      'pictureLabel': pictureLabel,
      'audioLabel': audioLabel,
      'signatureLabel': signatureLabel,
      'fileLabel': fileLabel,
      'workLabel': workLabel,
      'customerLabel': customerLabel,
      'orderLabel': orderLabel,
      'customerReferenceLabel': customerReferenceLabel,
      'registrationLabel': registrationLabel,
      'odometerLabel': odometerLabel,
      'detailsLabel': detailsLabel,
      'faultDescriptionLabel': faultDescriptionLabel,
      'notesLabel': notesLabel,
      'summaryLabel': summaryLabel,
      'orderGroupLabel': orderGroupLabel,
      'fieldOrderRules': fieldOrderRules,
      'invoiceEmailLabel': invoiceEmailLabel,
    };
  }

  // Create a model from JSON (Map)
  factory TermsDataModel.fromJson(Map<String, dynamic> json) {
    return TermsDataModel(
      namespace: json['namespace'],
      locationCode: json['locationCode'],
      formName: json['formName'],
      partName: json['partName'],
      assetName: json['assetName'],
      pictureLabel: json['pictureLabel'],
      audioLabel: json['audioLabel'],
      signatureLabel: json['signatureLabel'],
      fileLabel: json['fileLabel'],
      workLabel: json['workLabel'],
      customerLabel: json['customerLabel'],
      orderLabel: json['orderLabel'],
      customerReferenceLabel: json['customerReferenceLabel'],
      registrationLabel: json['registrationLabel'],
      odometerLabel: json['odometerLabel'],
      detailsLabel: json['detailsLabel'],
      faultDescriptionLabel: json['faultDescriptionLabel'],
      notesLabel: json['notesLabel'],
      summaryLabel: json['summaryLabel'],
      orderGroupLabel: json['orderGroupLabel'],
      fieldOrderRules: json['fieldOrderRules'],
      invoiceEmailLabel: json['invoiceEmailLabel'],
    );
  }
}
