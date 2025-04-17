import 'package:ace_routes/controller/connectivity/network_controller.dart';
import 'package:ace_routes/database/Tables/order_note_table.dart';
import 'package:ace_routes/database/offlineTables/vehicle_sync_table.dart';
import 'package:ace_routes/model/order_note_model.dart';
import 'package:ace_routes/view/home_screen.dart';
import 'package:get/get.dart';
import '../core/colors/Constants.dart';
import '../database/Tables/event_table.dart';
import '../model/event_model.dart';
import 'event_controller.dart';
import 'package:http/http.dart' as http;

class VehicleController extends GetxController {
  final EventController eventController = Get.put(EventController());
  final NetworkController networkController = Get.find<NetworkController>();
  final String id; //order id
  VehicleController(this.id);

  // Collecting summary data
  RxString vehicleDetail = "".obs;
  RxString registration = "".obs;
  RxString odometer = "".obs;
  RxString faultDesc = "".obs;
  RxString notes = "".obs;

  //for api call
  String wkf = '';
  String cid = "";
  String pid = "";
  String tid = "";
  String star_date = "";
  String end_date = "";
  String nm = "";

  onInit() async {
    super.onInit();
    GetVehicleDetails();
  }

  Future<void> GetVehicleDetails() async {
    try {
      // Fetch data from the database
      Event? localEvent = await EventTable.fetchEventById(id);
      List<OrderNoteModel> dbNote = await OrderNoteTable.fetchOrderNote();
      print("dbNote noted $dbNote");
      // Debugging fetched notes
      if (dbNote.isNotEmpty) {
        //this data is from Note DataTable
        String formattedNotes =
            dbNote.first.data.replaceAll("\\n", "\n").replaceAll('"', '');
        print("formated noted $formattedNotes");
        notes.value = formattedNotes;
      } else {
        print("No notes found in the database.");
        notes.value = "No notes available.";
      }

      // Populate vehicle details
      if (localEvent != null) {
        //this data is coming from event database
        vehicleDetail.value = localEvent.dtl;
        registration.value = localEvent.po;
        odometer.value = localEvent.inv;
        faultDesc.value = localEvent.alt;

        //for edit api call data
        wkf = localEvent.wkf;

        cid = localEvent.cid;

        pid = localEvent.pid;

        tid = localEvent.tid;
        star_date = localEvent.start_date;
        end_date = localEvent.end_date;
        nm = localEvent.nm;

        print(
            "wkf for edit: ${wkf} $nm  ${vehicleDetail.value} ${notes.value} ${localEvent.nm}");
      } else {
        print("No event data found for ID 77611.");
      }
    } catch (e) {
      print("Error in GetVehicleDetails: $e");
    }
  }

  //Edit controller .........................
  Future<void> edit(Map<String, String> updatedData,
      {bool fromSync = false}) async {
    print("wkf for edit: ${wkf} $nm  ${vehicleDetail.value} ${notes.value}");
    // print("wkf in edit $wkf");
    // print("Updated Data: $updatedData  ${updatedData['faultDesc']}");
    final url =
        "https://$baseUrl/mobi?token=$token&nspace=demo.com&geo=$geo&rid=$rid&action=editorder&id=$id&cid=$cid&wkf=$wkf&egeo=$geo&stmp=2700000&orderStartTime=39600000&orderEndTime=42300000&start_date=$star_date&end_date=$end_date&nm=$nm&dtl=${updatedData['details']}&alt=${updatedData['faultDesc']}&po=${updatedData['registration']}&inv=${updatedData['odometer']}&tid=$tid&pid=$pid&xml=0&note=${updatedData['notes']}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // print(response.body);
        // print("edit success");

        //update the database with current data
        EventTable.updateVehicle(id, updatedData);
        eventController.loadEventsFromDatabase();
        if (!fromSync) {
          print("online:::::");
          Get.back();
        }

        print("offline sync:::::");
      }
    } catch (e) {
      print("Editable is $e");
    }
  }

  Future<void> offlineEdit(Map<String, String> updatedData,
      {bool fromSync = false}) async {
    //update the database with current data
    print(
        "wkf for ccccedit: ${wkf} $nm  ${vehicleDetail.value} ${notes.value}");
    EventTable.updateVehicle(id, updatedData);
    eventController.loadEventsFromDatabase();
    print("something :::");
    if (networkController.isOnline.value == false) {
      print("User is offline so updaing in database");
      VehicleSyncTable.insert(id, updatedData);
      // EventTable.updateVehicle(id, updatedData);
      // eventController.loadEventsFromDatabase();

      Get.back();
      print("offline mode:::");
      return;
    }
    final url =
        "https://$baseUrl/mobi?token=$token&nspace=demo.com&geo=$geo&rid=$rid&action=editorder&id=$id&cid=$cid&wkf=$wkf&egeo=$geo&stmp=2700000&orderStartTime=39600000&orderEndTime=42300000&start_date=$star_date&end_date=$end_date&nm=&dtl=${updatedData['details']}&alt=${updatedData['faultDesc']}&po=${updatedData['registration']}&inv=${updatedData['odometer']}&tid=$tid&pid=$pid&xml=0&note=${updatedData['notes']}";
    print("something 2:::");
    try {
      print("something 3 :::");
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print(response.body);
        print("edit success");

        //update the database with current data
        // EventTable.updateVehicle(id, updatedData);
        // eventController.loadEventsFromDatabase();
        if (!fromSync) {
          print("online:::::");
          Get.back();
        }

        print("offline sync:::::");
      }
    } catch (e) {
      print("Editable is $e");
    }
  }
}
