import 'package:ace_routes/core/colors/Constants.dart';
import 'package:ace_routes/database/Tables/event_table.dart';
import 'package:get/get.dart';
import '../database/Tables/status_table.dart';
import '../model/Status_model_database.dart';
import 'package:http/http.dart' as http;

import 'event_controller.dart';

class StatusControllers extends GetxController {
  var organizedData = <String, List<Status>>{}.obs;
  final EventController eventController = Get.put(EventController());
  RxString currentStatus = "".obs;
  RxString updatedWkf = "".obs;

  // Organize the data into groups
  Future<void> organizeData() async {
    List<Status> statusData = await StatusTable.fetchStatusData();
    Map<String, Status> groups = {}; // Holds groups by group sequence
    List<Status> items = []; // Holds non-group items

    // Step 1: Classify data into groups and non-group items
    for (var status in statusData) {
      if (status.isGroup == "1") {
        groups[status.groupId] = status; // Add groups to the map by groupId
      } else {
        items.add(status); // Add non-group items to the list
      }
    }

    // Step 2: Sort groups by their group sequence (grpseq)
    var sortedGroups = groups.values.toList()
      ..sort((a, b) => (int.tryParse(a.groupSequence) ?? 0)
          .compareTo(int.tryParse(b.groupSequence) ?? 0));

    // Step 3: Initialize the organizedData map with the groups
    var organizedDataTemp = <String, List<Status>>{};

    for (var group in sortedGroups) {
      organizedDataTemp[group.name] = [];
    }

    // Step 4: Add non-group items to their respective group
    for (var item in items) {
      var group = groups[item.groupId]; // Get the group based on groupId

      if (group != null) {
        organizedDataTemp[group.name]?.add(item);
      }
    }

    // Step 5: Sort the items inside each group by their seq value
    for (var groupName in organizedDataTemp.keys) {
      organizedDataTemp[groupName]!.sort((a, b) =>
          (int.tryParse(a.sequence) ?? 0)
              .compareTo(int.tryParse(b.sequence) ?? 0));
    }

    // Step 6: Update the RxMap to trigger the UI update
    organizedData.assignAll(organizedDataTemp);
  }

  Future<void> GetStatusUpdate(
      String oid, String oldWkf, String newWkf, String status) async {
    print(" oid $oid old wkf $oldWkf new wkf $newWkf  status $status");
    currentStatus.value = status;
    updatedWkf.value = newWkf;

    print(currentStatus.value);
    // print("currentStatus.value");
    String url =
        "https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=$geo&rid=$rid&action=saveorderfld&id=$oid&name=wkf&value=$newWkf&egeo=<lat,lon>&";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = response.body;
        print("Success ${response.statusCode}");
        print("Response $responseData");

        //-----------

        // Fetch the updated status from the database
        String? updatedStatus =
            await StatusTable.fetchNameById(newWkf); // Fetch new status
        if (updatedStatus != null) {
          eventController.nameMap[oldWkf] =
              updatedStatus; // Update the nameMap dynamically
          print("Updated status for new  wkf $newWkf: $updatedStatus");

          //update the wkf
        int value = await EventTable.updateOrder(oid , newWkf);

        print("updated value is $value");
        } else {
          print("No updated status found for old wkf $oldWkf");
        }
      } else {
        print("Error: Received status code ${response.statusCode}");
      }
    } catch (e) {
      print("Error:  ${e}");
    }
  }
}
