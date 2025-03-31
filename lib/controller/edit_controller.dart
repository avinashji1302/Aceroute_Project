// import 'package:ace_routes/core/colors/Constants.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// class EditController extends GetxController {
//   final url =
//       "https://portal.aceroute.com/mobi?token=$token&nspace=demo.com&geo=$geo&rid=$rid&action=editorder&id=74539&cid=1343842047&wkf=7&egeo=$geo&stmp=2700000&orderStartTime=39600000&orderEndTime=42300000&start_date=2025/01/21 06:00 -00:00&end_date=2025/01/21 07:30 -00:00&nm=54321&dtl=Vehicle details demo&alt=Fault Desc demo&po=Registration Demo&inv=Odometer demo&tid=90006&pid=2&xml=0&note=Quoted Service";
//
//   Future<void> edit() async {
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         print(response.body);
//         print("edit success");
//       }
//     } catch (e) {}
//   }
// }
