import 'package:ace_routes/core/colors/Constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetMediaFile extends GetxController {
  var imageUrl = ''.obs;
  final String id;

  GetMediaFile({required this.id});

  @override
  void onInit() {
    super.onInit();
    fetchMediaFile();
  }

  Future<void> fetchMediaFile() async {
    final url =
        'https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=$geo&rid=$rid&action=getfile&id=$id';

    print("Fetching media file...");
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      imageUrl.value = url; // Set the image URL to the observable variable
    } else {
      print("Failed to load image, Status Code: ${response.statusCode}");
    }
  }




}
