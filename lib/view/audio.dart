import 'package:ace_routes/controller/audio_controller.dart';
import 'package:ace_routes/core/Constants.dart';
import 'package:ace_routes/core/colors/Constants.dart';
import 'package:ace_routes/view/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siri_wave/siri_wave.dart';

import '../controller/file_meta_controller.dart';

class AudioRecord extends StatefulWidget {
  final int eventId;

  AudioRecord({required this.eventId});

  @override
  State<AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<AudioRecord> {
  final AudioController _controller = AudioController();
  final FileMetaController fileMetaController = Get.put(FileMetaController());

  @override
  void initState() {
    super.initState();
    _initController();
    fileMetaController.fetchFileAudioDataFromDatabase();
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
      // Show a dialog or a snackbar asking the user to enable the permission
      _showPermissionDeniedDialog();
    } else if (status.isPermanentlyDenied) {
      // Open app settings if the permission is permanently denied
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AllTerms.getTerm();
    return Scaffold(
      appBar: myAppBar(
          context: context,
          titleText: AllTerms.audioLabel,
          backgroundColor: MyColors.blueColor),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              if (fileMetaController.fileMetaData.isEmpty) {
                return Center(child: Text('No file meta data available.'));
              }
              return _buildFileMetaDataList();
            }),
            SizedBox(height: 20),
            Container(
                child: _controller.isRecording
                    ? SiriWaveform.ios9(
                  options: IOS9SiriWaveformOptions(
                    height: 180,
                    width: 360,
                  ),
                )
                    : Text('')),
            Icon(
              Icons.mic,
              size: 100,
              color: _controller.isRecording ? Colors.green : Colors.black,
            ),
            SizedBox(height: 10),
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
              child: Text(_controller.isRecording
                  ? 'Stop Recording'
                  : 'Start Recording'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: _controller.recordings.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: 10), // Space between items

                itemBuilder: (context, index) {
                  final recordingPath = _controller.recordings[index];
                  final isPlaying = _controller.playingPath == recordingPath;
                  return Container(
                    color: const Color.fromARGB(255, 211, 211, 211),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 8, bottom: 8),
                      child: ListTile(
                        title: GestureDetector(
                            onTap: () {},
                            child: Text('Recording ${index + 1}')),
                        leading: IconButton(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_arrow,
                            color: Colors.black,
                            size: 50,
                          ),
                          onPressed: () async {
                            await _controller.togglePlayback(
                              recordingPath,
                                  () => setState(() {}),
                            );
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 40,
                          ),
                          onPressed: () async {
                            await _controller.deleteRecording(recordingPath);
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build file meta data list for images
  Widget _buildFileMetaDataList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: fileMetaController.fileMetaData.length,
      itemBuilder: (context, index) {
        final fileMeta = fileMetaController.fileMetaData[index];
        return _buildFileMetaBlock(context, index, fileMeta);
      },
    );
  }

  // Create the file metadata block (with the image name or icon)
  Widget _buildFileMetaBlock(BuildContext context, int index, var fileMeta) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              fileMeta.fname ?? 'No Name',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // fileMetaController.deleteFileMeta(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}