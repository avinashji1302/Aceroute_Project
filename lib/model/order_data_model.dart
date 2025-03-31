class GetOrderData {
  final String id;
  final String cid;
  final String startDate;
  final String endDate;
  final String etm;
  final String nm;
  final String wkf;
  final String alt;
  final String po;
  final String inv;
  final String tid;
  final String pid;
  final String rid;
  final String ridcmt;
  final String dtl;
  final String lid;
  final String cntid;
  final String flg;
  final String est;
  final String lst;
  final String ctid;
  final String ctpnm;
  final String ltpnm;
  final String cnm;
  final String adr;
  final String adr2;
  final String geo;
  final String cntnm;
  final String tel;
  final String ordfld1;
  final String ttid;
  final String cfrm;
  final String cprt;
  final String xid;
  final String cxid;
  final String tz;
  final String zip;
  final String fmeta;
  final String cimg;
  final String caud;
  final String csig;
  final String cdoc;
  final String cnot;
  final String dur;
  final String val;
  final String rgn;
  final String upd;
  final String by;
  final String znid;

  GetOrderData({
    required this.id,
    required this.cid,
    required this.startDate,
    required this.endDate,
    required this.etm,
    required this.nm,
    required this.wkf,
    required this.alt,
    required this.po,
    required this.inv,
    required this.tid,
    required this.pid,
    required this.rid,
    required this.ridcmt,
    required this.dtl,
    required this.lid,
    required this.cntid,
    required this.flg,
    required this.est,
    required this.lst,
    required this.ctid,
    required this.ctpnm,
    required this.ltpnm,
    required this.cnm,
    required this.adr,
    required this.adr2,
    required this.geo,
    required this.cntnm,
    required this.tel,
    required this.ordfld1,
    required this.ttid,
    required this.cfrm,
    required this.cprt,
    required this.xid,
    required this.cxid,
    required this.tz,
    required this.zip,
    required this.fmeta,
    required this.cimg,
    required this.caud,
    required this.csig,
    required this.cdoc,
    required this.cnot,
    required this.dur,
    required this.val,
    required this.rgn,
    required this.upd,
    required this.by,
    required this.znid,
    required ctnm,
  });

  // Convert the model to JSON (Map) for database insertion
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cid': cid,
      'startDate': startDate,
      'endDate': endDate,
      'nm': nm,
      'wkf': wkf,
      'alt': alt,
      'po': po,
      'inv': inv,
      'tid': tid,
      'pid': pid,
      'rid': rid,
      'ridcmt': ridcmt,
      'dtl': dtl,
      'lid': lid,
      'cntid': cntid,
      'flg': flg,
      'est': est,
      'lst': lst,
      'ctid': ctid,
      'ctnm': ctpnm,
      'adr': adr,
      'geo': geo,
      'cntnm': cntnm,
      'tel': tel,
      'ttid': ttid,
      'cfrm': cfrm,
      'cprt': cprt,
      'xid': xid,
      'cxid': cxid,
      'tz': tz,
      'zip': zip,
      'fmeta': fmeta,
      'cimg': cimg,
      'caud': caud,
      'csig': csig,
      'cdoc': cdoc,
      'cnot': cnot,
      'dur': dur,
      'val': val,
      'rgn': rgn,
      'upd': upd,
      'by': by,
      'znid': znid,
    };
  }

  // Create a model from JSON (Map)
  factory GetOrderData.fromJson(Map<String, dynamic> json) {
    return GetOrderData(
      id: json['id'],
      cid: json['cid'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      nm: json['nm'],
      wkf: json['wkf'],
      alt: json['alt'],
      po: json['po'],
      inv: json['inv'],
      tid: json['tid'],
      pid: json['pid'],
      rid: json['rid'],
      ridcmt: json['ridcmt'],
      dtl: json['dtl'],
      lid: json['lid'],
      cntid: json['cntid'],
      flg: json['flg'],
      est: json['est'],
      lst: json['lst'],
      ctid: json['ctid'],
      ctnm: json['cnm'],
      adr: json['adr'],
      geo: json['geo'],
      cntnm: json['cntnm'],
      tel: json['tel'],
      ttid: json['ttid'],
      cfrm: json['cfrm'],
      cprt: json['cprt'],
      xid: json['xid'],
      cxid: json['cxid'],
      tz: json['tz'],
      zip: json['zip'],
      fmeta: json['fmeta'],
      cimg: json['cimg'],
      caud: json['caud'],
      csig: json['csig'],
      cdoc: json['cdoc'],
      cnot: json['cnot'],
      dur: json['dur'],
      val: json['val'],
      rgn: json['rgn'],
      upd: json['upd'],
      by: json['by'],
      znid: json['znid'],
      etm: json['etm'],
      ctpnm: json['ctpm'],
      ltpnm: json['ltonm'],
      cnm: json['cnm'],
      adr2: json['adr2'],
      ordfld1: json['orderfld1'],
    );
  }
}
