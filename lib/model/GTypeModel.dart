import 'dart:convert';

class GTypeModel {
  final String id;
  final String name;
  final String typeId;
  final String capacity;
  final Map<String, dynamic> details;  // Change details to a Map
  final String externalId;
  final String updateTimestamp;
  final String updatedBy;

  GTypeModel({
    required this.id,
    required this.name,
    required this.typeId,
    required this.capacity,
    required this.details,  // Adjusted constructor
    required this.externalId,
    required this.updateTimestamp,
    required this.updatedBy,
  });

  // Method to convert model data to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'typeId': typeId,
      'capacity': capacity,
      'details': jsonEncode(details),  // Convert the Map back to a JSON string
      'externalId': externalId,
      'updateTimestamp': updateTimestamp,
      'updatedBy': updatedBy,
    };
  }

  // Method to create a GTypeModel from a Map (for your case, database insertion)
  factory GTypeModel.fromMap(Map<String, dynamic> map) {
    return GTypeModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      typeId: map['typeId'] ?? '',
      capacity: map['capacity'] ?? '',
      details: map['details'] != null
          ? jsonDecode(map['details']) is Map<String, dynamic>
          ? jsonDecode(map['details'])
          : {} // Check if details can be decoded to a Map
          : {},  // Decode the details field as a Map
      externalId: map['externalId'] ?? '',
      updateTimestamp: map['updateTimestamp'] ?? '',
      updatedBy: map['updatedBy'] ?? '',
    );
  }

  // Method to create a GTypeModel from JSON data
  factory GTypeModel.fromJson(Map<String, dynamic> json) {
    // Check if 'details' is a valid JSON string or handle it as an empty map if not
    var details = json['details'];
    Map<String, dynamic> decodedDetails = {};

    try {
      if (details != null && details is String && details.isNotEmpty) {
        decodedDetails = jsonDecode(details);
      }
    } catch (e) {
      // Handle invalid JSON gracefully, default to an empty map
      print("Error decoding details: $e");
    }

    return GTypeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      typeId: json['typeId'] ?? '',
      capacity: json['capacity'] ?? '',
      details: decodedDetails,  // Use the decoded details map
      externalId: json['externalId'] ?? '',
      updateTimestamp: json['updateTimestamp'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
    );
  }


  // Method to convert model data to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'typeId': typeId,
      'capacity': capacity,
      'details': details,  // Keep details as a Map
      'externalId': externalId,
      'updateTimestamp': updateTimestamp,
      'updatedBy': updatedBy,
    };
  }
}
