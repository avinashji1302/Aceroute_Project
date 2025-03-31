import 'package:get/get.dart';

import '../database/Tables/genTypeTable.dart';
import '../database/Tables/PartTypeDataTable.dart';
import '../database/Tables/event_table.dart';
import '../model/GTypeModel.dart';
import '../model/Ptype.dart';
import '../model/event_model.dart';
import 'event_controller.dart';

class DirectoryController extends GetxController {
  final String id;
  final String ctid;

  DirectoryController(this.id, this.ctid);

  RxString address = "".obs;
  RxString address2 = "".obs;
  RxString customerName = "".obs;
  RxString customerMobile = "".obs;
  RxString ctpnm = "".obs;
  RxString directoryName = "".obs;
  RxString capacity = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchDirectoryDetailsFromDb();
  //  print("I am here in directory");
  }

  Future<void> fetchDirectoryDetailsFromDb() async {
    Event? localEvent = await EventTable.fetchEventById(id);
     GTypeModel? fetchedGType = await GTypeTable.fetchGTypeById(ctid);
    if (localEvent != null) {
      //this  data is  from event database
      address.value = localEvent.address;
      address2.value = localEvent.address;
      customerMobile.value = localEvent.tel;
      ctpnm.value = localEvent.ctpnm;
      customerName.value = localEvent.cnm;

     // print("Local events ${address.value}");
    }

    if (fetchedGType != null) {
      //this  data is  from event GenType database through id "ctid" from event data
      directoryName.value = fetchedGType.name;
      capacity.value = fetchedGType.capacity;
    }
  }
}
