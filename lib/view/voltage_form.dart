import 'package:flutter/material.dart';
import '../core/colors/Constants.dart';
import '../model/GTypeModel.dart';

class VoltageForm extends StatefulWidget {
  final GTypeModel gType;
  const VoltageForm({super.key, required this.gType});

  @override
  State<VoltageForm> createState() => _VoltageFormState();
}

class _VoltageFormState extends State<VoltageForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gType.name,
          style: TextStyle(color: MyColors.whiteColor),
        ),
        backgroundColor: MyColors.blueColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          child: Column(
            children: [
              // Use the spread operator to expand the map result into the children list
              ...widget.gType.details['frm'].map<Widget>((item) {
                if (item['nm'] == 'cca') {
                  return Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: item['lbl'],
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20), // Space between fields
                    ],
                  );
                } else if (item['nm'] == 'voltage') {
                  return TextFormField(
                    decoration: InputDecoration(
                      labelText: item['lbl'],
                      border: OutlineInputBorder(),
                    ),
                  );
                } else {
                  return Container(); // Return an empty container for other cases
                }
              }).toList(), // Ensure the map returns a List of Widgets
            ],
          ),
        ),
      ),
    );
  }
}
