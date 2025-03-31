import 'package:xml/xml.dart';

class LoginResponse {
  final String nsp;
  final String url;
  final String subkey;

  LoginResponse({
    required this.nsp,
    required this.url,
    required this.subkey,
  });

  // Factory method to create a LoginResponse from an XML string
  factory LoginResponse.fromXml(String xml) {
    final document = XmlDocument.parse(xml);

    final nspElement = document.findAllElements('nsp').isNotEmpty
        ? document.findAllElements('nsp').first
        : null;
    final urlElement = document.findAllElements('url').isNotEmpty
        ? document.findAllElements('url').first
        : null;
    final subkeyElement = document.findAllElements('subkey').isNotEmpty
        ? document.findAllElements('subkey').first
        : null;

    if (nspElement != null && urlElement != null && subkeyElement != null) {
      return LoginResponse(
        nsp: nspElement.text,
        url: urlElement.text,
        subkey: subkeyElement.text,
      );
    } else {
      throw Exception('Required XML elements are missing');
    }
  }

  // Convert the model to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'nsp': nsp,
      'url': url,
      'subkey': subkey,
    };
  }

  // Create a LoginResponse from a Map
  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      nsp: map['nsp'],
      url: map['url'],
      subkey: map['subkey'],
    );
  }
}
