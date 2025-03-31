class OrderParts {
  final String id;
  final String oid;
  final String tid;
  final String sku;
  final String qty;
  final String upd;
  final String by;

  OrderParts({
    required this.id,
    required this.oid,
    required this.tid,
    required this.sku,
    required this.qty,
    required this.upd,
    required this.by,
  });

  // Convert an OrderParts object to a map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'oid': oid,
      'tid': tid,
      'sku': sku,
      'qty': qty,
      'upd': upd,
      'by': by,
    };
  }

  // Create an OrderParts object from a map
  static OrderParts fromMap(Map<String, dynamic> map) {
    return OrderParts(
      id: map['id'],
      oid: map['oid'],
      tid: map['tid'],
      sku: map['sku'],
      qty: map['qty'],
      upd: map['upd'],
      by: map['by'],
    );
  }
  // Convert OrderParts object to JSON-serializable map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'oid': oid,
      'tid': tid,
      'sku': sku,
      'qty': qty,
      'upd': upd,
      'by': by,
    };
  }
}