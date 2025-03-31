import 'dart:convert';
import 'package:pubnub/pubnub.dart';
import 'package:sqflite/sqflite.dart';

class PubNubService {
  late PubNub _pubnub;
  late Subscription _subscription;
  final String namespace;
  final String rid;

  PubNubService({required this.namespace, required this.rid}) {
    _initializePubNub();
  }

  void _initializePubNub() {
    _pubnub = PubNub(
      defaultKeyset: Keyset(
        subscribeKey: 'sub-c-424c2436-49c8-11e5-b018-0619f8945a4f',
        userId: UserId("$namespace-$rid"),
      ),
    );

    _subscribeToChannel();
  }

  void _subscribeToChannel() {
    String channelName = '$namespace-$rid';
    print("Subscribing to channel: $channelName");
   
    _subscription = _pubnub.subscribe(channels: {channelName});

    print("Waiting for messages...");

    _subscription.messages.listen((envelope) {
      print("Message received: ${envelope.content}");
      _handleMessage(envelope.content);
    });
  }

  void _handleMessage(dynamic message) async {
    try {
      var jsonMessage = jsonDecode(message);
      String k = jsonMessage["k"];
      String u = jsonMessage["u"].trim().toLowerCase();
      int timestamp = int.parse(jsonMessage["s"]);
      String xml = jsonMessage["x"];

      print("xml value is ::::");
      print(xml);
      // Ignore irrelevant messages
      if (u == rid.toLowerCase()) return;

      List<String> parts = k.split('|');
      if (parts.length < 3) return;

      String msgType = parts[0];
      String actionType = parts[1];
      String id = parts[2];

      List<String> validMsgTypes = ["5", "6", "9", "13", "14", "24", "27"];
      if (!validMsgTypes.contains(msgType)) return;

      //  _processAction(msgType, actionType, id, xml, timestamp);
    } catch (e) {
      print("Error processing PubNub message: $e");
    }
  }

  void testPubNub() async {
    var pubnub = PubNub(
      defaultKeyset: Keyset(
        subscribeKey: 'sub-c-424c2436-49c8-11e5-b018-0619f8945a4f',
        userId: UserId("$namespace-$rid"),
      ),
    );

    var subscription = pubnub.subscribe(channels: {'demo.com-715297'});

    print("Subscribed... Waiting for messages...");

    subscription.messages.listen((envelope) {
      print("Message received: ${envelope.content}");
    });

    // Test sending a message
    pubnub.publish("demo.com-715297", {"text": "Hello from Flutter!"});
  }

  // Future<void> _processAction(String msgType, String actionType, String id,
  //     String xml, int timestamp) async {
  //   switch (actionType) {
  //     case "0": // Change
  //     case "3": // Update
  //       await _updateData(msgType, id, xml, timestamp);
  //       break;
  //     case "1": // Add
  //       await _addData(msgType, id, xml, timestamp);
  //       break;
  //     case "2": // Delete
  //       await _deleteData(msgType, id);
  //       break;
  //   }
  // }

  // Future<void> _updateData(
  //     String msgType, String id, String xml, int timestamp) async {
  //   await _database.insert(
  //     "pubnub_data",
  //     {"msgType": msgType, "id": id, "xml": xml, "timestamp": timestamp},
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Future<void> _addData(
  //     String msgType, String id, String xml, int timestamp) async {
  //   await _database.insert(
  //     "pubnub_data",
  //     {"msgType": msgType, "id": id, "xml": xml, "timestamp": timestamp},
  //   );
  // }

  // Future<void> _deleteData(String msgType, String id) async {
  //   await _database.delete("pubnub_data",
  //       where: "msgType = ? AND id = ?", whereArgs: [msgType, id]);
  // }

  void dispose() {
    _subscription.cancel();
  }
}
