class VersionModel {
  final String success;
  final String id;

  VersionModel({required this.success, required this.id});

  // Convert JSON to VersionModel
  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      success: json['success'],
      id: json['id'],
    );
  }

  // Convert VersionModel to JSON (for database storage)
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'id': id,
    };
  }
}
