import '../models/chat_user.dart';
import '../models/chat_message.dart';

class ChatList {
  final String uid;
  final String roomName;

  ChatList({
    required this.uid,
    required this.roomName,
  });

  factory ChatList.fromJSON(Map<String, dynamic> _json) {
    return ChatList(
      uid: _json["uid"],
      roomName: _json["roomName"],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "roomName": roomName,
    };
  }
}
