import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/addBwForm_controller.dart';
import '../core/colors/Constants.dart';
import '../model/GTypeModel.dart';

class AddBwForm extends StatefulWidget {
  final GTypeModel gType;

  const AddBwForm({Key? key, required this.gType}) : super(key: key);

  @override
  State<AddBwForm> createState() => _AddBwFormState();
}

class _AddBwFormState extends State<AddBwForm> {
  final controller = Get.put(AddBwFormController());

  @override
  void initState() {
    super.initState();
    controller.initializeTextControllers(widget.gType.details['frm']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gType.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColors.blueColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: widget.gType.details['frm']
                .map<Widget>((item) => buildFormField(item))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildFormField(Map<String, dynamic> item) {
    switch (item['id']) {
      case 1: // For text fields
        return buildTextField(item);
      case 2: // For radio buttons
        return buildRadioOptions(item);
      case 3: // For image picker
        return buildImagePicker(item);
      case 4: // For multi-select options
        return buildMultiSelectOptions(item);
      default:
        return Container(); // Empty container for unsupported IDs
    }
  }

  // TextField for technician name
  Widget buildTextField(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller.textEditingControllers[item['nm']],
        decoration: InputDecoration(
          labelText: item['lbl'],
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildRadioOptions(Map<String, dynamic> item) {
    List<String> options = item['ddn'].split(',');
    List<String> values = item['ddnval'].split(',');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item['lbl'], style: const TextStyle(fontWeight: FontWeight.bold)),
          Column(
            children: [
              for (int i = 0; i < options.length; i += 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Expanded(
                      child: Obx(
                            () => RadioListTile<String>(
                          title: Text(options[i]),
                          value: values[i],
                          groupValue: controller.selectedValue.value,
                          onChanged: (newValue) {
                            controller.selectedValue.value = newValue!;
                          },
                        ),
                      ),
                    ),
                    if (i + 1 < options.length)
                      Expanded(
                        child: Obx(
                              () => RadioListTile<String>(
                            title: Text(options[i + 1]),
                            value: values[i + 1],
                            groupValue: controller.selectedValue.value,
                            onChanged: (newValue) {
                              controller.selectedValue.value = newValue!;
                            },
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }


  // Multi-select for options
  Widget buildMultiSelectOptions(Map<String, dynamic> item) {
    List<String> options = item['ddn'].split(',');
    List<String> values = item['ddnval'].split(',');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item['lbl'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          ...List.generate(options.length, (index) {
            return Obx(
              () => CheckboxListTile(
                title: Text(
                  options[index],
                  style: TextStyle(
                    color: controller.selectedValues.contains(values[index])
                        ? Colors.blue
                        : Colors.black,
                  ),
                ),
                value: controller.selectedValues.contains(values[index]),
                onChanged: (isSelected) {
                  if (isSelected == true) {
                    controller.selectedValues.add(values[index]);
                  } else {
                    controller.selectedValues.remove(values[index]);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // Image picker for uploading an image
  Widget buildImagePicker(Map<String, dynamic> item) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Text(item['lbl'], style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (_) {
                return SafeArea(
                  child: Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.photo_camera),
                        title: const Text('Take a picture'),
                        onTap: () {
                          Navigator.of(context).pop();
                          controller.pickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Choose from gallery'),
                        onTap: () {
                          Navigator.of(context).pop();
                          controller.pickImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Obx(
            () => Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: controller.selectedImage.value == null
                  ? const Center(
                      child:
                          Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                    )
                  : Image.file(
                      File(controller.selectedImage.value!.path),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
