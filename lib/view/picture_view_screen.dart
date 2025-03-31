import 'package:ace_routes/controller/get_media_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/Constants.dart';

class PictureViewScreen extends StatelessWidget {
  late String id;
  PictureViewScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final GetMediaFile getMediaFile = Get.put(GetMediaFile(id: id));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Picture View',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
