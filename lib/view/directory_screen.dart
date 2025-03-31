import 'package:ace_routes/controller/directory_controller.dart';
import 'package:ace_routes/core/Constants.dart';
import 'package:ace_routes/core/colors/Constants.dart';
import 'package:ace_routes/view/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/fontSizeController.dart';

class DirectoryDetails extends StatelessWidget {
  final String id;
  final String ctid;
  const DirectoryDetails({super.key, required this.id, required this.ctid});

  @override
  Widget build(BuildContext context) {
    final fontSizeController = Get.find<FontSizeController>();
    // Initialize controller immediately
    final DirectoryController directoryController = Get.put(DirectoryController(id , ctid));



    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Directory",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: MyColors.blueColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body:   Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: Obx(() => Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: ListView(
              children: [
                Container(
                  color: const Color.fromARGB(255, 242, 255, 243),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.location_on_sharp,
                            color: MyColors.blueColor,
                            size: 35,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                directoryController.address.value,
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSizeController.fontSize),
                              ),
                              Text(
                                directoryController.address.value,
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.green[500],
                                    fontSize: fontSizeController.fontSize),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  color: const Color.fromARGB(255, 242, 255, 243),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.person,
                            color: MyColors.blueColor,
                            size: 35,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              directoryController.customerName.value,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSizeController.fontSize),
                            ),
                            Text(
                              'mobile',
                              softWrap: true,
                              style: TextStyle(
                                  color: Colors.green[500],
                                  fontSize: fontSizeController.fontSize),
                            ),
                            Text(
                                directoryController.customerMobile.value,
                              softWrap: true,
                              style: TextStyle(
                                  color: Colors.green[500],
                                  fontSize: fontSizeController.fontSize),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
           
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: const Color.fromARGB(255, 242, 255, 243),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.group,
                            color: MyColors.blueColor,
                            size: 35,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              directoryController.directoryName.value,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSizeController.fontSize),
                            ),

                            Text(
                              directoryController.capacity.value,
                              softWrap: true,
                              style: TextStyle(
                                  color: Colors.green[500],
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSizeController.fontSize),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
        ));
  }
}
