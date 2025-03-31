import 'package:ace_routes/model/GTypeModel.dart';
import 'package:get/get.dart';

import '../database/Tables/OrderTypeDataTable.dart';
import '../database/Tables/genTypeTable.dart';
import '../model/OrderTypeModel.dart';

class EFormController extends GetxController {
  // Use RxList to store the fetched data reactively
  //Template Getting from Gen TypeFor to choose who is gonna fill the form and label all fields
  String capacity = "";
  var gTypeList = <GTypeModel>[].obs;
  Future<void> GetGenOrderDataForForm(String tid) async {

    capacity = tid; //(Tid of event is same as specific order type);
    List<GTypeModel> fetchedGTypes = await GTypeTable.fetchGTypeByTid(capacity);
   // print(capacity);


    if (fetchedGTypes.isNotEmpty) {
    //  print("Eform data is here:");
      gTypeList.value = fetchedGTypes;
      for (var gType in fetchedGTypes) {
        print(gType
            .details); // This will use the overridden toString method from GTypeModel
      }
    } else {
      print("GType with ID $tid not found.");
    }
  }
}
