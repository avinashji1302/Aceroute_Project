import 'dart:typed_data';

import 'package:ace_routes/core/Constants.dart';
import 'package:ace_routes/core/colors/Constants.dart';
import 'package:ace_routes/view/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:ace_routes/controller/signature_controller.dart';
import '../controller/file_meta_controller.dart';
import '../database/databse_helper.dart';

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

  final RxInt currentBlock = 0.obs;
  @override
  void initState() {
    super.initState();
    fileMetaController.fetchFileSignatureDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        context: context,
        titleText: AllTerms.signatureLabel,
        backgroundColor: MyColors.blueColor,
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
  }

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
    return Padding(
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
              onPressed: () {
                //fileMetaController.deleteFileMeta(index);
              },
            ),
          ),
        ],
      ),
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
}
