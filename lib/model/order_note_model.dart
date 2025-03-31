class OrderNoteModel {
  final String data; // Single combined value

  OrderNoteModel({required this.data});

  // Convert from Map (database row) to OrderNoteModel object
  factory OrderNoteModel.fromMap(Map<String, dynamic> map) {
    return OrderNoteModel(
      data: map['data'] ?? '', // Ensure safe access with a fallback
    );
  }

  // Convert from OrderNoteModel object to Map (for database insertion)
  Map<String, dynamic> toMap() {
    return {
      'data': data,
    };
  }
}
