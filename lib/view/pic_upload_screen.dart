import 'dart:io';
import 'package:ace_routes/core/Constants.dart';
import 'package:ace_routes/view/picture_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/file_meta_controller.dart';
import '../controller/fontSizeController.dart';
import '../controller/picUploadController.dart';

class PicUploadScreen extends StatefulWidget {
  final int eventId;
  PicUploadScreen({required this.eventId});

  @override
  State<PicUploadScreen> createState() => _PicUploadScreenState();
}

class _PicUploadScreenState extends State<PicUploadScreen> {
  final PicUploadController controller = Get.put(PicUploadController());
  final FileMetaController fileMetaController = Get.put(FileMetaController());
  final fontSizeController = Get.find<FontSizeController>();

  @override
  void initState() {
    super.initState();
    fileMetaController.fetchFileImageDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    AllTerms.getTerm();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AllTerms.pictureLabel.value,
          style: TextStyle(
              color: Colors.white, fontSize: fontSizeController.fontSize),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            controller.clearImages();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              if (fileMetaController.fileMetaData.isEmpty) {
                return Center(child: Text('No file meta data available.'));
              }
              return _buildFileMetaDataGrid(); // Updated to use a grid
            }),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two images per row
                    crossAxisSpacing: 40,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: controller.images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.images.length) {
                      return GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                            size: 50,
                          ),
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => FullScreenImageView(
                              image: File(controller.images[index].path)));
                        },
                        onLongPress: () {
                          controller.toggleSelection(index);
                        },
                        child: Obx(() {
                          bool isSelected =
                              controller.selectedIndices.contains(index);

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Colors.red
                                    : Colors.transparent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(controller.images[index].path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          );
                        }),
                      );
                    }
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Build file meta data as a Grid (2 per row)
  Widget _buildFileMetaDataGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Show 2 per row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1, // Adjust height-width ratio
      ),
      itemCount: fileMetaController.fileMetaData.length,
      itemBuilder: (context, index) {
        final fileMeta = fileMetaController.fileMetaData[index];
        return _buildFileMetaBlock(fileMeta);
      },
    );
  }

  // Create the file metadata block (without the delete icon)
  Widget _buildFileMetaBlock(var fileMeta) {
    return GestureDetector(
      onTap: () {
        print(fileMeta.id);
        Get.to(PictureViewScreen(
          id: fileMeta.id,
        ));
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              fileMeta.fname ?? 'No Name',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Center(
              child: Text(
                fileMeta.dtl ?? 'No Name',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final File image;

  FullScreenImageView({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Image.file(
            image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
