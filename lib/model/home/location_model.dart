import 'package:xml/xml.dart';

class Location {
  final String locationId;
  final String cityId;
  final String typeId;
  final String locationName;
  final String address;
  final String timeZone;
  final String geoCoordinates;
  final String zoneId;
  final int accessCount;
  final int archiveStatus;
  final String lastUpdateTimestamp;
  final String updatedBy;

  Location({
    required this.locationId,
    required this.cityId,
    required this.typeId,
    required this.locationName,
    required this.address,
    required this.timeZone,
    required this.geoCoordinates,
    required this.zoneId,
    required this.accessCount,
    required this.archiveStatus,
    required this.lastUpdateTimestamp,
    required this.updatedBy,
  });

  // Ensure this method is present inside the Location class
  factory Location.fromXml(XmlElement xml) {
    return Location(
      locationId: xml.findElements('id').single.text,
      cityId: xml.findElements('cid').single.text,
      typeId: xml.findElements('tid').single.text,
      locationName: xml.findElements('nm').single.text,
      address: xml.findElements('adr').single.text,
      timeZone: xml.findElements('tz').single.text,
      geoCoordinates: xml.findElements('geo').single.text,
      zoneId: xml.findElements('znid').isNotEmpty ? xml.findElements('znid').single.text : '',
      accessCount: int.parse(xml.findElements('gacc').single.text),
      archiveStatus: int.parse(xml.findElements('arc').single.text),
      lastUpdateTimestamp: xml.findElements('upd').single.text,
      updatedBy: xml.findElements('by').single.text,
    );
  }
}
