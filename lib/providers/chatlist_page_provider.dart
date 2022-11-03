//Packages
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

  @override
  void dispose() {
    super.dispose();
  }

  void getChatList({String? roomName}) async {
    _selectedRoom = [];
    try {
      _db.getChatList(roomName: roomName).then(
        (_snapshot) {
          chats = _snapshot.docs
              .map((_doc) {
                Map<String, dynamic> _data =
                    _doc.data() as Map<String, dynamic>;
                _data["uid"] = _doc.id;
                return ChatRoom.fromJSON(_data);
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

  void updateSelectedRoom(ChatRoom _room) {
    if (_selectedRoom.contains(_room)) {
      _selectedRoom.remove(_room);
    } else {
      _selectedRoom.add(_room);
    }
    notifyListeners();
  }
}
