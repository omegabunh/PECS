// ignore_for_file: avoid_print

import 'dart:async';

//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Services
import '../services/database_service.dart';

//Providers
import '../providers/authentication_provider.dart';

//Models
import '../models/chat.dart';
import '../models/chat_message.dart';
import '../models/chat_user.dart';
import '../models/chat_room.dart';

class ChatsPageProvider extends ChangeNotifier {
  final AuthenticationProvider _auth;

  late DatabaseService _db;
  late StreamSubscription _chatsStream;

  List<Chat>? chats;

  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    _chatsStream.cancel();
    super.dispose();
  }

  void getChats({String? roomName}) async {
    try {
      _chatsStream =
          _db.getChatsForUser(_auth.user.uid).listen((snapshot) async {
        chats = await Future.wait(
          snapshot.docs.map(
            (d) async {
              Map<String, dynamic> chatData = d.data() as Map<String, dynamic>;
              //Get Users In Chat
              List<ChatUser> members = [];
              for (var uid in chatData["members"]) {
                DocumentSnapshot userSnapshot = await _db.getUser(uid);
                Map<String, dynamic> userData =
                    userSnapshot.data() as Map<String, dynamic>;
                userData["uid"] = userSnapshot.id;
                members.add(
                  ChatUser.fromJSON(userData),
                );
              }
              //Get Last Message For Chat
              List<ChatMessage> messages = [];
              QuerySnapshot chatMessage = await _db.getLastMessageForChat(d.id);
              if (chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> messageData =
                    chatMessage.docs.first.data()! as Map<String, dynamic>;
                ChatMessage message = ChatMessage.fromJSON(messageData);
                messages.add(message);
              }

              List<ChatRoom> rooms = [];
              DocumentSnapshot<Object?> roomName = await _db.getChatRoom(d.id);
              Map<String, dynamic> data = d.data() as Map<String, dynamic>;
              data["uid"] = d.id;
              ChatRoom room = ChatRoom.fromJSON(data);
              rooms.add(room);

              //Return Chat Instance
              return Chat(
                uid: d.id,
                currentUserUid: _auth.user.uid,
                members: members,
                messages: messages,
                roomName: room.roomName,
              );
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print("채팅을 가져오는데 문제가 발생하였습니다.");
      print(e);
    }
  }
}
