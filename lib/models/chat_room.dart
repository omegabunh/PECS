class ChatRoom {
  final String uid;
  final String roomName;
  final int number;

  ChatRoom({
    required this.uid,
    required this.roomName,
    required this.number,
  });

  factory ChatRoom.fromJSON(Map<String, dynamic> json) {
    return ChatRoom(
      uid: json["uid"],
      roomName: json["roomName"],
      number: json["number"],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "roomName": roomName,
      "number": number,
    };
  }
}
