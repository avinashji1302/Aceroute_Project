class OrderTypeModel {
  final String id;
  final String name;
  final String abbreviation;
  final String duration;
  final String capacity;
  final String parentId;
  final String customTimeSlot;
  final String elapseTimeSlot;
  final String value;
  final String externalId;
  final String updateTimestamp;
  final String updatedBy;

  OrderTypeModel({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.duration,
    required this.capacity,
    required this.parentId,
    required this.customTimeSlot,
    required this.elapseTimeSlot,
    required this.value,
    required this.externalId,
    required this.updateTimestamp,
    required this.updatedBy,
  });

  factory OrderTypeModel.fromMap(Map<String, dynamic> map) {
    return OrderTypeModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      abbreviation: map['abbreviation']?.toString() ?? '',
      duration: map['duration']?.toString() ?? '',
      capacity: map['capacity']?.toString() ?? '',
      parentId: map['parentId']?.toString() ?? '',
      customTimeSlot: map['customTimeSlot']?.toString() ?? '',
      elapseTimeSlot: map['elapseTimeSlot']?.toString() ?? '',
      value: map['value']?.toString() ?? '',
      externalId: map['externalId']?.toString() ?? '',
      updateTimestamp: map['updateTimestamp']?.toString() ?? '',
      updatedBy: map['updatedBy']?.toString() ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'duration': duration,
      'capacity': capacity,
      'parentId': parentId,
      'customTimeSlot': customTimeSlot,
      'elapseTimeSlot': elapseTimeSlot,
      'value': value,
      'externalId': externalId,
      'updateTimestamp': updateTimestamp,
      'updatedBy': updatedBy,
    };
  }
}
