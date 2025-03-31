class FileMetaModel {
  final String id;
  final String fname;
  final String oid;
  final String tid;
  final String mime;
  final String dtl;
  final String geo;
  final String frmkey;
  final String frmfldid;
  final String upd;
  final String by;

  FileMetaModel({
    required this.id,
    required this.fname,
    required this.oid,
    required this.tid,
    required this.mime,
    required this.dtl,
    required this.geo,
    required this.frmkey,
    required this.frmfldid,
    required this.upd,
    required this.by,
  });

  factory FileMetaModel.fromJson(Map<String, dynamic> json) {
    return FileMetaModel(
      id: json['id'] ?? '',
      fname: json['fname'] ?? '',
      oid: json['oid'] ?? '',
      tid: json['tid'] ?? '',
      mime: json['mime'] ?? '',
      dtl: json['dtl'] ?? '',
      geo: json['geo'] ?? '',
      frmkey: json['frmkey'] ?? '',
      frmfldid: json['frmfldid'] ?? '',
      upd: json['upd'] ?? '',
      by: json['by'] ?? '',
    );
  }

  Map<String, String> toJson() {
    return {
      'id': id,
      'fname': fname,
      'oid': oid,
      'tid': tid,
      'mime': mime,
      'dtl': dtl,
      'geo': geo,
      'frmkey': frmkey,
      'frmfldid': frmfldid,
      'upd': upd,
      'by': by,
    };
  }
}