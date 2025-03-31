import 'dart:convert';
import 'package:ace_routes/database/databse_helper.dart';

import 'package:ace_routes/core/colors/Constants.dart';
import 'package:ace_routes/model/file_meta_model.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

import '../database/Tables/event_table.dart';
import '../database/Tables/file_meta_table.dart';
import 'event_controller.dart';

class FileMetaController extends GetxController {

  RxList<FileMetaModel> fileMetaData = <FileMetaModel>[].obs;

  RxBool isLoading = false.obs;
  Future<void> fetchAndSaveFileMeta(String eventId) async {
    try {
      final db = await DatabaseHelper().database;

      final uri = Uri.parse(
          'https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=$geo&rid=$rid&action=getfilemeta&oid=$eventId');
      print('Request URL: $uri');

      var request = http.Request('GET', uri);
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Response Data: $responseData');

        final xmlDoc = XmlDocument.parse(responseData);
        final fileMetaElements = xmlDoc.findAllElements('fmeta');

        List<FileMetaModel> fileMetaList = fileMetaElements.map((element) {
          return FileMetaModel(
            id: element.getElement('id')?.text ?? '',
            fname: element.getElement('fname')?.text ?? '',
            oid: element.getElement('oid')?.text ?? '',
            tid: element.getElement('tid')?.text ?? '',
            mime: element.getElement('mime')?.text ?? '',
            dtl: element.getElement('dtl')?.text ?? '',
            geo: element.getElement('geo')?.text ?? '',
            frmkey: element.getElement('frmkey')?.text ?? '',
            frmfldid: element.getElement('frmfldid')?.text ?? '',
            upd: element.getElement('upd')?.text ?? '',
            by: element.getElement('by')?.text ?? '',
          );
        }).toList();

        print(
            'Parsed FileMeta List: ${jsonEncode(fileMetaList.map((e) => e.toJson()).toList())}');

        await FileMetaTable.insertMultipleFileMeta(fileMetaList, db);
        print('FileMeta successfully saved to the database.');
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred while fetching FileMeta: $e');
    }
  }

  // Fetch Signature data from the database and update the observable list
  Future<void> fetchFileSignatureDataFromDatabase() async {
    try {
      final data = await FileMetaTable.getAllFileMeta();
      // Filter the data to only include fileMeta where tid == 2
      fileMetaData.value =
          data.where((fileMeta) => fileMeta.tid == "2").toList();
      //fileMetaData.value = data;

      print(
          'Successfully Signature fetching data from database: ${fileMetaData.value}');
    } catch (e) {
      print('Error fetching data from database: $e');
    }
  }

  // Fetch Image data from the database and update the observable list
  Future<void> fetchFileImageDataFromDatabase() async {
    try {
      final data = await FileMetaTable.getAllFileMeta();
      // Filter the data to only include fileMeta where tid == 2
      fileMetaData.value =
          data.where((fileMeta) => fileMeta.tid == "1").toList();
      //fileMetaData.value = data;

      print(
          'Successfully Image fetching data from database: ${fileMetaData.value}');
    } catch (e) {
      print('Error fetching data from database: $e');
    }
  }

  // Fetch Audio data from the database and update the observable list
  Future<void> fetchFileAudioDataFromDatabase() async {
    try {
      final data = await FileMetaTable.getAllFileMeta();
      // Filter the data to only include fileMeta where tid == 2
      fileMetaData.value =
          data.where((fileMeta) => fileMeta.tid == "3").toList();
      //fileMetaData.value = data;

      print(
          'Successfully Audio fetching data from database: ${fileMetaData.value}');
    } catch (e) {
      print('Error fetching data from database: $e');
    }
  }

  // Fetch raw data from the database table
  Future<List<Map<String, dynamic>>> fetchFileMeta() async {
    final db = await DatabaseHelper().database;
    return await db.query('FileMetaTable');
  }
}
