import 'package:xml/xml.dart';

class City {
  final String cityId;
  final String cityName;
  final String typeId;
  final int openCount;
  final String activeCount;
  final int archiveStatus;
  final String geoCoordinates;
  final String address;
  final String zoneId;

  City({
    required this.cityId,
    required this.cityName,
    required this.typeId,
    required this.openCount,
    required this.activeCount,
    required this.archiveStatus,
    required this.geoCoordinates,
    required this.address,
    required this.zoneId,
  });

  factory City.fromXml(XmlElement xml) {
    return City(
      cityId: xml.findElements('id').single.text,
      cityName: xml.findElements('nm').single.text,
      typeId: xml.findElements('tid').single.text,
      openCount: int.parse(xml.findElements('ocnt').single.text),
      activeCount: xml.findElements('acnt').single.text == 'null' ? '' : xml.findElements('acnt').single.text,
      archiveStatus: int.parse(xml.findElements('arc').single.text),
      geoCoordinates: xml.findElements('geo').single.text,
      address: xml.findElements('adr').single.text,
      zoneId: xml.findElements('znid').isNotEmpty ? xml.findElements('znid').single.text : '',
    );
  }
}
