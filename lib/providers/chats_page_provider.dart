// ignore_for_file: avoid_print

import 'dart:async';

//Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

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
  // late NavigationService _navigation;
  // List<ChatRoom>? chats;
  // late List<ChatRoom> _selectedRoom;

  // List<ChatRoom> get selectedUsers {
  //   return _selectedRoom;
  // }

  List<Chat>? chats;

  late StreamSubscription _chatsStream;

  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    // _selectedRoom = [];
    // _navigation = GetIt.instance.get<NavigationService>();
    getChats();
  }

  @override
  void dispose() {
    _chatsStream.cancel();
    super.dispose();
  }

  // void getChats({String? roomName}) async {
  //   _selectedRoom = [];
  //   try {
  //     _db.getChatRoom(roomName: roomName).then(
  //       (_snapshot) {
  //         chats = _snapshot.docs
  //             .map((_doc) {
  //               Map<String, dynamic> _data =
  //                   _doc.data() as Map<String, dynamic>;
  //               _data["uid"] = _doc.id;
  //               return ChatRoom.fromJSON(_data);
  //             })
  //             .cast<ChatRoom>()
  //             .toList();
  //         notifyListeners();
  //       },
  //     );
  //   } catch (e) {
  //     print("채팅을 가져오는데 문제가 발생하였습니다.");
  //     print(e);
  //   }
  // }

  // void updateSelectedRoom(ChatRoom _room) {
  //   if (_selectedRoom.contains(_room)) {
  //     _selectedRoom.remove(_room);
  //   } else {
  //     _selectedRoom.add(_room);
  //   }
  //   notifyListeners();
  // }

  void getChats({String? roomName}) async {
    try {
      _chatsStream =
          _db.getChatsForUser(_auth.user.uid).listen((_snapshot) async {
        chats = await Future.wait(
          _snapshot.docs.map(
            (_d) async {
              Map<String, dynamic> _chatData =
                  _d.data() as Map<String, dynamic>;
              //Get Users In Chat
              List<ChatUser> _members = [];
              for (var _uid in _chatData["members"]) {
                DocumentSnapshot _userSnapshot = await _db.getUser(_uid);
                Map<String, dynamic> _userData =
                    _userSnapshot.data() as Map<String, dynamic>;
                _userData["uid"] = _userSnapshot.id;
                _members.add(
                  ChatUser.fromJSON(_userData),
                );
              }
              //Get Last Message For Chat
              List<ChatMessage> _messages = [];
              QuerySnapshot _chatMessage =
                  await _db.getLastMessageForChat(_d.id);
              if (_chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> _messageData =
                    _chatMessage.docs.first.data()! as Map<String, dynamic>;
                ChatMessage _message = ChatMessage.fromJSON(_messageData);
                _messages.add(_message);
              }

              List<ChatRoom> _rooms = [];
              DocumentSnapshot<Object?> _roomName =
                  await _db.getChatRoom(_d.id);
              Map<String, dynamic> _data = _d.data() as Map<String, dynamic>;
              _data["uid"] = _d.id;
              ChatRoom _room = ChatRoom.fromJSON(_data);
              _rooms.add(_room);

              //Return Chat Instance
              return Chat(
                uid: _d.id,
                currentUserUid: _auth.user.uid,
                members: _members,
                messages: _messages,
                roomName: _room.roomName,
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
