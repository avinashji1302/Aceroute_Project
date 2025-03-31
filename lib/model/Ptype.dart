class PartTypeDataModel {
  final String id;
  final String name;
  final String detail;
  final String unitPrice;
  final String unit;
  final String updatedBy;
  final String updatedDate;

  PartTypeDataModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.unitPrice,
    required this.unit,
    required this.updatedBy,
    required this.updatedDate,
  });

  // Convert a PartTypeDataModel into a Map. The keys must match the column names in the database.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'detail': detail,
    'unitPrice': unitPrice,
    'unit': unit,
    'updatedBy': updatedBy,
    'updatedDate': updatedDate,
  };

  // Convert a Map into a PartTypeDataModel
  factory PartTypeDataModel.fromJson(Map<String, dynamic> json) => PartTypeDataModel(
    id: json['id'],
    name: json['name'],
    detail: json['detail'],
    unitPrice: json['unitPrice'],
    unit: json['unit'],
    updatedBy: json['updatedBy'],
    updatedDate: json['updatedDate'],
  );
}
