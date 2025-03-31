import 'package:xml/xml.dart' as xml;

// Function to convert XML to JSON
Map<String, dynamic> xmlToJson(String xmlString) {
  final document = xml.XmlDocument.parse(xmlString);

 // print("xml string $xmlString");

  // We need to return the children of the root element <data>
  return _xmlNodeToJson(document.rootElement);
}

// Helper function to convert XML node to JSON
Map<String, dynamic> _xmlNodeToJson(xml.XmlNode node) {
  final Map<String, dynamic> jsonMap = {};

  // Iterate over the children of the node
  for (var child in node.children) {
    if (child is xml.XmlElement) {
      // Get the text value of the element directly
      String childName = child.name.toString();
      String childValue = child.text.trim();  // Extract the text and trim spaces

      if (childValue.isNotEmpty) {
        jsonMap[childName] = childValue;
      }
    }
  }

  return jsonMap;
}
