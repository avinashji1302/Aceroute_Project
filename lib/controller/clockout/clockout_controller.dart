import 'package:ace_routes/core/colors/Constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ClockOut extends GetxController {
  Future<void> executeAction(
      {String? lstoid, String? nxtoid, required int tid}) async {
    String url = buildUrl(lstoid: lstoid, nxtoid: nxtoid);

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print("response data : ${response.body}");
        print("stamp $tid: ${timestamp}");
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  String buildUrl({String? lstoid, String? nxtoid}) {
    String url =
        'https://$baseUrl/mobi?token=$token&nspace=$nsp&geo=<lat,lon>&rid=$rid&action=savetcrd&tid=1&stmp=$timestamp';

    if (lstoid != null) {
      baseUrl += '&lstoid=$lstoid';
    }
    if (nxtoid != null) {
      baseUrl += '&nxtoid=$nxtoid';
    }

    return url;
  }
}
