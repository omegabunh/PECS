class ChatList {
  ChatList({
    required this.uid,
    required this.roomName,
  });

  factory ChatList.fromJSON(Map<String, dynamic> json) {
    return ChatList(
      uid: json["uid"],
      roomName: json["roomName"],
    );
  }

  final String roomName;
  final String uid;

  Map<String, dynamic> toMap() {
    return {
      "roomName": roomName,
    };
  }
}
