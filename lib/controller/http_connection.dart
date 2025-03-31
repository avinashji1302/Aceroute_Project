// import 'package:ace_routes/core/colors/Constants.dart';
// import 'package:http/http.dart' as http;
// import 'package:xml/xml.dart' as xml;
//
// class HttpConnection {
//   String str = "Avinash";
//
//
//   void fetchData() async {
//     final url = 'https://$baseUrl/mobi?action=getterm';
//     print('Fetching data...');
//
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         // Corrected XML parsing method
//         final document = xml.XmlDocument.parse(response.body);
//         print('Parsed XML Data: $document');
//
//         // Example: Extracting values
//         final success = document.findAllElements('success').first.text;
//         final id = document.findAllElements('id').first.text;
//
//         print('Success: $success, ID: $id');
//       } else {
//         print('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
// }
