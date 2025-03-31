import 'package:xml/xml.dart';

class Contact {
  final String contactId;
  final String cityId;
  final String contactName;
  final String phoneNumber;
  final String typeId;
  final String email;
  final String externalId;
  final String lastUpdateTimestamp;
  final String updatedBy;

  Contact({
    required this.contactId,
    required this.cityId,
    required this.contactName,
    required this.phoneNumber,
    required this.typeId,
    required this.email,
    required this.externalId,
    required this.lastUpdateTimestamp,
    required this.updatedBy,
  });

  factory Contact.fromXml(XmlElement xml) {
    return Contact(
      contactId: xml.findElements('id').single.text,
      cityId: xml.findElements('cid').single.text,
      contactName: xml.findElements('nm').single.text,
      phoneNumber: xml.findElements('tel').single.text,
      typeId: xml.findElements('ttid').single.text,
      email: xml.findElements('eml').isNotEmpty ? xml.findElements('eml').single.text : '',
      externalId: xml.findElements('xid').isNotEmpty ? xml.findElements('xid').single.text : '',
      lastUpdateTimestamp: xml.findElements('upd').single.text,
      updatedBy: xml.findElements('by').single.text,
    );
  }
}
