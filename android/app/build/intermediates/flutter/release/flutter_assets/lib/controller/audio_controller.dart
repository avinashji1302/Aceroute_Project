import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioController {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  List<String> _recordings = [];
  String? _currentRecordingPath;
  String? _playingPath;
  bool _isPlaying = false;

  bool get isRecording => _isRecording;
  List<String> get recordings => _recordings;
  bool get isPlaying => _isPlaying;
  String? get playingPath => _playingPath;

  Future<void> init() async {
    await _recorder.openRecorder();
    await _player.openPlayer();
    await _loadRecordings();

    // Listener for player state changes
    _player.onProgress!.listen((e) {
      if (e != null && e.duration != null && e.position != null) {
        if (e.position! >= e.duration!) {
          _stopPlayback();
        }
      }
    });
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
      updateUI(); // Update the UI when stopping playback
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
        updateUI(); // Update the UI when playback finishes
      },
    );
    _isPlaying = true;
    _playingPath = path;
    updateUI(); // Update the UI when starting playback
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
}
