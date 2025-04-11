// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final _notifications = FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidInit);

//     await _notifications.initialize(initSettings);
//   }

//   static Future<void> showNotification({
//     required String title,
//     required String body,
//     int id = 0,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'pubnub_channel',
//       'PubNub Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//     );

//     const notificationDetails = NotificationDetails(android: androidDetails);

//     await _notifications.show(id, title, body, notificationDetails);
//   }
// }
