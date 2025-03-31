import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/drawerController.dart';
import '../controller/fontSizeController.dart';
import '../view/home_screen.dart';

void FontSizeDialog(
    BuildContext context,
    DrawerControllers drawerController,
    FontSizeController fontSizeController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Font Size',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                Column(
                  children: [
                    _buildRadioOption(context, 'Extra Small', 'extra_small',
                        drawerController),
                    _buildRadioOption(
                        context, 'Small', 'small', drawerController),
                    _buildRadioOption(
                        context, 'Medium', 'medium', drawerController),
                    _buildRadioOption(
                        context, 'Large', 'large', drawerController),
                    _buildRadioOption(context, 'Extra Large', 'extra_large',
                        drawerController),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showRestartDialog(context, fontSizeController);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildRadioOption(BuildContext context, String text, String value,
    DrawerControllers drawerController) {
  return Obx(() {
    return RadioListTile<String>(
      title: Text(text),
      value: value,
      groupValue: drawerController.selectedFontSize.value,
      activeColor: Colors.green,
      onChanged: (String? newValue) {
        drawerController.updateFontSize(newValue!);
      },
    );
  });
}

void _showRestartDialog(
    BuildContext context, FontSizeController fontSizeController) {
  final fontSizeController = Get.find<FontSizeController>();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'ACE Routes',
          style: TextStyle(
            fontSize: fontSizeController.fontSize,
          ),
        ),
        content: Text(
          'This App collects Location data to enable Schedule Optimization, Assign Work by Proximity, and send ETA Notifications even when the app is closed or in background. To disable Location tracking, please click "Clockout" within the App or Logout of the App. No Location data will be captured in above two scenarios.',
          style: TextStyle(
            fontSize: fontSizeController.fontSize,
          ),
        ),
        actions: <Widget>[
          Container(
            width: double.infinity,
            child: ElevatedButton(
              child: Text('OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSizeController.fontSize,
                  )),
              onPressed: () {
                _restartApp(fontSizeController);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void _restartApp(FontSizeController fontSizeController) {
  fontSizeController.applyFontSize();
  Get.offAll(() => HomeScreen()); // Replace with your HomeScreen route
}

