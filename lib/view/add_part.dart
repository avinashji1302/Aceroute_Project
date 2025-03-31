import 'package:ace_routes/controller/barcode_controller.dart';
import 'package:ace_routes/core/Constants.dart';
import 'package:ace_routes/core/colors/Constants.dart';
import 'package:ace_routes/view/appbar.dart';
import 'package:ace_routes/view/part.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/fontSizeController.dart';
import '../controller/getOrderPart_controller.dart';
import '../model/orderPartsModel.dart';

class AddPart extends StatefulWidget {
  String oid;
  final OrderParts? part; // Nullable for new parts
  final partTypeData;
  AddPart({super.key, required this.oid, this.part, this.partTypeData});

  @override
  State<AddPart> createState() => _AddPartState();
}

class _AddPartState extends State<AddPart> {
  String? _selectedCategory; // Variable to store selected category
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final fontSizeController = Get.find<FontSizeController>();
  final BarcodeController _barcodeController = Get.put(BarcodeController());
  final controller = Get.find<GetOrderPartController>();

  @override
  void initState() {
    super.initState();

    // If updating, pre-fill fields
    if (widget.part != null) {
      print("widget.partTypeData!.name");
      print(widget.partTypeData!.name);
      _selectedCategory = widget.partTypeData!.name;
      _skuController.text = widget.part!.sku;
      _quantityController.text = widget.part!.qty.toString();
      print(_selectedCategory);
    }

    print(_selectedCategory);

    // Listen to changes in scannedData
    ever(_barcodeController.scannedData, (data) {
      _skuController.text = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    AllTerms.getTerm();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.part == null ? AllTerms.partName.value : "Edit Part",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              if (widget.part == null) {
                // New Part
                await controller.SaveOrderPart(_selectedCategory!,
                    _quantityController.text, _skuController.text, widget.oid);
              } else {
                // Update Part
                await controller.EditPart(
                    widget.part!.id,
                    widget.oid,
                    controller.categoryId, // Use the updated tid
                    _quantityController.text,
                    _skuController.text);
                print("edit");
              }



              Get.back(result: true);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Dropdown
              Obx(() {
                // Ensure categories are unique
                final uniqueCategories = controller.categories.toSet().toList();

                // If _selectedCategory is not in the list, set it to null
                if (_selectedCategory != null &&
                    !uniqueCategories.contains(_selectedCategory)) {
                  _selectedCategory = null;
                }

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedCategory,
                      items: uniqueCategories
                          .map((category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                          controller.FetchPartTypeId(_selectedCategory!);
                        });
                      },
                    ),
                  ),
                );
              }),
              SizedBox(height: 20),

              // SKU Barcode Scanner
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _skuController,
                          decoration: InputDecoration(
                            labelText: 'SKU',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.qr_code_scanner),
                        onPressed: () {
                          print('Button pressed');
                          _barcodeController.scanBarcode();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Quantity Input
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  print(
                      "$_selectedCategory ${_quantityController.text} ${_skuController.text}");
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), // Full width button
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
