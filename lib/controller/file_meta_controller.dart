import 'dart:convert';
import 'package:ace_routes/database/databse_helper.dart';
import 'package:ace_routes/core/colors/Constants.dart';
import 'package:ace_routes/model/file_meta_model.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import '../database/Tables/file_meta_table.dart';

class FileMetaController extends GetxController {
  RxList<FileMetaModel> fileMetaData = <FileMetaModel>[].obs;
  RxMap<String, int> imageCounts =
      <String, int>{}.obs; // Store count per eventId
  RxMap<String, int> audioCounts = <String, int>{}.obs; // Audios per eventId
  RxMap<String, int> signatureCounts =
      <String, int>{}.obs; // Signatures per eventId

  RxBool isLoading = false.obs;
  Future<void> fetchAndSaveFileMeta(String eventId) async {
    try {
      final db = await DatabaseHelper().database;

      final uri = Uri.parse(
          'https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=$geo&rid=$rid&action=getfilemeta&oid=$eventId');
      print('Request URL : $uri');

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

        // ✅ Save to database
        await FileMetaTable.insertMultipleFileMeta(fileMetaList, db);
        print('FileMeta successfully saved to the database.');

        // ✅ Fetch updated file counts to reflect in UI
        await fetchAllFileCounts(eventId);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error occurred while fetching FileMeta: $e');
    }
  }

  /// 🖼 Fetch **Images** for a Specific Event (Job)
  Future<void> fetchFileImageDataFromDatabase(String eventId) async {
    try {
      final data = await FileMetaTable.getAllFileMeta();
      List<FileMetaModel> imagesForEvent = data
          .where((fileMeta) => fileMeta.tid == "1" && fileMeta.oid == eventId)
          .toList();

      fileMetaData.value = imagesForEvent; // ✅ Update the observable list
      imageCounts[eventId] = imagesForEvent.length;
      fileMetaData.refresh();
      print('Image count for event $eventId: ${imageCounts[eventId]}');
    } catch (e) {
      print('Error fetching image data: $e');
    }
  }

  /// ✍ Fetch **Signatures** for a Specific Event (Job)
  Future<void> fetchFileSignatureDataFromDatabase(String eventId) async {
    try {
      final data = await FileMetaTable.getAllFileMeta();
      List<FileMetaModel> signaturesForEvent = data
          .where((fileMeta) => fileMeta.tid == "2" && fileMeta.oid == eventId)
          .toList();

      fileMetaData.value = signaturesForEvent; // ✅ Update the observable list
      signatureCounts[eventId] = signaturesForEvent.length;
      fileMetaData.refresh();
      print('Signature count for event $eventId: ${signatureCounts[eventId]}');
    } catch (e) {
      print('Error fetching signature data: $e');
    }
  }

  /// 🔊 Fetch **Audio** for a Specific Event (Job)
  Future<void> fetchFileAudioDataFromDatabase(String eventId) async {
    try {
      final data = await FileMetaTable.getAllFileMeta();
      List<FileMetaModel> audiosForEvent = data
          .where((fileMeta) => fileMeta.tid == "3" && fileMeta.oid == eventId)
          .toList();

      fileMetaData.value = audiosForEvent; // ✅ Update the observable list
      audioCounts[eventId] = audiosForEvent.length;
      fileMetaData.refresh();
      print('Audio count for event $eventId: ${audioCounts[eventId]}');
    } catch (e) {
      print('Error fetching audio data: $e');
    }
  }

  /// 🔄 Fetch **ALL** File Counts for a Job
  Future<void> fetchAllFileCounts(String eventId) async {
    await fetchFileImageDataFromDatabase(eventId);
    await fetchFileSignatureDataFromDatabase(eventId);
    await fetchFileAudioDataFromDatabase(eventId);
  }

  // Fetch raw data from the database table
  Future<List<Map<String, dynamic>>> fetchFileMeta() async {
    final db = await DatabaseHelper().database;
    return await db.query('FileMetaTable');
  }
}
