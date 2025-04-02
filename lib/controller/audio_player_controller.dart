import 'package:ace_routes/core/colors/Constants.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AudioPlayerController extends GetxController {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  var audioUrl = ''.obs; // Holds fetched audio URL
  var isPlaying = false.obs;
  var currentAudioId = ''.obs; // Track currently playing audio ID

  @override
  void onInit() {
    super.onInit();
    _player.openPlayer(); // ✅ Ensure player is opened
  }

  Future<void> fetchAndPlayAudio(String audioId) async {
    if (isPlaying.value && currentAudioId.value == audioId) {
      stopAudio(); // ✅ Stop if clicking same audio
      return;
    }

    currentAudioId.value = audioId; // Update playing audio ID
    final url =
        'https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=$geo&rid=$rid&action=getfile&id=$audioId';

    print("Fetching audio: $url");
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      audioUrl.value = url;
      playAudio();
    } else {
      print("❌ Failed to load audio, Status Code: ${response.statusCode}");
    }
  }

  Future<void> playAudio() async {
    if (audioUrl.isEmpty) return;

    try {
      await _player.startPlayer(
        fromURI: audioUrl.value,
        codec: Codec.aacADTS,
        whenFinished: () {
          isPlaying.value = false;
          currentAudioId.value = '';
        },
      );
      isPlaying.value = true;
    } catch (e) {
      print("❌ Audio play error: $e");
    }
  }

  Future<void> stopAudio() async {
    await _player.stopPlayer();
    isPlaying.value = false;
    currentAudioId.value = '';
  }

  @override
  void onClose() {
    _player.closePlayer();
    super.onClose();
  }
}
