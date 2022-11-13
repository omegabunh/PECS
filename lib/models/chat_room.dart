class ChatRoom {
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

  final int number;
  final String roomName;
  final String uid;

  Map<String, dynamic> toMap() {
    return {
      "roomName": roomName,
      "number": number,
    };
  }
}
