import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:ace_routes/controller/signature_controller.dart';
import '../controller/event_controller.dart';
import '../controller/file_meta_controller.dart';
import '../controller/fontSizeController.dart';
import '../controller/get_media_file.dart';
import 'fullScreenSignatureView.dart';
import 'home_screen.dart';

class Signature extends StatefulWidget {
  final int eventId;

  Signature({required this.eventId});

  @override
  State<Signature> createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  final SignatureController signatureController =
      Get.put(SignatureController());
  final FileMetaController fileMetaController = Get.put(FileMetaController());
  final fontSizeController = Get.find<FontSizeController>();
  final EventController eventController = Get.put(EventController());

  bool isUploading = false; // Track upload status
  final RxInt currentBlock = 0.obs;

  @override
  void initState() {
    super.initState();
    fileMetaController
        .fetchFileSignatureDataFromDatabase(widget.eventId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: myAppBar(
        context: context,
        titleText: AllTerms.signatureLabel,
        backgroundColor: MyColors.blueColor,
      ),*/
      appBar: AppBar(
        title: Text(
          "Upload Signatures",
          style: TextStyle(
              color: Colors.white, fontSize: fontSizeController.fontSize),
        ),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            signatureController.clearImages();
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (isUploading) return; // Prevent multiple clicks

              setState(() {
                isUploading = true; // Show loading indicator
              });

              if (signatureController.signatures.isEmpty) {
                setState(() => isUploading = false);
                Get.snackbar("Error", "No signatures to upload.");
                return;
              }

              // Loop through each signature and upload it
              for (var signature in signatureController.signatures) {
                await signatureController.uploadSignature(
                    signature,
                    widget.eventId.toString(),
                    "Signature Upload" // You can change description dynamically
                    );
              }

              setState(() {
                isUploading = false; // Hide loading indicator
              });

              _showSuccessDialog(); // ✅ Show success dialog after upload
            },
            icon: isUploading
                ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Icon(Icons.upload_file, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display file meta data from the database
              Obx(() {
                if (fileMetaController.fileMetaData.isEmpty &&
                    signatureController.signatures.isEmpty) {
                  return Center(child: Text('No file meta data available.'));
                }
                return _buildFileMetaDataList();
              }),

              SizedBox(height: 20),
              Obx(() => _buildSignatureGrid(context)),

              SizedBox(height: 20),
              _buildAddSignatureButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // Build signature grid (already defined in your code)
  Widget _buildSignatureGrid(BuildContext context) {
    // Check if there are any signatures
    if (fileMetaController.fileMetaData.isEmpty &&
        signatureController.signatures.isEmpty) {
      return Center(
        child: Text('No signatures added yet.'),
      );
    }
    return Wrap(
      spacing: 16.0,
      runSpacing: 16.0,
      children: List.generate(signatureController.signatures.length, (index) {
        return GestureDetector(
          onTap: () {
            print(signatureController.signatures[index]);
            // Get.to(PictureViewScreen(
            //   id: fileMeta.id,
            // ));
          },
          child: _buildSignatureBlock(context, index),
        );
      }),
    );
  }

  // Signature block UI (already defined in your code)

  Widget _buildSignatureBlock(BuildContext context, int index) {
    return GestureDetector(
      onTap: () async {
        print("🔹 Tapped on Signature: Index $index");

        if (signatureController.signatures.length > index) {
          final ui.Image signatureImage = signatureController.signatures[index];

          try {
            // Convert ui.Image to Uint8List
            ByteData? byteData =
                await signatureImage.toByteData(format: ui.ImageByteFormat.png);

            if (byteData != null) {
              Uint8List imageData = byteData.buffer.asUint8List();

              print(
                  "✅ Successfully converted signature: ${imageData.length} bytes");

              // Navigate to full-screen signature view
              // Get.to(() => FullScreenSignatureView(signatureData: imageData));
            } else {
              print("❌ Failed to convert signature to byte data.");
            }
          } catch (e) {
            print("❌ Error converting signature: $e");
          }
        } else {
          print(
              "❌ Invalid index: $index, Signature list length: ${signatureController.signatures.length}");
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 5.0),
          Obx(() {
            return signatureController.signatures.length > index
                ? _buildSignatureDisplay(
                    index, signatureController.signatures[index])
                : SizedBox.shrink();
          }),
          SizedBox(height: 5.0),
        ],
      ),
    );
  }

/*  Widget _buildSignatureBlock(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            _showSignatureDialog(context, index);
          },
          child: Obx(() {
            return Icon(
              Icons.edit,
              size: 30,
              color: (index == currentBlock.value &&
                      signatureController.signatures.length <= index)
                  ? Colors.black
                  : Colors.transparent,
            );
          }),
        ),
        SizedBox(height: 5.0),
        Obx(() {
          return signatureController.signatures.length > index
              ? _buildSignatureDisplay(
                  index, signatureController.signatures[index])
              : SizedBox.shrink();
        }),
        SizedBox(height: 5.0),
      ],
    );
  }*/

  // Signature dialog UI (already defined in your code)
  void _showSignatureDialog(BuildContext context, int index) {
    final _signaturePadKey = GlobalKey<SfSignaturePadState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Draw your signature'),
          content: Container(
            height: 300,
            width: double.maxFinite,
            child: SfSignaturePad(
              key: _signaturePadKey,
              backgroundColor: Colors.grey[200],
              strokeColor: Colors.black,
              minimumStrokeWidth: 1.0,
              maximumStrokeWidth: 4.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final signature =
                    await _signaturePadKey.currentState?.toImage();
                if (signature != null) {
                  signatureController.addSignature(signature);
                  currentBlock.value++; // Move to the next block
                }
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // Build file meta data list
  Widget _buildFileMetaDataList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: fileMetaController.fileMetaData.length,
      itemBuilder: (context, index) {
        final fileMeta = fileMetaController.fileMetaData[index];
        return _buildFileMetaBlock(context, index, fileMeta);
      },
    );
  }

  // FileMeta display block UI (similar to _buildSignatureDisplay)
  Widget _buildFileMetaBlock(BuildContext context, int index, var fileMeta) {
    return GestureDetector(
      onTap: () {
        print("xxxxxx");
        print(fileMeta.id);
        Get.to(FullScreenSignatureView(
          id: fileMeta.id,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
              height: 100,
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                fileMeta.fname ?? 'No Name',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                // onPressed: () {
                //   _showDeleteConfirmationDialog(context, index);
                // },
                onPressed: () {
                  String eventId = eventController.events[index].id; // Get event ID
                  _showDeleteConfirmationDialog(context, index, eventId);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index, String eventId) {
    Get.defaultDialog(
      title: "Delete Signature?",
      middleText: "Are you sure you want to delete this signature?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        if (index < fileMetaController.fileMetaData.length) {
          String fileId = fileMetaController.fileMetaData[index].id;
          fileMetaController.deleteSignatureFromServer(fileId, eventId);
        }
        Get.back(); // Close the dialog
      },
      onCancel: () => Get.back(),
    );
  }





  // Signature display widget (already defined in your code)
  Widget _buildSignatureDisplay(int index, ui.Image signature) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: RawImage(
              image: signature,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                signatureController.deleteSignature(index);
                currentBlock.value = index; // Re-enable the block for signing
              },
            ),
          ),
        ],
      ),
    );
  }

  // Add signature button (already defined in your code)
  Widget _buildAddSignatureButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (signatureController.signatures.length <
              signatureController.maxSignatures) {
            _showSignatureDialog(context, currentBlock.value);
          } else {
            Get.snackbar(
              'Limit Reached',
              'You have reached the maximum number of signatures',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        child: Text('Add Signature'),
      ),
    );
  }

  void _showSuccessDialog() {
    Get.defaultDialog(
      title: "Success",
      content: Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 50),
          SizedBox(height: 10),
          Text("Signatures uploaded successfully!",
              textAlign: TextAlign.center),
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

class SignaturePreviewScreen extends StatelessWidget {
  late String id;

  SignaturePreviewScreen({super.key, required this.id});

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
