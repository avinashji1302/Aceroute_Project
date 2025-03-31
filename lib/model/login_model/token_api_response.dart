import 'package:xml/xml.dart';

class TokenApiReponse {
  final String requestId;
  final String responderName;
  final String geoLocation;
  final String nspId;
  final String gpsSync;
  final String locationChange;
  final String shiftDateLock;
  final String shiftError;
  final String endValue;
  final String speed;
  final String multiLeg;
  final String uiConfig;
  final String token;

  TokenApiReponse({
    required this.requestId,
    required this.responderName,
    required this.geoLocation,
    required this.nspId,
    required this.gpsSync,
    required this.locationChange,
    required this.shiftDateLock,
    required this.shiftError,
    required this.endValue,
    required this.speed,
    required this.multiLeg,
    required this.uiConfig,
    required this.token,
  });

  // Convert a TokenApiReponse object into a Map.
  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'responderName': responderName,
      'geoLocation': geoLocation,
      'nspId': nspId,
      'gpsSync': gpsSync,
      'locationChange': locationChange,
      'shiftDateLock': shiftDateLock,
      'shiftError': shiftError,
      'endValue': endValue,
      'speed': speed,
      'multiLeg': multiLeg,
      'uiConfig': uiConfig,
      'token': token,
    };
  }

  // Extract a TokenApiReponse object from a Map.
  factory TokenApiReponse.fromMap(Map<String, dynamic> map) {
    return TokenApiReponse(
      requestId: map['requestId']?.toString() ?? '',
      responderName: map['responderName']?.toString() ?? '',
      geoLocation: map['geoLocation']?.toString() ?? '',
      nspId: map['nspId']?.toString() ?? '',
      gpsSync: map['gpsSync']?.toString() ?? '',
      locationChange: map['locationChange']?.toString() ?? '',
      shiftDateLock: map['shiftDateLock']?.toString() ?? '',
      shiftError: map['shiftError']?.toString() ?? '',
      endValue: map['endValue']?.toString() ?? '',
      speed: map['speed']?.toString() ?? '',
      multiLeg: map['multiLeg']?.toString() ?? '',
      uiConfig: map['uiConfig']?.toString() ?? '',
      token: map['token']?.toString() ?? '',
    );
  }

  factory TokenApiReponse.fromXml(XmlElement xml) {
    return TokenApiReponse(
      requestId: xml.findElements('rid').isNotEmpty ? xml.findElements('rid').first.text : '',
      responderName: xml.findElements('resnm').isNotEmpty ? xml.findElements('resnm').first.text : '',
      geoLocation: xml.findElements('geo').isNotEmpty ? xml.findElements('geo').first.text : '',
      nspId: xml.findElements('nspid').isNotEmpty ? xml.findElements('nspid').first.text : '',
      gpsSync: xml.findElements('gpssync').isNotEmpty ? xml.findElements('gpssync').first.text : '',
      locationChange: xml.findElements('locchg').isNotEmpty ? xml.findElements('locchg').first.text : '',
      shiftDateLock: xml.findElements('shfdtlock').isNotEmpty ? xml.findElements('shfdtlock').first.text : '',
      shiftError: xml.findElements('shfterr').isNotEmpty ? xml.findElements('shfterr').first.text : '',
      endValue: xml.findElements('edn').isNotEmpty ? xml.findElements('edn').first.text : '',
      speed: xml.findElements('spd').isNotEmpty ? xml.findElements('spd').first.text : '',
      multiLeg: xml.findElements('mltleg').isNotEmpty ? xml.findElements('mltleg').first.text : '',
      uiConfig: xml.findElements('uiconfig').isNotEmpty ? xml.findElements('uiconfig').first.text : '',
      token: xml.findElements('token').isNotEmpty ? xml.findElements('token').first.text : '',
    );
  }
}
