class ChatUser {
  final String uid;
  final String name;
  final String email;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
  });

  factory ChatUser.fromJSON(Map<String, dynamic> _json) {
    return ChatUser(
      uid: _json["uid"],
      name: _json["name"],
      email: _json["email"],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
    };
  }
}
