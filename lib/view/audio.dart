import 'package:ace_routes/controller/audio_controller.dart';
import 'package:ace_routes/controller/audio_player_controller.dart';
import 'package:ace_routes/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siri_wave/siri_wave.dart';
import '../controller/event_controller.dart';
import '../controller/file_meta_controller.dart';
import 'audioPlayerScreen.dart';

class AudioRecord extends StatefulWidget {
  final int eventId;

  AudioRecord({required this.eventId});

  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  final AudioController _controller = AudioController();
  final FileMetaController fileMetaController = Get.put(FileMetaController());
  final AudioPlayerController audioPlayerController =
      Get.put(AudioPlayerController());
  final EventController eventController = Get.put(EventController());
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    _initController();
    fileMetaController
        .fetchFileAudioDataFromDatabase(widget.eventId.toString());
  }

  Future<void> _initController() async {
    await _requestPermissions();
    await _controller.init();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.microphone.request();

    if (status.isDenied) {
      _showPermissionDeniedDialog();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Microphone Permission Denied'),
        content: const Text(
            'This app needs microphone access to record audio. Please enable microphone permissions in your device settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// **🔹 Upload Audio Files and Clear List**
  Future<void> _uploadAudioFiles() async {
    if (_controller.recordings.isEmpty) {
      Get.snackbar("Error", "No recordings to upload.");
      return;
    }

    setState(() => isUploading = true);

    for (var recording in _controller.recordings) {
      await _controller.uploadAudio(
        recording,
        widget.eventId.toString(),
        "Recorded Event Audio",
      );
    }

    // ✅ Store the last uploaded recording path
    String lastRecordingPath = _controller.recordings.last;

    // ✅ Clear recordings after upload
    _controller.recordings.clear();

    setState(() => isUploading = false);

    // ✅ Fetch uploaded audio again to update UI
    fileMetaController
        .fetchFileAudioDataFromDatabase(widget.eventId.toString());

    // ✅ Show success dialog and pass the last uploaded recording path
    _showSuccessDialog(lastRecordingPath);
  }

  void _showSuccessDialog(String recordingPath) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Upload Successful"),
        content: Text("Your audio has been uploaded successfully!"),
        actions: [
          TextButton(
            onPressed: () async {
              await _controller
                  .deleteRecording(recordingPath); // ✅ Delete the recording
              setState(() {}); // ✅ Update UI after deletion

              Get.back(); // ✅ Close Dialog
              Get.offAll(() => HomeScreen()); // ✅ Navigate to HomeScreen
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Audio", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            _controller.clearAudio();
          },
        ),
        actions: [
          IconButton(
            onPressed: isUploading ? null : _uploadAudioFiles,
            icon: isUploading
                ? Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Icon(Icons.cloud_upload, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🎵 Display Uploaded Audio
          Expanded(
            child: Obx(() {
              if (fileMetaController.fileMetaData.isEmpty) {
                return Center(child: Text('No uploaded audio available.'));
              }
              //return _buildUploadedAudioList();
              return _buildUploadedAudioList(widget.eventId.toString());
            }),
          ),

          // 🎙️ Live Recording Indicator
          if (_controller.isRecording)
            SiriWaveform.ios9(
              options: IOS9SiriWaveformOptions(height: 100, width: 300),
            ),

          // 🎤 Mic Icon
          Icon(
            Icons.mic,
            size: 80,
            color: _controller.isRecording ? Colors.green : Colors.black,
          ),

          // 🎬 Record/Stop Button
          ElevatedButton(
            onPressed: _controller.isRecording
                ? () async {
                    await _controller.stopRecording();
                    setState(() {});
                  }
                : () async {
                    await _controller.startRecording();
                    setState(() {});
                  },
            child: Text(
                _controller.isRecording ? 'Stop Recording' : 'Start Recording'),
          ),

          SizedBox(height: 20),

          // 🎼 List of Local Recordings
          Expanded(
            child: ListView.separated(
              itemCount: _controller.recordings.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              itemBuilder: (context, index) {
                final recordingPath = _controller.recordings[index];
                final isPlaying = _controller.playingPath == recordingPath;
                return ListTile(
                  title: Text('Recording ${index + 1}'),
                  leading: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle_filled : Icons.play_arrow,
                      color: Colors.black,
                      size: 40,
                    ),
                    onPressed: () async {
                      await _controller.togglePlayback(
                        recordingPath,
                        () => setState(() {}),
                      );
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red, size: 40),
                    onPressed: () async {
                      await _controller.deleteRecording(recordingPath);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// **🎵 Build List of Uploaded Audio**
  /*Widget _buildUploadedAudioList() {
    return Expanded(
      // ✅ Wrap ListView in Expanded
      child: Obx(() {
        if (fileMetaController.fileMetaData.isEmpty) {
          return Center(child: Text('No uploaded audio available.'));
        }

        return ListView.builder(
          shrinkWrap: true, // ✅ Ensures proper layout
          itemCount: fileMetaController.fileMetaData.length,
          itemBuilder: (context, index) {
            final fileMeta = fileMetaController.fileMetaData[index];
            final audioId = fileMeta.id.toString();
            final isPlaying =
                audioPlayerController.currentAudioId.value == audioId;

            return ListTile(
              leading: Icon(Icons.audiotrack, color: Colors.blue, size: 40),
              title: Text(fileMeta.fname ?? 'Unknown Audio'),
              trailing: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_arrow,
                  color: isPlaying ? Colors.green : Colors.black,
                  size: 40,
                ),
                onPressed: () {
                  audioPlayerController.fetchAndPlayAudio(audioId);
                },
              ),
            );
          },
        );
      }),
    );
  }*/

  /// **🎵 Build List of Uploaded Audio with Click Navigation**
  Widget _buildUploadedAudioList(String eventId) {
    return Expanded(
      child: Obx(() {
        if (fileMetaController.fileMetaData.isEmpty) {
          return Center(child: Text('No uploaded audio available.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: fileMetaController.fileMetaData.length,
          itemBuilder: (context, index) {
            final fileMeta = fileMetaController.fileMetaData[index];
            final audioId = fileMeta.id.toString();
            final audioTitle =
                fileMeta.fname ?? 'Unknown Audio'; // Ensure title is not null

            return GestureDetector(
              onTap: () {
                // Pass both `audioId` and `audioTitle`
                Get.to(() => AudioPlayerScreen(
                    audioId: audioId, audioTitle: audioTitle));
              },
              child: ListTile(
                leading: Icon(Icons.audiotrack, color: Colors.blue, size: 40),
                title: Text(audioTitle),

                // Play button converted to delete button
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 40),
                  onPressed: () async {
                    // _showDeleteConfirmationDialog(audioId);
                    _showDeleteConfirmationDialog(audioId, eventId);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showDeleteConfirmationDialog(String audioId, String eventId) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Audio",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to delete this audio?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actionsAlignment: MainAxisAlignment.end, // Aligns buttons to the left
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog without action
            },
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close dialog
              await _controller.deleteAudio(audioId, eventId);
              //Get.to(HomeScreen());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
