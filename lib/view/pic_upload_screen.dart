import 'dart:io';
import 'package:ace_routes/view/picture_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/file_meta_controller.dart';
import '../controller/fontSizeController.dart';
import '../controller/picUploadController.dart';
import 'home_screen.dart';

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
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    fileMetaController.fetchFileImageDataFromDatabase(widget.eventId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Upload Pictures",
          style: TextStyle(color: Colors.white, fontSize: fontSizeController.fontSize),
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
        actions: [
          IconButton(
            onPressed: () async {
              if (isUploading) return; // Prevent multiple clicks

              setState(() {
                isUploading = true; // Show loading indicator
              });

              bool success = await controller.uploadAllImages(widget.eventId.toString(), "1");

              setState(() {
                isUploading = false; // Hide loading indicator
              });

              if (success) {
                _showSuccessDialog(); // ✅ Show success dialog after upload
              } else {
                Get.snackbar("Error", "Upload failed. Please try again.");
              }
            },
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isUploading
                  ? CircularProgressIndicator(color: Colors.white) // ✅ Show loader
                  : Icon(Icons.file_upload_outlined, color: Colors.white),
            ),
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return _buildFileMetaDataGrid(); // Display previously uploaded images
            }),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7, // Adjust for text input
                ),
                itemCount: controller.images.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.images.length) {
                    return GestureDetector(
                      onTap: () async {
                        await controller.pickImage(); // ✅ Pick image when tapped
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.grey[800], size: 50),
                      ),
                    );
                  } else {
                    return _buildImageCard(index);
                  }
                },
              )),
            ),
            /*SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => controller.uploadAllImages(widget.eventId.toString(), "1"),
              child: Text("Upload All"),
            ),*/
          ],
        ),
      ),
    );
  }

  // **Show Dialog for Image Description**
  void _showDescriptionDialog(File imageFile, int index) {
    TextEditingController descriptionController = TextEditingController();

    Get.defaultDialog(
      title: "Enter Image Description",
      content: Column(
        children: [
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: "Enter description..."),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              String description = descriptionController.text.trim();
              if (description.isEmpty) {
                Get.snackbar("Error", "Please enter a description!");
                return;
              }
              Get.back(); // Close dialog
              controller.uploadImage(controller.images[index], widget.eventId.toString(), "1", description);
            },
            child: Text("Upload"),
          ),
        ],
      ),
    );
  }

  // **Widget to display each image with inputs**
  Widget _buildImageCard(int index) {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showDescriptionDialog(controller.images[index], index),
              //onTap: () => Get.to(() => FullScreenImageView(image: controller.images[index])),
              child: Image.file(controller.images[index], fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) => controller.setImageName(index, val),
              decoration: InputDecoration(labelText: "Image Name"),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) => controller.setImageDescription(index, val),
              decoration: InputDecoration(labelText: "Description"),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => controller.deleteImage(index),
          ),
        ],
      ),
    );
  }

  // Build file meta data as a Grid (2 per row)
  Widget _buildFileMetaDataGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: fileMetaController.fileMetaData.length,
      itemBuilder: (context, index) {
        final fileMeta = fileMetaController.fileMetaData[index];
        return _buildFileMetaBlock(fileMeta);
      },
    );
  }






  // Create the file metadata block
 /* Widget _buildFileMetaBlock(var fileMeta) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              fileMeta.fname ?? 'No Name',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              fileMeta.dtl ?? 'No Description',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
*/


  Widget _buildFileMetaBlock(var fileMeta) {
    return GestureDetector(
      onTap: () {
        print(fileMeta.id);
        Get.to(PictureViewScreen(id: fileMeta.id));
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  fileMeta.fname ?? 'No Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  fileMeta.dtl ?? 'No Description',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          /// ✅ Delete Icon Positioned at Top Left
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 24),
              onPressed: () => _showDeleteDialog(fileMeta.id, fileMeta.oid),

            ),
          ),
        ],
      ),
    );
  }

  /// Function to show the delete confirmation dialog
  void _showDeleteDialog(String mediaId, String eventId) {
    Get.defaultDialog(
      title: "Confirm Deletion",
      content: Text("Are you sure you want to delete this media file?"),
      actions: [
        TextButton(
          onPressed: () => Get.back(), // Cancel
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            Get.back(); // Close dialog
            int parsedMediaId = int.tryParse(mediaId) ?? 0;
            if (parsedMediaId != 0) {
              bool success = await fileMetaController.deleteMedia(mediaId, eventId);

              if (success) {
                Get.snackbar("Success", "Media deleted successfully!",
                    backgroundColor: Colors.green, colorText: Colors.white);
              } else {
                Get.snackbar("Error", "Failed to delete media.",
                    backgroundColor: Colors.red, colorText: Colors.white);
              }
            } else {
              Get.snackbar("Error", "Invalid media ID",
                  backgroundColor: Colors.red, colorText: Colors.white);
            }
          },
          child: Text("OK"),
        ),
      ],
    );
  }


  /// ✅ Show Success Dialog
  void _showSuccessDialog() {
    Get.defaultDialog(
      title: "Success",
      content: Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 50),
          SizedBox(height: 10),
          Text("Image uploaded successfully!", textAlign: TextAlign.center),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Close Dialog
              Get.offAll(() => HomeScreen()); // ✅ Navigate to HomeScreen
            },
            child: Text("OK"),
          ),
        ],
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


