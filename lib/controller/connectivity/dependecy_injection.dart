import 'package:ace_routes/controller/connectivity/network_controller.dart';
import 'package:get/get.dart';

class DependecyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
  }
}
