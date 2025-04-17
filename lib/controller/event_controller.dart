import 'dart:convert';

import 'package:ace_routes/controller/background/location_service.dart';
import 'package:ace_routes/controller/clockout/clockout_controller.dart';
import 'package:ace_routes/controller/connectivity/dependecy_injection.dart';
import 'package:ace_routes/controller/connectivity/network_controller.dart';
import 'package:ace_routes/controller/eform_controller.dart';
import 'package:ace_routes/controller/getOrderPart_controller.dart';
import 'package:ace_routes/controller/priority_controller.dart';
import 'package:ace_routes/database/Tables/OrderTypeDataTable.dart';
import 'package:ace_routes/database/Tables/event_table.dart';
import 'package:ace_routes/database/Tables/prority_table.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart' as xml;

import '../core/Constants.dart';
import '../core/colors/Constants.dart';
import '../core/xml_to_json_converter.dart';
import '../database/Tables/status_table.dart';
import '../database/databse_helper.dart';
import '../model/event_model.dart';
import '../model/login_model/token_api_response.dart';
import 'all_terms_controller.dart';
import 'orderNoteConroller.dart';

class EventController extends GetxController {
  final allTermsController = Get.put(AllTermsController());
  final getOrderPart = Get.put(GetOrderPartController());
  final OrderNoteController orderNoteController =
      Get.put(OrderNoteController());

  final EFormController eForm = Get.put(EFormController());
  final PriorityController priority = Get.put(PriorityController());

  final ClockOut clockOut = Get.put(ClockOut());

  var events = <Event>[].obs;
  var isLoading = false.obs;
  // String wkf = "";
  // String tid = '';
  int daysToAdd = 1;
  RxString currentStatus = "Loading...".obs; // Reactive variable
  //RxString categoryName = "".obs;

  var nameMap = <String, String?>{}.obs; // Observable map
  var categoryMap = <String, String?>{}.obs; // Observable map
  var priorityId = <String, String?>{}.obs;
  var priorityColorsId = <String, String?>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    isLoading(true); // Show loading spinner
    await loadAllTerms();
    await fetchEvents();
    isLoading(false); // Show loading spinner

    // if (await hasInternet()) {
    //   print(hasInternet());
    //   print("INternet is here ::: calling the api");
    //   await fetchEvents(); // API call
    // } else {
    //   print("INternet is here ::: calling the api offline mode ");
    //   await loadEventsFromDatabase(); // Local fallback
    // }

    //Fetching and saving note in db
    await orderNoteController.fetchDetailsFromDb();
    await orderNoteController.fetchOrderNotesFromApi();

    //  await eForm.GetGenOrderDataForForm();
    await initializeService(); // Start background service
    await clockOut.executeAction(tid: 1);

