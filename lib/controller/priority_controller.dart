import 'dart:convert';
import 'package:ace_routes/core/colors/Constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../database/Tables/prority_table.dart';
import '../model/priority_model.dart';

class PriorityController extends GetxController {
  Future<void> getPriorityData() async {
    String url =
        "https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=<lat,lon>&rid=$rid&action=getprioritylist";

    try {
      final response = await http.get(Uri.parse(url));

      print("Raw API Response: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        String cleanResponse = response.body.trim();

        // Remove <data> and </data> if present
        if (cleanResponse.startsWith("<data>")) {
          cleanResponse = cleanResponse.replaceFirst("<data>", "").trim();
        }
        if (cleanResponse.endsWith("</data>")) {
          cleanResponse = cleanResponse.substring(0, cleanResponse.length - 7).trim();
        }

        // Now decode as JSON
        List<dynamic> jsonData = json.decode(cleanResponse);
        List<Priority> fetchedPriorities =
        jsonData.map((data) => Priority.fromJson(data)).toList();

        // Store in local database
        for (var priority in fetchedPriorities) {
          await PriorityTable.insertPriority(priority);
        }

        print("Priority data inserted successfully");
      } else {
        throw ("Something went wrong with priority data");
      }
    } catch (e) {
      print("Error: $e"); // Debugging
      throw ("Something went wrong with priority data: $e");
    }
  }
}
