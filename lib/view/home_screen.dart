import 'dart:async';
import 'package:ace_routes/controller/all_terms_controller.dart';
import 'package:ace_routes/controller/event_controller.dart';
import 'package:ace_routes/controller/loginController.dart';
import 'package:ace_routes/controller/map_controller.dart';
import 'package:ace_routes/controller/status_updated_controller.dart';
import 'package:ace_routes/core/Constants.dart';
import 'package:ace_routes/core/colors/Constants.dart';
import 'package:ace_routes/database/Tables/api_data_table.dart';
import 'package:ace_routes/database/Tables/event_table.dart';
import 'package:ace_routes/database/Tables/terms_data_table.dart';
import 'package:ace_routes/database/Tables/version_api_table.dart';
import 'package:ace_routes/view/audio.dart';
import 'package:ace_routes/view/e_from.dart';
import 'package:ace_routes/view/part.dart';
import 'package:ace_routes/view/pic_upload_screen.dart';
import 'package:ace_routes/view/picture_view_screen.dart';
import 'package:ace_routes/view/signature_scree.dart';
import 'package:ace_routes/view/status_screen.dart';
import 'package:ace_routes/view/summary_screen.dart';
import 'package:ace_routes/view/vehicle_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:ace_routes/view/drawer.dart';
import 'package:ace_routes/controller/homeController.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../Widgets/icon_with_badge.dart';
import '../controller/clockout/clockout_controller.dart';
import '../controller/file_meta_controller.dart';
import '../controller/fontSizeController.dart';
import '../controller/getOrderPart_controller.dart';
import '../database/Tables/OrderTypeDataTable.dart';
import '../database/Tables/PartTypeDataTable.dart';
import '../database/Tables/login_response_table.dart';
import '../database/Tables/status_table.dart';
import '../database/databse_helper.dart';
import '../model/login_model/login_response.dart';
import 'add_bw_from.dart';
import 'add_part.dart';
import 'directory_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homeController = Get.put(HomeController());
  final Completer<GoogleMapController> _mapController = Completer();
  final LoginController loginController =
      Get.find<LoginController>(); // Accessing LoginController
  final FileMetaController fileMetaController = Get.put(FileMetaController());

  StreamSubscription<geo.Position>? _positionStreamSubscription;
  final AllTermsController allTermsController = Get.put(AllTermsController());
  bool _showCard = true;
  final FontSizeController fontSizeController = Get.put(FontSizeController());
  final EventController eventController = Get.put(EventController());
  final StatusControllers statusControllers = Get.put(StatusControllers());
  final MapControllers mapControllers = Get.put(MapControllers());
  final controller = Get.put(GetOrderPartController());
  final ClockOut clockOut = Get.find<ClockOut>();

  List<bool> temp = [true, false];

  bool tapped = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  String formatEventDate(String? startDate) {
    if (startDate == null || startDate.isEmpty) {
      return "No Time";
    }

    try {
      // Define the expected input format
      DateFormat inputFormat = DateFormat("yyyy/MM/dd HH:mm Z");

      // Parse the date string into a DateTime object
      DateTime date = inputFormat.parse(startDate);

      // Format to "MMM" (e.g., Nov)
      String formattedDate = DateFormat("MMM").format(date);

      // Format local time
      String localTime = DateFormat.jm().format(date.toLocal());

      return "$formattedDate, $localTime";
    } catch (e) {
      return "Invalid date";
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Building");

    AllTerms.getTerm();
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(homeController.getFormattedDate(),
                  style: TextStyle(
                    fontSize: fontSizeController.fontSize,
                  )),
              SizedBox(height: 4),
              Text(
                homeController.getFormattedDay(),
                style: TextStyle(
                    fontSize: fontSizeController.fontSize, color: Colors.black),
              ),
            ],
          );
        }),
        centerTitle: true,
        actions: [
          Obx(() => Container(
                margin: const EdgeInsets.only(right: 16.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Text(
                  '${eventController.events.length}',
                  style: const TextStyle(color: Colors.white),
                ),
              )),
        ],
        elevation: 5,
        backgroundColor: Colors.white,
      ),
      drawer:  DrawerWidget(),
      body: _showCard
          ? Obx(() {
              // Check if data is loading
              if (eventController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(), // Display loading spinner
                );
              }

              // Check if eventController.events list is empty
              if (eventController.events.isEmpty) {
                return Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              // Display events in a list
              return ListView.builder(
                itemCount: eventController.events.length,
                itemBuilder: (context, index) {
                  //sequence in order time
                  // Sort events by time in ascending order
                  //   eventController.events.sort((a, b) => a.startDate.compareTo(b.startDate));

                  final event = eventController.events[index];

                  final statusText =
                      eventController.nameMap[event.wkf] ?? 'Unknown Status';

                  final categoryValue =
                      eventController.categoryMap[event.tid] ??
                          'Unknown Status';

                  final priorityValue = eventController.priorityId[event.pid] ??
                      'Unknown priority';

                  String priorityColorString =
                      eventController.priorityColorsId[event.pid] ??
                          "#000000"; // Default to black if null
                  priorityColorString = priorityColorString.replaceFirst(
                      "#", "0xFF"); // Convert to Flutter ARGB format

                  final int priorityColor =
                      int.parse(priorityColorString); // Convert to int
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => StatusScreen(
                                  oid: event.id,
                                  name: event.wkf,
                                ))?.then((updatedStatus) {
                              if (updatedStatus != null) {
                                // Update the nameMap for the specific wkf
                                eventController.nameMap[event.wkf] =
                                    updatedStatus;
                              }
                            });
                          },
                          child: Container(
                            color: MyColors.blueColor,
                            padding: const EdgeInsets.all(12.0),
                            width: double.infinity,
                            child: Center(
                              child: Obx(() => Text(
                                    // Observing changes in currentStatus or nameMap
                                    eventController.nameMap[event.wkf]
                                                ?.isNotEmpty ??
                                            false
                                        ? eventController.nameMap[event.wkf]!
                                        : statusText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.access_time_filled,
                                      size: 45,
                                      color: MyColors.blueColor,
                                    ),
                                    onPressed: () {
                                      Get.to(() => SummaryDetails(
                                          id: event.id, tid: event.tid));
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        // Dynamically calculate values based on the available width
                                        double responsiveFontSize =
                                            constraints.maxWidth *
                                                0.04; // 4% of width
                                        double responsiveWidth =
                                            constraints.maxWidth *
                                                0.8; // 30% of width
                                        double responsiveHeight =
                                            constraints.maxWidth *
                                                0.3; // 10% of width

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width:
                                                  responsiveWidth, // Responsive width
                                              height:
                                                  responsiveHeight, // Responsive height
                                              decoration: BoxDecoration(
                                                color: Colors.grey[500],
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    responsiveFontSize *
                                                        0.5), // Responsive padding
                                                child: Center(
                                                  child: Text(
                                                    formatEventDate(
                                                        event.startDate),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: fontSizeController
                                                          .fontSize, // Responsive font size
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: constraints.maxWidth *
                                                    0.02), // 2% of width as spacing
                                            Text(
                                              event.name ?? "No name",
                                              style: TextStyle(
                                                fontSize: fontSizeController
                                                    .fontSize, // Responsive font size
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                                height: constraints.maxWidth *
                                                    0.01), // 1% of width as spacing
                                            Obx(
                                              () => Center(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${categoryValue}:",
                                                      style: TextStyle(
                                                        fontSize: fontSizeController
                                                            .fontSize, // Responsive font size
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${priorityValue}",
                                                      style: TextStyle(
                                                        fontSize: fontSizeController
                                                            .fontSize, // Responsive font size
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                            priorityColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    width: 60,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.green[500],
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${(index + 1)}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: fontSizeController.fontSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              // Additional event details row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.watch_later_outlined,
                                      size: 45,
                                      color: MyColors.blueColor,
                                    ),
                                    onPressed: () {
                                      Get.to(() => DirectoryDetails(
                                          id: event.id, ctid: event.ctid));
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.cnm ?? "No Name",
                                          style: TextStyle(
                                            fontSize:
                                                fontSizeController.fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        Text(
                                          event.address ?? "No Alt",
                                          style: TextStyle(
                                            fontSize:
                                                fontSizeController.fontSize,
                                            // fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          event.cntnm ?? "No Alt",
                                          style: TextStyle(
                                            fontSize:
                                                fontSizeController.fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          event.tel ?? "No Alt",
                                          style: TextStyle(
                                            fontSize:
                                                fontSizeController.fontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Container(
                                    width: 60,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: MyColors.blueColor,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        final List<String> coordinates =
                                            event.geo.split(',');
                                        final LatLng targetLocation = LatLng(
                                          double.parse(
                                              coordinates[0]), // Latitude
                                          double.parse(
                                              coordinates[1]), // Longitude
                                        );
                                        mapControllers
                                            .launchURL(targetLocation);
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.directions,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.list,
                                      size: 45,
                                      color: MyColors.blueColor,
                                    ),
                                    onPressed: () {
                                      Get.to(() => VehicleDetails(
                                            id: event.id,
                                          ));
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          // width: 140,
                                          // height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Obx(() {
                                            if (index <
                                                eventController.events.length) {
                                              return Text(
                                                '${eventController.events[index].detail}',
                                                style: TextStyle(
                                                  fontSize: fontSizeController
                                                      .fontSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              );
                                            } else {
                                              return Text(
                                                  'No event available for this index.');
                                            }
                                          }),
                                        ),
                                        Obx(() => RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        '${eventController.events[index].po}\n${eventController.events[index].inv}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          fontSizeController
                                                              .fontSize,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              // Actions row
                              Container(
                                color: Colors.grey[200],
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //added cunt  ******EForm Type*************
                                    // EForm Type with Badge
                                    IconButtonWithBadge(
                                      icon: Icons.person_2_sharp,
                                      badgeCount:
                                          '0', // Replace with your dynamic count
                                      onPressed: () {
                                        Get.to(EFormScreen(
                                            tid: eventController
                                                .events[index].tid));
                                      },
                                      badgePositionLeft: 0,
                                      badgePositionTop: 0,
                                    ),

                                    //************ Part Type**********

                                    // Part Type with Badge
                                    IconButtonWithBadge(
                                      icon: Icons.tips_and_updates,
                                      badgeCount: "1",
                                      // Replace with your dynamic count
                                      onPressed: () {
                                        Get.to(PartScreen(
                                          oid: eventController.events[index].id,
                                        ));
                                      },
                                      badgePositionLeft: 0,
                                      badgePositionTop: 0,
                                    ),

                                    // Part Type with Badge
                                    IconButtonWithBadge(
                                      icon: Icons.camera_alt_outlined,
                                      badgeCount:
                                          '3', // Replace with your dynamic count
                                      onPressed: () async {
                                        // Get the event ID
                                        String eventId =
                                            eventController.events[index].id;

                                        // Fetch and save the file meta data
                                        try {
                                          await fileMetaController
                                              .fetchAndSaveFileMeta(eventId);
                                          // Navigate to the Signature screen after the API call succeeds
                                          Get.to(() => PicUploadScreen(
                                              eventId: int.parse(eventId)));
                                        } catch (error) {
                                          // Handle errors, e.g., show a snackbar or dialog
                                          Get.snackbar(
                                            'Error',
                                            'Failed to fetch file metadata: $error',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                                      badgePositionLeft: 0,
                                      badgePositionTop: 0,
                                    ),

                                    // Part Type with Badge
                                    IconButtonWithBadge(
                                      icon: Icons.mic,
                                      badgeCount:
                                          '0', // Replace with your dynamic count
                                      onPressed: () async {
                                        // Get the event ID
                                        String eventId =
                                            eventController.events[index].id;

                                        // Fetch and save the file meta data
                                        try {
                                          await fileMetaController
                                              .fetchAndSaveFileMeta(eventId);
                                          // Navigate to the Signature screen after the API call succeeds
                                          Get.to(() => AudioRecord(
                                              eventId: int.parse(eventId)));
                                        } catch (error) {
                                          // Handle errors, e.g., show a snackbar or dialog
                                          Get.snackbar(
                                            'Error',
                                            'Failed to fetch file metadata: $error',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                                      badgePositionLeft: 0,
                                      badgePositionTop: 0,
                                    ),

                                    // Part Type with Badge
                                    IconButtonWithBadge(
                                      icon: Icons.edit,
                                      badgeCount:
                                          '0', // Replace with your dynamic count
                                      onPressed: () {
                                        Get.to(() => Signature(
                                            eventId: int.parse(eventController
                                                .events[index].id)));
                                      },
                                      badgePositionLeft: 0,
                                      badgePositionTop: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            })
          : Container(
              child: MapScreen(),
            ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.mail_rounded, size: 30),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined, size: 30),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.watch_later_outlined, size: 30),
                label: tapped ? 'Clocked In' : "Clocked Out",
              ),
            ],
            currentIndex: homeController.selectedIndex.value,
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.blueAccent[300],
            selectedLabelStyle:
                TextStyle(fontSize: fontSizeController.fontSize),
            unselectedLabelStyle:
                TextStyle(fontSize: fontSizeController.fontSize * 0.9),
            onTap: (index) {
              setState(() {
                if (index == 0) {
                  _showCard = true; // Show card
                } else if (index == 1) {
                  // Map tab

                  _showCard = false; // Hide card

                  homeController.getCurrentLocation();
                } else if (index == 2) {
                  // Clocked In tab
                  //  _showCard = false; // Hide card
                  print('object');
                  tapped = !tapped;
                  // Find the first two events whose status is NOT "Completed"
                  List<String> nonCompletedEventIds = eventController.events
                      .where((event) =>
                          eventController.nameMap[event.wkf] != "Completed")
                      .map((event) => event.id)
                      .take(2)
                      .toList();

                  String? lstoid = nonCompletedEventIds.isNotEmpty
                      ? nonCompletedEventIds[0]
                      : null;
                  String? nxtoid = nonCompletedEventIds.length > 1
                      ? nonCompletedEventIds[1]
                      : null;

                  // Execute action with filtered event IDs
                  clockOut.executeAction(
                      lstoid: lstoid, nxtoid: nxtoid, tid: tapped ? 1 : 2);

                  print("clocked in lstoid  $lstoid  nxtoid $nxtoid  ");

                  // clockOut.executeAction(tid: tapped ? 1 : 2);

                  print("clocked in   $tapped");
                }
              });
              homeController.onItemTapped(index);
            },
          )),
    );
  }
}
