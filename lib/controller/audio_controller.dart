import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../core/colors/Constants.dart'; // Replace with your actual constants file

class AudioController {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  List<String> _recordings = [];
  String? _currentRecordingPath;
  String? _playingPath;
  bool _isPlaying = false;

  var audio = <File>[].obs;
  var selectedIndices = <int>[].obs;

  bool get isRecording => _isRecording;
  List<String> get recordings => _recordings;
  bool get isPlaying => _isPlaying;
  String? get playingPath => _playingPath;

  Future<void> init() async {
    await _recorder.openRecorder();
    await _player.openPlayer();
    await _loadRecordings();
  }

  Future<void> _loadRecordings() async {
    final directory = await getApplicationDocumentsDirectory();
    final recordingDir = Directory(directory.path);
    final List<FileSystemEntity> files = recordingDir.listSync();

    _recordings = files
        .where((file) => file is File && file.path.endsWith('.aac'))
        .map((file) => file.path)
        .toList();
  }

  Future<void> startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(toFile: path);
    _isRecording = true;
    _currentRecordingPath = path;
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    if (_currentRecordingPath != null) {
      _recordings.add(_currentRecordingPath!);
      _currentRecordingPath = null;
    }
    _isRecording = false;
  }

  Future<void> togglePlayback(String path, Function updateUI) async {
    if (_isPlaying && _playingPath == path) {
      await _stopPlayback();
      updateUI();
    } else {
      if (_isPlaying) {
        await _stopPlayback();
      }
      await _startPlayback(path, updateUI);
    }
  }

  Future<void> _startPlayback(String path, Function updateUI) async {
    await _player.startPlayer(
      fromURI: path,
      codec: Codec.aacADTS,
      whenFinished: () {
        _stopPlayback();
        updateUI();
      },
    );
    _isPlaying = true;
    _playingPath = path;
    updateUI();
  }

  Future<void> _stopPlayback() async {
    await _player.stopPlayer();
    _isPlaying = false;
    _playingPath = null;
  }

  Future<void> deleteRecording(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      _recordings.remove(path);
    }
  }

  Future<void> renameRecording(String oldPath, String newName) async {
    final directory = await getApplicationDocumentsDirectory();
    final newPath = '${directory.path}/$newName.aac';
    final file = File(oldPath);

    if (await file.exists()) {
      await file.rename(newPath);
      _recordings.remove(oldPath);
      _recordings.add(newPath);
    }
  }

  Future<void> dispose() async {
    await _recorder.closeRecorder();
    await _player.closePlayer();
  }

  /// **🔹 Upload Audio File to API**
  Future<void> uploadAudio(String filePath, String eventId, String description) async {
    try {
      File audioFile = File(filePath);

      if (!await audioFile.exists()) {
        Get.snackbar("Error", "Audio file does not exist.");
        return;
      }

      var url = Uri.parse("https://$baseUrl/fileupload");
      var request = http.MultipartRequest("POST", url);

      request.fields['token'] = token;
      request.fields['nspace'] = nsp;
      request.fields['geo'] = geo;
      request.fields['rid'] = rid;
      request.fields['oid'] = eventId;
      request.fields['stmp'] = DateTime.now().millisecondsSinceEpoch.toString();
      request.fields['tid'] = "3"; // ✅ Set type for audio
      request.fields['mime'] = "aac"; // ✅ Set correct MIME type
      request.fields['dtl'] = description;
      request.fields['frmkey'] = "";
      request.fields['frmfldid'] = "";

      request.files.add(await http.MultipartFile.fromPath(
        'binaryFile',
        audioFile.path,
        filename: "audio_${DateTime.now().millisecondsSinceEpoch}.aac",
      ));

      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      print("🔹 Response: ${response.statusCode} - $responseString");

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseString);
        Get.snackbar("Success", "Audio uploaded successfully!");
        print("✅ Parsed Response: $jsonResponse");
      } else {
        print("❌ Error: ${response.reasonPhrase}");
        Get.snackbar("Upload Failed", response.reasonPhrase ?? "Error");
      }
    } catch (e) {
      print("❌ Exception: $e");
      Get.snackbar("Upload Error", "Something went wrong.");
    }
  }

  void clearAudio() {
    audio.clear();
    selectedIndices.clear();
    audio.refresh(); // ✅ This updates the UI
    selectedIndices.refresh(); // ✅ This updates the UI
  }

}