    Get.find<NetworkController>().enableSyncAfterLogin();
  }

  // Future<bool> hasInternet() async {
  //   final result = await Connectivity().checkConnectivity();
  //   return result != ConnectivityResult.none;
  // }

  Future<void> loadAllTerms() async {
    //print("Loading all terms...");

    await allTermsController.fetchStatusList();
    await allTermsController.fetchAndStoreOrderTypes();
    await allTermsController.displayLoginResponseData();
    Database db = await DatabaseHelper().database;
    await allTermsController.GetAllPartTypes();

    await allTermsController.fetchAndStoreGTypes(db);
    await allTermsController.GetAllTerms();

    await AllTerms.getTerm();

    await priority.getPriorityData();
  }

  Future<void> fetchEvents() async {
    //print("object");
    DateTime currentDate = DateTime.now();
    DateTime secondDate = currentDate.add(Duration(days: daysToAdd));
    String formattedCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    String formattedSecondDate = DateFormat('yyyy-MM-dd').format(secondDate);

    isLoading(true);
    var url =
        "https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=$geo&rid=$rid&action=getorders&tz=Asia/Kolkata&from=${formattedCurrentDate}&to=${formattedSecondDate}";

    print("Fetching events from URL: $url");

    try {
      var request = http.Request('GET', Uri.parse(url));
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String xmlString = await response.stream.bytesToString();
        print("Raw XML response: $xmlString");

        // Parse and store the events
        parseXmlResponse(xmlString);
        await loadEventsFromDatabase();
      } else {
        print("Error fetching events: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading(false);
    }
  }

  void parseXmlResponse(String responseBody) {
    final document = xml.XmlDocument.parse(responseBody);
    final eventElements = document.findAllElements('event');

    List<Event> fetchedEvents = eventElements.map((eventElement) {
      return Event(
        id: _getText(eventElement, 'id'),
        cid: _getText(eventElement, 'cid'),
        start_date: _getText(eventElement, 'start_date'),
        etm: _getText(eventElement, 'etm'),
        end_date: _getText(eventElement, 'end_date'),
        nm: _getText(eventElement, 'nm'),
        wkf: _getText(eventElement, 'wkf'),
        alt: _getText(eventElement, 'alt'),
        po: _getText(eventElement, 'po'),
        inv: _getText(eventElement, 'inv'),
        tid: _getText(eventElement, 'tid'),
        pid: _getText(eventElement, 'pid'),
        rid: _getText(eventElement, 'rid'),
        ridcmt: _getText(eventElement, 'ridcmt'),
        dtl: _getText(eventElement, 'dtl'),
        lid: _getText(eventElement, 'lid'),
        cntid: _getText(eventElement, 'cntid'),
        flg: _getText(eventElement, 'flg'),
        est: _getText(eventElement, 'est'),
        lst: _getText(eventElement, 'lst'),
        ctid: _getText(eventElement, 'ctid'),
        ctpnm: _getText(eventElement, 'ctpnm'),
        ltpnm: _getText(eventElement, 'ltpnm'),
        cnm: _getText(eventElement, 'cnm'),
        address: _getText(eventElement, 'adr'),
        geo: _getText(eventElement, 'geo'),
        cntnm: _getText(eventElement, 'cntnm'),
        tel: _getText(eventElement, 'tel'),
        ordfld1: _getText(eventElement, 'ordfld1'),
        ttid: _getText(eventElement, 'ttid'),
        cfrm: _getText(eventElement, 'cfrm'),
        cprt: _getText(eventElement, 'cprt'),
        xid: _getText(eventElement, 'xid'),
        cxid: _getText(eventElement, 'cxid'),
        tz: _getText(eventElement, 'tz'),
        zip: _getText(eventElement, 'zip'),
        fmeta: _getText(eventElement, 'fmeta'),
        cimg: _getText(eventElement, 'cimg'),
        caud: _getText(eventElement, 'caud'),
        csig: _getText(eventElement, 'csig'),
        cdoc: _getText(eventElement, 'cdoc'),
        cnot: _getText(eventElement, 'cnot'),
        dur: _getText(eventElement, 'dur'),
        val: _getText(eventElement, 'val'),
        rgn: _getText(eventElement, 'rgn'),
        upd: _getText(eventElement, 'upd'),
        by: _getText(eventElement, 'by'),
        znid: _getText(eventElement, 'znid'),
      );
    }).toList();

    for (Event event in fetchedEvents) {
      //  //print("Event is ${event.geo}");
      EventTable.insertEvent(event);
      // //print("Event added to database: ${event.toJson()['id']}");
    }

    events.assignAll(fetchedEvents);
    // //print("Fetched and stored ${fetchedEvents.length} events");
  }

  String _getText(xml.XmlElement element, String tagName) {
    return element.findElements(tagName).isNotEmpty
        ? element.findElements(tagName).single.text
        : '';
  }

  Future<void> loadEventsFromDatabase() async {
    isLoading(true);
    try {
      List<Event> localEvents = await EventTable.fetchEvents();
      events.assignAll(localEvents);
      //  //print("Loaded ${localEvents.length} events from database");

      // Extract unique wkf and tid values
      Set<String> wkfSet = localEvents.map((event) => event.wkf).toSet();
      Set<String> tidSet = localEvents.map((event) => event.tid).toSet();
      Set<String> pidSet = localEvents.map((event) => event.pid).toSet();

      //print("pidSet $pidSet");
      // Fetch all names and categories in batch
      Map<String, String?> FetchedStatus =
          await StatusTable.fetchNamesByIds(wkfSet.toList());

      Map<String, String?> fetchedCategory =
          await OrderTypeDataTable.fetchCategoriesByIds(tidSet.toList());

      Map<String, String?> fetchedValuePid =
          await PriorityTable.fetchPrioritiesByIds(pidSet.toList());
      Map<String, String?> fetchedColorPid =
          await PriorityTable.fetchPrioritiesColorsByIds(pidSet.toList());

      // Update status and categories dynamically
      nameMap.value = await FetchedStatus;
      categoryMap.value = await fetchedCategory;
      priorityId.value = await fetchedValuePid;
      priorityColorsId.value = await fetchedColorPid;
    } catch (e) {
      print("Error loading events from database: $e");
    } finally {
      isLoading(false);
    }
  }
}
