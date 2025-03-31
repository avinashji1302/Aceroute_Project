class Event {
  final String id;
  final String cid;
  final String startDate;
  final String etm;
  final String endDate;
  final String name;
  final String wkf;
  final String alt;
  final String po;
  final String inv;
  final String tid;
  final String pid;
  final String rid;
  final String ridcmt;
  final String detail;
  final String lid;
  final String cntid;
  final String flg;
  final String est;
  final String lst;
  final String ctid;
  final String ctpnm;
  final String ltpnm;
  final String cnm;
  final String address;
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

  Event({
    required this.id,
    required this.cid,
    required this.startDate,
    required this.etm,
    required this.endDate,
    required this.name,
    required this.wkf,
    required this.alt,
    required this.po,
    required this.inv,
    required this.tid,
    required this.pid,
    required this.rid,
    required this.ridcmt,
    required this.detail,
    required this.lid,
    required this.cntid,
    required this.flg,
    required this.est,
    required this.lst,
    required this.ctid,
    required this.ctpnm,
    required this.ltpnm,
    required this.cnm,
    required this.address,
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
  });

  factory Event.fromJson(Map<String, dynamic> map) {
    return Event(
      id: map['id'] ?? '',
      cid: map['cid'] ?? '',
      startDate: map['start_date'] ?? '',
      etm: map['etm'] ?? '',
      endDate: map['end_date'] ?? '',
      name: map['name'] ?? '',
      wkf: map['wkf'] ?? '',
      alt: map['alt'] ?? '',
      po: map['po'] ?? '',
      inv: map['inv'] ?? '',
      tid: map['tid'] ?? '',
      pid: map['pid'] ?? '',
      rid: map['rid'] ?? '',
      ridcmt: map['ridcmt'] ?? '',
      detail: map['detail'] ?? '',
      lid: map['lid'] ?? '',
      cntid: map['cntid'] ?? '',
      flg: map['flg'] ?? '',
      est: map['est'] ?? '',
      lst: map['lst'] ?? '',
      ctid: map['ctid'] ?? '',
      ctpnm: map['ctpnm'] ?? '',
      ltpnm: map['ltpnm'] ?? '',
      cnm: map['cnm'] ?? '',
      address: map['address'] ?? '',
      geo: map['geo'] ?? '',
      cntnm: map['cntnm'] ?? '',
      tel: map['tel'] ?? '',
      ordfld1: map['ordfld1'] ?? '',
      ttid: map['ttid'] ?? '',
      cfrm: map['cfrm'] ?? '',
      cprt: map['cprt'] ?? '',
      xid: map['xid'] ?? '',
      cxid: map['cxid'] ?? '',
      tz: map['tz'] ?? '',
      zip: map['zip'] ?? '',
      fmeta: map['fmeta'] ?? '',
      cimg: map['cimg'] ?? '',
      caud: map['caud'] ?? '',
      csig: map['csig'] ?? '',
      cdoc: map['cdoc'] ?? '',
      cnot: map['cnot'] ?? '',
      dur: map['dur'] ?? '',
      val: map['val'] ?? '',
      rgn: map['rgn'] ?? '',
      upd: map['upd'] ?? '',
      by: map['by'] ?? '',
      znid: map['znid'] ?? '',
    );
  }
}

extension EventJson on Event {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cid': cid,
      'start_date': startDate,
      'etm': etm,
      'end_date': endDate,
      'name': name,
      'wkf': wkf,
      'alt': alt,
      'po': po,
      'inv': inv,
      'tid': tid,
      'pid': pid,
      'rid': rid,
      'ridcmt': ridcmt,
      'detail': detail,
      'lid': lid,
      'cntid': cntid,
      'flg': flg,
      'est': est,
      'lst': lst,
      'ctid': ctid,
      'ctpnm': ctpnm,
      'ltpnm': ltpnm,
      'cnm': cnm,
      'address': address,
      'geo': geo,
      'cntnm': cntnm,
      'tel': tel,
      'ordfld1': ordfld1,
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
}
