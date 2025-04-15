import 'package:ace_routes/controller/loginController.dart';
import 'package:ace_routes/controller/status_updated_controller.dart';
import 'package:ace_routes/core/Constants.dart';
import 'package:ace_routes/core/colors/Constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/fontSizeController.dart';
import '../model/Status_model_database.dart';

class StatusScreen extends StatefulWidget {
  String oid;
  String name;
  StatusScreen({super.key, required this.oid, required this.name});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  // final statusController = Get.put(StatusController());
  final LoginController loginController =
      Get.find<LoginController>(); // Accessing LoginController

  final StatusControllers statusControllers = Get.put(StatusControllers());
  final fontSizeController = Get.find<FontSizeController>();

  @override
  void initState() {
    super.initState();

    statusControllers.organizeData();
  }

  @override
  Widget build(BuildContext context) {
    AllTerms.getTerm(); //getting the lable
    return Scaffold(
      appBar: AppBar(
        title: Text("Status",
            style: TextStyle(
              color: Colors.white,
            )),
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
      body: Obx(() {
        return ListView.builder(
          itemCount: statusControllers.organizedData.keys.length,
          itemBuilder: (context, index) {
            String groupName =
                statusControllers.organizedData.keys.elementAt(index);
            List<Status> groupItems =
                statusControllers.organizedData[groupName]!;

            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group title container with styling
                  Container(
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        groupName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  // List items with Divider after each item, except the last one
                  ...groupItems.asMap().entries.map((entry) {
                    int itemIndex = entry.key;
                    Status item = entry.value;

                    return Column(
                      children: [
                        ListTile(
                          title: Text(item.name),
                          onTap: () {
                            print(" item name is :${item.name} ${widget.name}");
                            print(" id is :${item.id} ");
                            Navigator.of(context).pop();

                            statusControllers.getStatusUpdate(
                                widget.oid, widget.name, item.id, item.name);
                          },
                        ),
                        // Add Divider only if it's not the last item
                        if (itemIndex < groupItems.length - 1)
                          Divider(thickness: 1),
                      ],
                    );
                  }).toList(),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
