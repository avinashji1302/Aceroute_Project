import 'dart:convert';

import 'package:ace_routes/core/xml_to_json_converter.dart';
import 'package:get/get.dart';
import '../core/Constants.dart';
import '../core/colors/Constants.dart';
import '../database/Tables/api_data_table.dart';
import '../database/Tables/event_table.dart';
import '../database/Tables/login_response_table.dart';
import '../model/event_model.dart';
import '../model/login_model/login_response.dart';
import '../model/login_model/token_api_response.dart';
import '../model/order_note_model.dart';
import '../database/Tables/order_note_table.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

import 'event_controller.dart';

class OrderNoteController extends GetxController {
  String oid = "";

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchOrderNotesFromApi() async {
    final apiUrl =
        "https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=%3Clat,lon%3E&rid=$rid&action=getordernotes&oid=$oid";

    //  print("API URL: $apiUrl");

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // print("Raw XML response: ${response.body}");

        // Parse XML and convert to JSON manually
        final document = XmlDocument.parse(response.body);
        final dataElement = document.findAllElements('data').first.text.trim();
        final jsonResponse = jsonEncode(dataElement);

      //  print("Converted JSON: ${jsonResponse}");

        // Save to the local database
        final orderNote = OrderNoteModel(data: jsonResponse);
        await OrderNoteTable.insertOrderNote(orderNote);

        print("Note is inserted successfully");
      } else {
        print("Failed to fetch order notes: ${response.statusCode}");
      }
    } catch (e) {
      print("Error parsing order notes: $e");
    }
  }

  Future<void> fetchDetailsFromDb() async {
    List<TokenApiReponse> tokenDbData = await ApiDataTable.fetchData();
    List<LoginResponse> nspDbData =
        await LoginResponseTable.fetchLoginResponses();
    List<Event> eventDbData = await EventTable.fetchEvents();
    for (var data in eventDbData) {
      oid = data.id;
      //  print("oid $oid");
    }

    //print("data respectively : $oid , $token, $geo ,$rid");
  }
}
