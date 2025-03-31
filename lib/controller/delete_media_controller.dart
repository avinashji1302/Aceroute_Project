import 'package:ace_routes/core/colors/Constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DeleteMediaController extends GetxController {
  Future<void> deleteMedia(String fMetaId) async {
    String url =
        " https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=<lat,lon>&rid=$rid&action=deletefile&id=$fMetaId";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {}
    } catch (e) {}
  }
}
