import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/vehicle_controller.dart';

AppBar myAppBar({
  required BuildContext context,
  required RxString titleText,
  required Color backgroundColor,
}) {
  return AppBar(
    title: Obx(() => Text(
          titleText.value,
          style: const TextStyle(color: Colors.white),
        )),
    centerTitle: true,
    backgroundColor: backgroundColor,
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
    actions: [
      IconButton(
        onPressed: () {

        },
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.done,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
