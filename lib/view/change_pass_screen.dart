import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/changePassController.dart';
import '../controller/fontSizeController.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ChangePasswordController controller = Get.put(ChangePasswordController());
  final fontSizeController = Get.find<FontSizeController>();
  @override
  Widget build(BuildContext context) {
    final fontSizeController = Get.find<FontSizeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password',style: TextStyle(fontSize: fontSizeController.fontSize),),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(() => TextField(
              onChanged: (value) {
                controller.currentPassword.value = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                errorText: controller.currentPasswordError.value.isNotEmpty
                    ? controller.currentPasswordError.value
                    : null,
                border: const OutlineInputBorder(),
              ),
            )),
            const SizedBox(height: 16.0),
            Obx(() => TextField(
              onChanged: (value) {
                controller.newPassword.value = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
                errorText: controller.newPasswordError.value.isNotEmpty
                    ? controller.newPasswordError.value
                    : null,
                border: const OutlineInputBorder(),
              ),
            )),
            const SizedBox(height: 16.0),
            Obx(() => TextField(
              onChanged: (value) {
                controller.reEnterPassword.value = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Re-enter New Password',
                errorText: controller.reEnterPasswordError.value.isNotEmpty
                    ? controller.reEnterPasswordError.value
                    : null,
                border: const OutlineInputBorder(),
              ),
            )),
            const SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.validateAndSubmit,
                child: const Text('Submit', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
