import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import '../controller/event_controller.dart';
import '../controller/fontSizeController.dart';
import '../controller/summary_controller.dart';
import '../core/Constants.dart';
import '../core/colors/Constants.dart';
import '../view/appbar.dart';

class SummaryDetails extends StatelessWidget {
  final String id;
  final String tid;

  SummaryDetails({super.key, required this.id, required this.tid});

  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    // Initialize the SummaryController with the id
    Get.lazyPut(() => SummaryController(id));

    final SummaryController summaryController = Get.find<SummaryController>();
    final fontSizeController = Get.find<FontSizeController>();

    const double spacing = 10.0;
    const EdgeInsets padding = EdgeInsets.all(8.0);

    Widget buildInfoRow(String label, Widget editableWidget) {
      return Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(color: Colors.black),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.green[500],
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              padding: padding,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: editableWidget,
              ),
            ),
          ],
        ),
      );
    }

    // Function to show the duration picker
    void showDurationPicker(BuildContext context) {
      // Default duration (convert to hours and minutes)
      int totalMinutes = int.tryParse(summaryController.duration.value) ?? 0;
      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Select Duration",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hours Picker
                        Expanded(
                          child: Column(
                            children: [
                              Text("Hours",
                                  style: TextStyle(color: Colors.black)),
                              NumberPicker(
                                minValue: 0,
                                maxValue: 12,
                                value: hours,
                                onChanged: (newValue) {
                                  setState(() {
                                    hours = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        // Minutes Picker
                        Expanded(
                          child: Column(
                            children: [
                              Text("Minutes",
                                  style: TextStyle(color: Colors.black)),
                              NumberPicker(
                                minValue: 0,
                                maxValue: 59,
                                value: minutes,
                                onChanged: (newValue) {
                                  setState(() {
                                    minutes = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Calculate the total minutes and update the controller
                        int totalDurationInMinutes = hours * 60 + minutes;
                        summaryController.duration.value =
                            '$totalDurationInMinutes'; // Save in minutes
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text("Set Duration"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      // appBar: myAppBar(
      //   context: context,
      //   titleText: AllTerms.summaryLabel,
      //   backgroundColor: MyColors.blueColor,
      // ),

      appBar: AppBar(
        title: Obx(() => Text(
              AllTerms.summaryLabel.value,
              style: const TextStyle(color: Colors.white),
            )),
        centerTitle: true,
        backgroundColor: MyColors.blueColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              print("summary");
            },
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Obx(() {
          return ListView(
            padding: EdgeInsets.all(spacing),
            children: [
              Container(
                color: const Color.fromARGB(255, 242, 255, 243),
                padding: padding,
                width: double.infinity,
                child: Text(
                  '$id , ${summaryController.nm.value}',
                  style: TextStyle(
                      fontSize: fontSizeController.fontSize,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: spacing),
              Container(
                color: const Color.fromARGB(255, 242, 255, 243),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInfoRow(
                      'Scheduled Date',
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            summaryController.startDate.value =
                                "${pickedDate.toLocal()}".split(' ')[0];
                          }
                        },
                        child: Text(
                          summaryController.startDate.value.isEmpty
                              ? 'Select Date'
                              : summaryController.startDate.value,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    buildInfoRow(
                      'Start Time',
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            summaryController.startTime.value =
                                pickedTime.format(context);
                          }
                        },
                        child: Text(
                          summaryController.startTime.value.isEmpty
                              ? 'Select Time'
                              : summaryController.startTime.value,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing),
              Container(
                color: const Color.fromARGB(255, 242, 255, 243),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInfoRow(
                      'Duration',
                      GestureDetector(
                        onTap: () {
                          showDurationPicker(
                              context); // Open the duration picker
                        },
                        child: Text(
                          summaryController.duration.value.isEmpty
                              ? 'Select Duration'
                              : '${summaryController.duration.value} minute',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    buildInfoRow(
                      'Category',
                      Text(
                        eventController.categoryMap[tid] ?? 'N/A',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    buildInfoRow(
                      'Priority',
                      Text(
                        'P5: Normal',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
