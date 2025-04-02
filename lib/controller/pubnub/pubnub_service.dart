import 'package:pubnub/pubnub.dart';

class PubNubService {
  late PubNub pubnub;
  late Subscription subscription;
  final String userId;
  final String namespace;
  final String subscriptionKey;

  PubNubService({
    required this.userId,
    required this.namespace,
    required this.subscriptionKey,
  }) {
    // Initialize PubNub
    pubnub = PubNub(
      defaultKeyset: Keyset(
        subscribeKey: subscriptionKey,
        userId: UserId('$namespace-$userId'),
      ),
    );

    // Subscribe to channel
    _subscribeToChannel();
    print(
        "✅ Initialized PubNub: UserID = $userId, SubscriptionKey = $subscriptionKey");
  }

  /// ✅ Subscribe to PubNub Channel
  void _subscribeToChannel() {
    print("🔔 Subscribing to: $namespace");

    subscription = pubnub.subscribe(channels: {namespace});

    // Listen for messages
    subscription.messages.listen((envelope) {
      _handleMessage(envelope);
    });
  }

  /// ✅ Handle Incoming Messages
  void _handleMessage(Envelope envelope) {
    final message = envelope.payload;
    print("📩 New PubNub Message: $message");

    if (message is! Map<String, dynamic>) {
      print("❌ Ignored: Invalid message format");
      return;
    }

    // Ignore messages from other channels
    if (envelope.channel != namespace) {
      print("❌ Ignored: Message is not from our namespace");
      return;
    }

    // Extract message components
    String? k = message['k'];
    String? u = message['u'];
    String? s = message['s'];
    String? x = message['x'];

    if (k == null || u == null || s == null || x == null) {
      print("❌ Ignored: Missing required message fields");
      return;
    }

    // Split 'k' to extract MsgType and ActionType
    List<String> kParts = k.split('|');
    if (kParts.length < 3) {
      print("❌ Ignored: Invalid 'k' format");
      return;
    }

    int msgType = int.tryParse(kParts[0]) ?? -1;
    int actionType = int.tryParse(kParts[1]) ?? -1;
    String id = kParts[2];

    // Ignore messages from the same user
    if (u.trim().toLowerCase() == userId.trim().toLowerCase()) {
      print("❌ Ignored: Message is from the same user");
      return;
    }

    // Process only relevant message types
    List<int> validMsgTypes = [5, 6, 9, 13, 14, 24, 27];
    if (!validMsgTypes.contains(msgType)) {
      print("❌ Ignored: MsgType $msgType is not relevant");
      return;
    }

    // Add message to processing queue
    _processMessage(msgType, actionType, id, x, int.tryParse(s) ?? 0);
  }

  /// ✅ Process Messages in Queue
  List<Map<String, dynamic>> messageQueue = [];

  void _processMessage(
      int msgType, int actionType, String id, String xml, int timestamp) {
    // Add message to queue
    messageQueue.add({
      'msgType': msgType,
      'actionType': actionType,
      'id': id,
      'xml': xml,
      'timestamp': timestamp,
    });

    // Sort messages by timestamp (ascending order)
    messageQueue.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

    // Process each message
    for (var message in messageQueue) {
      int msgType = message['msgType'];
      int actionType = message['actionType'];
      String id = message['id'];
      String xml = message['xml'];

      print("🔄 Processing MsgType: $msgType, Action: $actionType, ID: $id");

      // Perform action based on ActionType
      switch (actionType) {
        case 0:
          _updateData(msgType, id, xml);
          break;
        case 1:
          _addData(msgType, id, xml);
          break;
        case 2:
          _deleteData(msgType, id);
          break;
        case 3:
          _modifyData(msgType, id, xml);
          break;
        default:
          print("❌ Ignored: Unknown action type $actionType");
      }
    }

    // Clear processed messages
    messageQueue.clear();
  }

  // Data Handling Methods (To be implemented)
  void _addData(int msgType, String id, String xml) {
    print("✅ Added Data: MsgType: $msgType, ID: $id");
  }

  void _updateData(int msgType, String id, String xml) {
    print("✅ Updated Data: MsgType: $msgType, ID: $id");
  }

  void _deleteData(int msgType, String id) {
    print("✅ Deleted Data: MsgType: $msgType, ID: $id");
  }

  void _modifyData(int msgType, String id, String xml) {
    print("✅ Modified Data: MsgType: $msgType, ID: $id");
  }
}
