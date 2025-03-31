import 'dart:convert';

class EFormDataModel {
  final String id;
  final String oid;
  final String ftid;
  final String frmKey;
  final Map<String, dynamic> formFields; // Stores JSON directly
  final String updatedTimestamp;
  final String updatedBy;

  EFormDataModel({
    required this.id,
    required this.oid,
    required this.ftid,
    required this.frmKey,
    required this.formFields,
    required this.updatedTimestamp,
    required this.updatedBy,
  });

  // Factory constructor to create an EForm object from a Map
  factory EFormDataModel.fromJson(Map<String, dynamic> json) {
    return EFormDataModel(
      id: json['id'] ?? '',
      oid: json['oid'] ?? '',
      ftid: json['ftid'] ?? '',
      frmKey: json['frmKey'] ?? '',
      formFields: json['formFields'] != null
          ? Map<String, dynamic>.from(json['formFields'])
          : {},
      updatedTimestamp: json['updatedTimestamp'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
    );
  }

  // Converts the EForm object to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'oid': oid,
      'ftid': ftid,
      'frmKey': frmKey,
      'formFields': json.encode(formFields), // Convert JSON to string for storage
      'updatedTimestamp': updatedTimestamp,
      'updatedBy': updatedBy,
    };
  }
}