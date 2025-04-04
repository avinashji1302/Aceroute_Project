import 'package:ace_routes/controller/audio_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioPlayerScreen extends StatelessWidget {
  final String audioId;
  final String audioTitle;

  AudioPlayerScreen({required this.audioId, required this.audioTitle});

  final AudioPlayerController audioPlayerController =
  Get.find<AudioPlayerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(audioTitle, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.audiotrack, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(audioTitle, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),

          Obx(() {
            bool isPlaying = audioPlayerController.currentAudioId.value == audioId;
            return IconButton(
              icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  size: 80, color: isPlaying ? Colors.red : Colors.green),
              onPressed: () {
                audioPlayerController.fetchAndPlayAudio(audioId);
              },
            );
          }),

          SizedBox(height: 30),

          /*ElevatedButton.icon(
            onPressed: () {
              Get.back(); // Navigate back to the previous screen
            },
            icon: Icon(Icons.arrow_back),
            label: Text("Back"),
          ),*/
        ],
      ),
    );
  }
}
