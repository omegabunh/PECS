//Packages
import 'package:cloud_firestore/cloud_firestore.dart';

//Models
import '../models/chat_message.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "Messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService() {}

  Future<void> createUser(String uid, String email, String name) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).set(
        {
          "email": email,
          "name": name,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateUser(String uid, String email, String name) async {
    try {
      await _db.collection(USER_COLLECTION).doc(uid).set(
        {
          "email": email,
          "name": name,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) {
    return _db.collection(USER_COLLECTION).doc(uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query query = _db.collection(USER_COLLECTION);
    if (name != null) {
      query = query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: "${name}z");
    }
    return query.get();
  }

  Future<QuerySnapshot> getChatList({String? roomName}) {
    Query query = _db.collection(CHAT_COLLECTION);
    if (roomName != null) {
      query = query
          .where("roomName", isGreaterThanOrEqualTo: roomName)
          .where("roomName", isLessThanOrEqualTo: "${roomName}z");
    }
    return query.get();
  }

  Future<DocumentSnapshot> getChatRoom(String uid) {
    return _db.collection(CHAT_COLLECTION).doc(uid).get();
  }

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return _db
        .collection(CHAT_COLLECTION)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String chatID, ChatMessage message) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(chatID)
          .collection(MESSAGES_COLLECTION)
          .add(
            message.toJson(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String chatID) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(chatID).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addMemberToRoom(String roomId, String uid) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(roomId).update({
        "members": FieldValue.arrayUnion([uid]),
      });
    } catch (e) {
      print(e);
    }
  }
}
