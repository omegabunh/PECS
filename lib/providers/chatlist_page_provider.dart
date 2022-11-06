//Packages
// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

//Providers
import '../providers/authentication_provider.dart';

//Models
import '../models/chat_room.dart';

class ChatListPageProvider extends ChangeNotifier {
  final AuthenticationProvider _auth;

  late DatabaseService _db;
  late NavigationService _navigation;
  List<ChatRoom>? chats;
  late List<ChatRoom> _selectedRoom;

  List<ChatRoom> get selectedUsers {
    return _selectedRoom;
  }

  ChatListPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    _selectedRoom = [];
    _navigation = GetIt.instance.get<NavigationService>();
    getChatList();
  }

  void getChatList({String? roomName}) async {
    _selectedRoom = [];
    try {
      _db.getChatList(roomName: roomName).then(
        (snapshot) {
          chats = snapshot.docs
              .map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                data["uid"] = doc.id;
                return ChatRoom.fromJSON(data);
              })
              .cast<ChatRoom>()
              .toList();
          notifyListeners();
        },
      );
    } catch (e) {
      print("채팅을 가져오는데 문제가 발생하였습니다.");
      print(e);
    }
  }

  void updateSelectedRoom(ChatRoom room) {
    if (_selectedRoom.contains(room)) {
      _selectedRoom.remove(room);
    } else {
      _selectedRoom.add(room);
    }
    notifyListeners();
  }
}
