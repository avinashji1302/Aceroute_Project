class Priority {
  final String id;
  final String name;
  final String color;

  Priority({required this.id, required this.name, required this.color});

  // Convert JSON to Model
  factory Priority.fromJson(Map<String, dynamic> json) {
    return Priority(
      id: json['id'],
      name: json['nm'],
      color: json['color'],
    );
  }

  // Convert Model to Map for Database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
}
