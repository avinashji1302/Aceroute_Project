import 'package:ace_routes/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/event_controller.dart';
import '../controller/vehicle_controller.dart';
import '../controller/fontSizeController.dart';
import '../core/Constants.dart';
import '../core/colors/Constants.dart';
import '../view/appbar.dart';

class VehicleDetails extends StatefulWidget {
  final String id;

  VehicleDetails({super.key, required this.id});

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  final fontSizeController = Get.find<FontSizeController>();

  late final VehicleController _vehicleController;

  // Controllers for text fields
  late final TextEditingController vehicleDetailController;
  late final TextEditingController registrationController;
  late final TextEditingController odometerController;
  late final TextEditingController faultDescController;
  late final TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    // Initialize VehicleController with the provided id
    _vehicleController = Get.put(VehicleController(widget.id));

    // Initialize text controllers with initial values
    vehicleDetailController = TextEditingController();
    registrationController = TextEditingController();
    odometerController = TextEditingController();
    faultDescController = TextEditingController();
    notesController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    AllTerms.getTerm();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.blueColor,
        title: Obx(() => Text(
              AllTerms.orderGroupLabel.value,
              style: const TextStyle(color: Colors.white),
            )),
        centerTitle: true,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

        // Adding a back button with the same functionality
        actions: [
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
            onPressed: () async {
              // Collect data from controllers
              final updatedData = {
                'details': _vehicleController.vehicleDetail.value,
                'registration': _vehicleController.registration.value,
                'odometer': _vehicleController.odometer.value,
                'faultDesc': _vehicleController.faultDesc.value,
                'notes': _vehicleController.notes.value,
              };

              // Print the current values
              print("Vehicle details: ${vehicleDetailController.text}");
              print("Registration: ${_vehicleController.registration.value}");
              print("Odometer: ${_vehicleController.odometer.value}");
              print("Fault Description: ${_vehicleController.faultDesc.value}");

              // Call API to save the updated data
              //  await _vehicleController.edit(updatedData);
              await _vehicleController.offlineEdit(updatedData);

              // Navigate to HomeScreen (you can comment this line if you want it to stay on the current screen)
              //  Get.to(HomeScreen());

              print("go home:::");
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
              // Make/Model/Color TextFormField
              Obx(() => TextFormField(
                    controller: vehicleDetailController
                      ..text = _vehicleController.vehicleDetail.value,
                    decoration: InputDecoration(
                      labelText: 'Make/Model/Color',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) =>
                        _vehicleController.vehicleDetail.value = value,
                  )),
              SizedBox(height: 16),

              // Registration TextFormField
              Obx(() => TextFormField(
                    controller: registrationController
                      ..text = _vehicleController.registration.value,
                    decoration: InputDecoration(
                      labelText: 'Registration',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) =>
                        _vehicleController.registration.value = value,
                  )),
              SizedBox(height: 16),

              // Odometer TextFormField
              Obx(() => TextFormField(
                    controller: odometerController
                      ..text = _vehicleController.odometer.value,
                    decoration: InputDecoration(
                      labelText: 'Odometer',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) =>
                        _vehicleController.odometer.value = value,
                  )),
              SizedBox(height: 16),

              // Fault Description TextFormField
              Obx(() => TextFormField(
                    controller: faultDescController
                      ..text = _vehicleController.faultDesc.value,
                    decoration: InputDecoration(
                      labelText: 'Fault Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) =>
                        _vehicleController.faultDesc.value = value,
                  )),
              SizedBox(height: 16),

              // Notes TextFormField
              Obx(() => TextFormField(
                    controller: notesController
                      ..text = _vehicleController.notes.value,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) =>
                        _vehicleController.notes.value = value,
                  )),
              SizedBox(height: 20),

              // // Submit Button
              // ElevatedButton(
              //   onPressed: () async {
              //     print("Vehicle details: ${vehicleDetailController.text}");
              //     print(
              //         "Registration: ${_vehicleController.registration.value}");
              //     print("Odometer: ${_vehicleController.odometer.value}");
              //     print(
              //         "Fault Description: ${_vehicleController.faultDesc.value}");
              //
              //     // Collect data from controllers
              //     final updatedData = {
              //       'details': _vehicleController.vehicleDetail.value,
              //       'registration': _vehicleController.registration.value,
              //       'odometer': _vehicleController.odometer.value,
              //       'faultDesc': _vehicleController.faultDesc.value,
              //       'notes': _vehicleController.notes.value,
              //     };
              //
              //     print("alt os ${_vehicleController.faultDesc.value}");
              //
              //     // Call API to save the updated data
              //     await _vehicleController.edit(updatedData);
              //
              //     Get.to(HomeScreen());
              //   },
              //   child: Text('Submit', style: TextStyle(color: Colors.white)),
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: Size(double.infinity, 50),
              //     backgroundColor: Colors.blue,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
