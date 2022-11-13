import '../models/chat_user.dart';
import '../models/chat_message.dart';

class Chat {
  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.members,
    required this.messages,
    required this.roomName,
  }) {
    _recepients = members.where((i) => i.uid != currentUserUid).toList();
  }

  final String currentUserUid;
  final List<ChatUser> members;
  List<ChatMessage> messages;
  final String roomName;
  final String uid;

  late final List<ChatUser> _recepients;

  List<ChatUser> recepients() {
    return _recepients;
  }

  String title() {
    return roomName;
  }
}
