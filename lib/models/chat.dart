import '../models/chat_user.dart';
import '../models/chat_message.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final String roomName;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> _recepients;

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.members,
    required this.messages,
    required this.roomName,
  }) {
    _recepients = members.where((i) => i.uid != currentUserUid).toList();
  }
  List<ChatUser> recepients() {
    return _recepients;
  }

  String title() {
    return roomName;
  }
}
