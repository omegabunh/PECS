class ChatUser {
  final String uid;
  final String name;
  final String email;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
  });

  factory ChatUser.fromJSON(Map<String, dynamic> json) {
    return ChatUser(
      uid: json["uid"],
      name: json["name"],
      email: json["email"],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
    };
  }
}
