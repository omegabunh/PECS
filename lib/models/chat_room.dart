class ChatRoom {
  final String uid;
  final String roomName;
  final int number;

  ChatRoom({
    required this.uid,
    required this.roomName,
    required this.number,
  });

  factory ChatRoom.fromJSON(Map<String, dynamic> _json) {
    return ChatRoom(
      uid: _json["uid"],
      roomName: _json["roomName"],
      number: _json["number"],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "roomName": roomName,
      "number": number,
    };
  }
}
