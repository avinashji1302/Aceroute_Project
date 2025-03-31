import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/fontSizeController.dart';

void showAboutDialog(BuildContext context) {
  final fontSizeController = Get.find<FontSizeController>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              alignment: Alignment.center,
              //color: Colors.white,
              child: Text(
                'About Us',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: fontSizeController.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Field Service Management Right Person. Right Place. Right Time.',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: fontSizeController.fontSize),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Refresh All Data',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSizeController.fontSize),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: fontSizeController.fontSize),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}