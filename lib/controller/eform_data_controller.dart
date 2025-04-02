import 'dart:convert';
import 'package:ace_routes/database/Tables/eform_data_table.dart';
import 'package:ace_routes/model/eform_data_model.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import '../core/colors/Constants.dart';
import '../database/Tables/event_table.dart';
import '../model/event_model.dart';
import 'event_controller.dart';

class EFormDataController extends GetxController {
  // Fetch EForm from the server and parse it

  var badgeCounts = <String, int>{}.obs;
  Future<List<EFormDataModel>?> fetchEForm() async {
    final List<Event> events = await EventTable.fetchEvents();
    if (events.isEmpty) {
      print('No events found.');
      return null;
    }

    final String eventId = events.first.id;

    final uri = Uri.parse(
        'https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=$geo&rid=$rid&action=getorderform&oid=$eventId');
    var request = http.Request('GET', uri);
    //  print('Fetching EForm URL: $uri');

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();

        // Debug: Print the raw XML data to inspect the response
        //  print('Raw Response Data: $responseData');

        // Parse XML to extract relevant data manually
        final xmlDoc = XmlDocument.parse(responseData);
        final Map<String, dynamic> jsonData = _parseXmlToJson(xmlDoc);

        // Debug: Print the parsed JSON data to inspect the structure
        //   print('Parsed JSON Data: ${json.encode(jsonData)}');

        // Check if the structure is as expected and contains 'ofrm'
        if (jsonData.containsKey('data') &&
            jsonData['data'] != null &&
            jsonData['data'] is Map) {
          final data = jsonData['data'];
          if (data.containsKey('ofrm') &&
              data['ofrm'] != null &&
              data['ofrm'] is List) {
            // Parse and save each 'ofrm' entry as an EForm
            List<EFormDataModel> eforms = [];
            for (var item in data['ofrm']) {
              EFormDataModel eform = EFormDataModel.fromJson(item);
              eforms.add(eform);
            }
            await saveEFormToTable(eforms); // Save all the forms
            return eforms;
          } else {
            print('Error: "ofrm" field not found or incorrect structure');
            return null;
          }
        } else {
          print('Error: Invalid structure or missing "data" field');
          return null;
        }
      } else {
        print('Error: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching EForm: $e');
      return null;
    }
  }

  // Method to manually parse XML data into JSON-like structure
  Map<String, dynamic> _parseXmlToJson(XmlDocument xmlDoc) {
    Map<String, dynamic> jsonData = {};

    try {
      // Extract data manually from the XML
      final dataElement = xmlDoc.findElements('data').firstOrNull;
      if (dataElement != null) {
        jsonData['data'] = _parseData(dataElement);
      }
    } catch (e) {
      print('Error while parsing XML to JSON: $e');
    }

    return jsonData;
  }

  // Helper method to parse 'data' element in XML and map it to JSON-like format
  Map<String, dynamic> _parseData(XmlElement dataElement) {
    Map<String, dynamic> data = {};

    // Parse specific fields like 'ofrm' here based on XML structure
    final ofrmElements = dataElement.findElements('ofrm');
    if (ofrmElements.isNotEmpty) {
      data['ofrm'] = _parseOfrm(ofrmElements);
    }

    return data;
  }

  // Helper method to parse 'ofrm' elements from XML and return a list of maps
  List<Map<String, dynamic>> _parseOfrm(Iterable<XmlElement> ofrmElements) {
    List<Map<String, dynamic>> ofrmList = [];

    for (var ofrmElement in ofrmElements) {
      Map<String, dynamic> ofrmData = {};

      // Extract and parse fields
      ofrmData['id'] = ofrmElement.getElement('id')?.text ?? '';
      ofrmData['oid'] = ofrmElement.getElement('oid')?.text ?? '';
      ofrmData['ftid'] = ofrmElement.getElement('ftid')?.text ?? '';
      ofrmData['frmKey'] = ofrmElement.getElement('frmkey')?.text ?? '';

      // Extract and process 'fdata'
      final fdataElement = ofrmElement.getElement('fdata');
      if (fdataElement != null) {
        final fdataJsonString = fdataElement.text.trim();
        if (fdataJsonString.isNotEmpty) {
          try {
            final fdataJson = json.decode(fdataJsonString);
            if (fdataJson is Map) {
              ofrmData['formFields'] = fdataJson; // Ensure it's a Map
            } else {
              print('Warning: fdataJson is not a Map');
              ofrmData['formFields'] = {};
            }
          } catch (e) {
            print('Error while parsing fdata JSON: $e');
            ofrmData['formFields'] = {};
          }
        } else {
          print('Warning: fdata JSON string is empty or null');
          ofrmData['formFields'] = {};
        }
      } else {
        print('Warning: fdata element is null');
        ofrmData['formFields'] = {};
      }

      ofrmList.add(ofrmData);
    }

    return ofrmList;
  }

  // Save the EForm data into the local database (ensure that formFields are properly encoded)
  Future<void> saveEFormToTable(List<EFormDataModel> eforms) async {
    try {
      // Insert multiple EForms into the database
      await EFormDataTable.insertMultipleEForms(eforms);
      //  print('Multiple EForms successfully saved to the database.');
    } catch (e) {
      print('Error while saving EForms to the database: $e');
    }
  }

  Future<void> fetchBadgeCount(String tid) async {
    int count = await EFormDataTable.getEFormCountByTid(tid);
    badgeCounts[tid] = count;
  }
}
