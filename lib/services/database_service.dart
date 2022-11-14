// ignore_for_file: avoid_print

import 'dart:convert';

//Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

//Models
import '../models/chat_message.dart';

const String userCollection = "Users";
const String chatCollection = "Chats";
const String messagesCollection = "Messages";

class DatabaseService {
  DatabaseService();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(String uid, String email, String name) async {
    try {
      await _db.collection(userCollection).doc(uid).set(
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
      await _db.collection(userCollection).doc(uid).set(
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
    return _db.collection(userCollection).doc(uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query query = _db.collection(userCollection);
    if (name != null) {
      query = query
          .where("name", isGreaterThanOrEqualTo: name)
          .where("name", isLessThanOrEqualTo: "${name}z");
    }
    return query.get();
  }

  Future<QuerySnapshot> getChatList({String? roomName}) {
    Query query = _db.collection(chatCollection);
    if (roomName != null) {
      query = query
          .where("roomName", isGreaterThanOrEqualTo: roomName)
          .where("roomName", isLessThanOrEqualTo: "${roomName}z");
    }
    return query.get();
  }

  Future<DocumentSnapshot> getChatRoom(String uid) {
    return _db.collection(chatCollection).doc(uid).get();
  }

  Stream<QuerySnapshot> getChatsForUser(String uid) {
    return _db
        .collection(chatCollection)
        .where('members', arrayContains: uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String chatID) {
    return _db
        .collection(chatCollection)
        .doc(chatID)
        .collection(messagesCollection)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String chatID) {
    return _db
        .collection(chatCollection)
        .doc(chatID)
        .collection(messagesCollection)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String chatID, ChatMessage message) async {
    try {
      await _db
          .collection(chatCollection)
          .doc(chatID)
          .collection(messagesCollection)
          .add(
            message.toJson(),
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String chatID) async {
    try {
      await _db.collection(chatCollection).doc(chatID).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> leaveChat(String chatID, String uid) async {
    try {
      await _db.collection(chatCollection).doc(chatID).update({
        "members": FieldValue.arrayRemove([uid]),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addMemberToRoom(String roomId, String uid) async {
    try {
      await _db.collection(chatCollection).doc(roomId).update({
        "members": FieldValue.arrayUnion([uid]),
      });
    } catch (e) {
      print(e);
    }
  }
}

Future<dynamic> getPlayer(String selectedPlatform, String playerName,
    String apiKey, int selectedSeason) async {
  try {
    Uri url = Uri.parse(
      "https://api.pubg.com/shards/$selectedPlatform/players?filter[playerNames]=$playerName",
    );
    Map<String, String> header = {
      "Authorization": "Bearer $apiKey",
      "Accept": "application/vnd.api+json"
    };
    var response = await http.get(url, headers: header);
    switch (response.statusCode) {
      case 200:
        var jsonData = response.body;
        final playerId = jsonDecode(jsonData)['data'][0]['id'];
        Uri lifeTimeUrl = Uri.parse(
            "https://api.pubg.com/shards/$selectedPlatform/players/$playerId/seasons/division.bro.official.pc-2018-$selectedSeason?filter[gamepad]=false");
        var lifeTimeResponse = await http.get(lifeTimeUrl, headers: header);
        var lifeTimeJsonData = lifeTimeResponse.body;
        var stats =
            jsonDecode(lifeTimeJsonData)['data']['attributes']['gameModeStats'];
        return stats;
      default:
        throw Exception(response.reasonPhrase);
    }
  } catch (e) {
    print(e);
  }
}
