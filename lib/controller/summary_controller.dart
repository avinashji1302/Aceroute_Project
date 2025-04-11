import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../database/Tables/event_table.dart'; // EventTable for DB operations
import '../model/event_model.dart';
import 'event_controller.dart';

class SummaryController extends GetxController {
  // Collecting summary data
  RxString eventId = "".obs;
  RxString nm = "".obs;
  RxString startTime = "".obs;
  RxString category = "".obs;
  RxString duration = "".obs;
  RxString startDate = "".obs;
  RxString endDate = "".obs;

  final String id; // Add an id parameter

  SummaryController(this.id); // Constructor to accept id

  @override
  void onInit() {
    super.onInit();
    fetchSummaryDetails();
    print("id is $id");
  }

  Future<void> fetchSummaryDetails() async {
    // This data is coming from event database
    Event? localEvent = await EventTable.fetchEventById(id);

    if (localEvent != null) {
      eventId.value = localEvent.id ?? '';
      nm.value = localEvent.nm ?? '';
      startDate.value = localEvent.start_date ?? '';
      endDate.value = localEvent.end_date ?? '';

      // Calculate the duration
      calculateDuration();
      startDate.value = formatEventDate(startDate.value);
    } else {
      print("No event found for the given ID");
    }
  }

  // Function to format the event date and time
  String formatEventDate(String? date) {
    if (date == null || date.isEmpty) {
      return "No Time";
    }

    try {
      // Define the expected input format (e.g., "2025/02/03 10:00 -00:00")
      DateFormat inputFormat = DateFormat("yyyy/MM/dd HH:mm Z");

      // Parse the date string into a DateTime object
      DateTime dateTime = inputFormat.parse(date);

      // Format to "MMM dd, yyyy" (e.g., Feb 03, 2025)
      String formattedDate = DateFormat("MMM dd yyyy").format(dateTime);

      // Format local time (e.g., "1:30 PM")
      String localTime = DateFormat.jm().format(dateTime.toLocal());
      startTime.value = localTime;

      return "$formattedDate";
    } catch (e) {
      return "Invalid date";
    }
  }

  // Function to calculate the duration between start and end time
  void calculateDuration() {
    try {
      // Define the input format for startDate and endDate
      DateFormat inputFormat = DateFormat("yyyy/MM/dd HH:mm Z");

      // Parse the startDate and endDate into DateTime objects
      DateTime start = inputFormat.parse(startDate.value);
      DateTime end = inputFormat.parse(endDate.value);

      // Calculate the duration (difference between end and start)
      Duration difference = end.difference(start);

      // Store the duration in minutes
      duration.value = difference.inMinutes.toString();

      // Log the duration to ensure it's working
      print("Duration in minutes: ${duration.value}");
    } catch (e) {
      print("Error calculating duration: $e");
    }
  }
}
