class ChatList {
  final String uid;
  final String roomName;

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
  Map<String, dynamic> toMap() {
    return {
      "roomName": roomName,
    };
  }
}
