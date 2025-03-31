import 'dart:convert';
import 'package:ace_routes/core/Constants.dart';
import 'package:ace_routes/core/xml_to_json_converter.dart';
import 'package:ace_routes/database/Tables/OrderTypeDataTable.dart';
import 'package:ace_routes/database/Tables/login_response_table.dart';
import 'package:ace_routes/database/Tables/terms_data_table.dart';
import 'package:ace_routes/model/OrderTypeModel.dart';
import 'package:ace_routes/model/login_model/login_response.dart';
import 'package:ace_routes/model/login_model/token_api_response.dart';
import 'package:ace_routes/model/terms_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';
import '../core/colors/Constants.dart';
import '../database/Tables/genTypeTable.dart';
import '../database/Tables/PartTypeDataTable.dart';
import '../database/Tables/api_data_table.dart';
import '../database/Tables/status_table.dart';
import '../model/GTypeModel.dart';
import '../model/Ptype.dart';
import '../model/Status_model_database.dart';

class AllTermsController {

   String accountName = "";
   String workerRid = "";
   String url = "";





  String getElementText(XmlDocument xml, String tagName) {
    final elements = xml.findAllElements(tagName);
    return elements.isNotEmpty ? elements.single.text : '';
  }

  Future<void> GetAllTerms() async {

    final requestUrl =
        "https://$baseUrl/mobi?token=$token&nspace=${nsp}&geo=$geo&rid=$rid&action=getterm";
   // print(" Step 4 call 1 Default label : get term URL: ${requestUrl}");

    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      // Map<String, dynamic> jsonResponse = xmlToJson(response.body);
      // print(' Converted JSON Response: ${jsonEncode(jsonResponse)}');

       final xmlResponse = XmlDocument.parse(response.body);


      // Extracting XML data safely
      final termsDataMap = {
        "namespace": getElementText(xmlResponse, 'nsp'),
        "locationCode": getElementText(xmlResponse, 'lofc'),
        "formName": getElementText(xmlResponse, 'lfrm'),
        "partName": getElementText(xmlResponse, 'lprt'),
        "assetName": getElementText(xmlResponse, 'lass'),
        "pictureLabel": getElementText(xmlResponse, 'lpic'),
        "audioLabel": getElementText(xmlResponse, 'laud'),
        "signatureLabel": getElementText(xmlResponse, 'lsig'),
        "fileLabel": getElementText(xmlResponse, 'lfil'),
        "workLabel": getElementText(xmlResponse, 'lwrk'),
        "customerLabel": getElementText(xmlResponse, 'lcst'),
        "orderLabel": getElementText(xmlResponse, 'lord'),
        "customerReferenceLabel": getElementText(xmlResponse, 'lordnm'),
        "registrationLabel": getElementText(xmlResponse, 'lpo'),
        "odometerLabel": getElementText(xmlResponse, 'linv'),
        "detailsLabel": getElementText(xmlResponse, 'ldtl'),
        "faultDescriptionLabel": getElementText(xmlResponse, 'lalt'),
        "notesLabel": getElementText(xmlResponse, 'lnot'),
        "summaryLabel": getElementText(xmlResponse, 'lsum'),
        "orderGroupLabel": getElementText(xmlResponse, 'lordgrp'),
        "fieldOrderRules": getElementText(xmlResponse, 'fldordrls'),
        "invoiceEmailLabel": getElementText(xmlResponse, 'lordfld1'),
      };

      // Convert map to JSON string and print it
      final jsonString = jsonEncode(termsDataMap);

     // print("GetTerms Data JSON: $jsonString");

      // Insert terms data into the database
      TermsDataModel termsDataModel = TermsDataModel(
        namespace: termsDataMap["namespace"]!,
        locationCode: termsDataMap["locationCode"]!,
        formName: termsDataMap["formName"]!,
        partName: termsDataMap["partName"]!,
        assetName: termsDataMap["assetName"]!,
        pictureLabel: termsDataMap["pictureLabel"]!,
        audioLabel: termsDataMap["audioLabel"]!,
        signatureLabel: termsDataMap["signatureLabel"]!,
        fileLabel: termsDataMap["fileLabel"]!,
        workLabel: termsDataMap["workLabel"]!,
        customerLabel: termsDataMap["customerLabel"]!,
        orderLabel: termsDataMap["orderLabel"]!,
        customerReferenceLabel: termsDataMap["customerReferenceLabel"]!,
        registrationLabel: termsDataMap["registrationLabel"]!,
        odometerLabel: termsDataMap["odometerLabel"]!,
        detailsLabel: termsDataMap["detailsLabel"]!,
        faultDescriptionLabel: termsDataMap["faultDescriptionLabel"]!,
        notesLabel: termsDataMap["notesLabel"]!,
        summaryLabel: termsDataMap["summaryLabel"]!,
        orderGroupLabel: termsDataMap["orderGroupLabel"]!,
        fieldOrderRules: termsDataMap["fieldOrderRules"]!,
        invoiceEmailLabel: termsDataMap["invoiceEmailLabel"]!,
      );

      await TermsDataTable.insertTermsData(termsDataModel);
     // print('  Terms data Successfully added to the database');
    } else {
      Get.snackbar('Error', 'Failed to fetch terms data');
    }
  }

  /// getparttype API to save the data ----------------------------

   Future<void> GetAllPartTypes() async {
     final requestUrl =
         "https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=<lat,lon>&rid=$rid&action=getparttype";
     final response = await http.get(Uri.parse(requestUrl));

     if (response.statusCode == 200) {
     //  print("Step 4 call 2 Default Part Type : get term URL: $requestUrl");
       final xmlResponse = XmlDocument.parse(response.body);

       final partTypesList = xmlResponse.findAllElements('ptype').map((element) {
         try {
           return PartTypeDataModel(
             id: element.findElements('id').single.text,
             name: element.findElements('nm').single.text,
             detail: element.findElements('dtl').single.text,
             unitPrice: element.findElements('upr').single.text,
             unit: element.findElements('unt').single.text,
             updatedBy: element.findElements('by').single.text,
             updatedDate: element.findElements('upd').single.text,
           );
         } catch (e) {
           print("Error parsing element: $e");
           return null;
         }
       }).whereType<PartTypeDataModel>().toList();

    //   print("Number of part types found: ${partTypesList.length}");

       for (var partType in partTypesList) {
         await PartTypeDataTable.insertPartTypeData(partType);
       }

     //  print('Successfully added part type data to the database');
     } else {
       print("Failed to load parttype data: ${response.reasonPhrase}");
     }
   }


  /// getStoreOrderTypes API to save the data ----------------------------

   Future<void> fetchAndStoreOrderTypes() async {
     try {
       final requestUrl = 'https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=<lat,lon>&rid=$rid&action=getordertype';
       final request = http.Request('GET', Uri.parse(requestUrl));
       final response = await request.send();

       if (response.statusCode == 200) {
         final responseBody = await response.stream.bytesToString();
         final document = xml.XmlDocument.parse(responseBody);
         final otypes = document.findAllElements('otype');

         List<Map<String, dynamic>> orderTypesList = [];
         for (var otype in otypes) {
           var orderTypeMap = {
             "id": otype.findElements('id').single.text,
             "name": otype.findElements('nm').single.text,
             "abbreviation": otype.findElements('abr').single.text,
             "duration": otype.findElements('dur').single.text,
             "capacity": otype.findElements('cap').single.text,
             "parentId": otype.findElements('pid').single.text,
             "customTimeSlot": otype.findElements('ctmslot').single.text,
             "elapseTimeSlot": otype.findElements('eltmslot').single.text,
             "value": otype.findElements('val').single.text,
             "externalId": otype.findElements('xid').isNotEmpty ? otype.findElements('xid').single.text : '',
             "updateTimestamp": otype.findElements('upd').single.text,
             "updatedBy": otype.findElements('by').single.text,
           };

           orderTypesList.add(orderTypeMap);

           // Insert into database
           await OrderTypeDataTable.insertOrderTypeData(OrderTypeModel.fromMap(orderTypeMap));
         }

      //   print("Order types stored successfully.");
       } else {
         print('Request failed with status: ${response.reasonPhrase}');
       }
     } catch (e) {
       print("Error in fetchAndStoreOrderTypes: $e");
     }
   }



   //--------------status type--------------
  Future<void> fetchStatusList() async {

    final String url =
        'https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=<lat,lon>&rid=$rid&action=getstatuslist';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
       // print(" Step 4 call 5  status Type :  URL: $url");
        // Convert XML response to JSON list
        final statusJsonList = parseStatusListToJson(response.body);


    //   print("Converted json::: $statusJsonList");
        // Save JSON data to database
        await StatusTable.insertStatusList(statusJsonList);

       // print(" status is Data saved to database successfully");
      } else {
        Get.snackbar('Error', 'Failed to fetch status list');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: $e');
    }
  }


  /// getStoreGTypes API to save the data ----------------------------

  Future<void> fetchAndStoreGTypes(Database db) async {

    final requestUrl ='https://$baseUrl/mobi?token=$token&nspace=${nsp}&geo=<lat,lon>&rid=$rid&action=getgentype';
    var request = http.Request(
      'GET',
      Uri.parse(
          requestUrl
      ),
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    //  print(" Step 4 call 6 Default Get Gen Type :  URL: $requestUrl");
      String responseBody = await response.stream.bytesToString();

      // Parse the XML response
      var document = xml.XmlDocument.parse(responseBody);
      var gtypes = document.findAllElements('gtype');

     // print("document of g type :$document");
      // Convert XML to JSON
      List<Map<String, dynamic>> gtypesList = [];

      for (var gtype in gtypes) {
        try {
          var dtlElement = gtype.findElements('dtl').single;
          var details = dtlElement.children.isNotEmpty
              ? dtlElement.children.first.value?.trim()
              : '';

          var gTypeMap = {
            'id': gtype.findElements('id').single.text.trim(),
            'name': gtype.findElements('nm').single.text.trim(),
            'typeId': gtype.findElements('tid').single.text.trim(),
            'capacity': gtype.findElements('cap').single.text.trim(),
            'details': details,
            'externalId': gtype.findElements('xid').isEmpty
                ? ''
                : gtype.findElements('xid').single.text.trim(),
            'updateTimestamp':
            gtype.findElements('upd').single.text.trim(),
            'updatedBy': gtype.findElements('by').single.text.trim(),
          };

        //  print("Parsed gtype: $gTypeMap");
          gtypesList.add(gTypeMap);
        } catch (e) {
          print("Error parsing gtype: $e");
        }
      }


      // // Convert the list of maps (gtypesList) to JSON
      // String jsonString = jsonEncode(gtypesList);
      //
      // // Print the JSON string
      // print("Converted JSON:\n$jsonString");

      // Clear existing data
    //  await GTypeTable.clearTable();

     // saveGTypesToDatabase(gtypesList);
      // Save each gtype entry to the table
      for (var gTypeMap in gtypesList) {
     //   print("G type data here ::: $gTypeMap");
        var gTypeModel = GTypeModel.fromJson(gTypeMap);
        await GTypeTable.insertGType( gTypeModel);
      }

   //   print('GType data inserted successfully');
    } else {
      print("Failed to fetch data. HTTP Status Code: ${response.statusCode}");
      String errorResponse = await response.stream.bytesToString();
      print("Error Response Body: $errorResponse");
    }
  }

  Future<void> displayLoginResponseData() async {
    // Fetch the list of login responses from the database
    List<LoginResponse> dataList =
        await LoginResponseTable.fetchLoginResponses();

    // Optionally print each field separately
    for (var data in dataList) {
      accountName = data.nsp;
      url = data.url;
    }

    //-------------------------
    List<TokenApiReponse> tokenData = await ApiDataTable.fetchData();

    for (var data in tokenData) {
      token = data.token;
      // print('Token: ${data.token}');
      // print('Responder Name: ${data.responderName}');
      // print('GeoLocation: ${data.geoLocation}');
    }
  }
}
List<Map<String, dynamic>> parseStatusListToJson(String xmlString) {
  final document = XmlDocument.parse(xmlString);
  final statusElements = document.findAllElements('stat');
  return statusElements.map((element) => Status.fromXmlElement(element).toJson()).toList();
}


void saveGTypesToDatabase(List<Map<String, dynamic>> gtypesList) async {
  try {
    // Convert list to JSON (optional debugging step)
    String jsonString = jsonEncode(gtypesList);
   // print("Converted JSON:\n$jsonString");

    // Clear existing data
    await GTypeTable.clearGTypes();

    // Insert each GType
    for (var gTypeMap in gtypesList) {
      var gTypeModel = GTypeModel.fromJson(gTypeMap);
      await GTypeTable.insertGType(gTypeModel);
    }

   // print('All GType data inserted successfully');
  } catch (e) {
    print('Error saving GTypes: $e');
  }
}

