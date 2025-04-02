import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/get_media_file.dart';

class FullScreenSignatureView extends StatelessWidget {
  late String id;

  FullScreenSignatureView({super.key,required this.id});

  @override
  Widget build(BuildContext context) {
    final GetMediaFile getMediaFile = Get.put(GetMediaFile(id: id));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(() {
          if (getMediaFile.imageUrl.isEmpty) {
            return CircularProgressIndicator(); // Show loading until image is fetched
          } else {
            return Image.network(
              getMediaFile.imageUrl.value,
              fit: BoxFit.contain,
            );
          }
        }),
      ),
    );
  }
}
