import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening the Play Store

class UpdateDialog extends StatelessWidget {
  final VoidCallback onUpdate;

  UpdateDialog({required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Available'),
      content: Text('A newer version of the app is available. Please update to continue.'),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onUpdate,
          child: Text('Update'),
        ),
      ],
    );
  }
}

