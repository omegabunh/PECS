// ignore_for_file: unused_field
//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//Providers
import '../providers/authentication_provider.dart';
import '../providers/chatlist_page_provider.dart';

//Services
import '../services/navigation_service.dart';
import '../services/database_service.dart';

//Pages
import '../pages/chats_page.dart';

//Widgets
import '../widgets/custom_list_view_tiles.dart';

//Models
import '../models/chat_room.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatListPageState();
  }
}

class _ChatListPageState extends State<ChatListPage> {
  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late double _deviceHeight;
  late double _deviceWidth;
  late NavigationService _navigation;
  late ChatListPageProvider _pageProvider;

  Widget _buildUI() {
    return Builder(builder: (BuildContext context) {
      _pageProvider = context.watch<ChatListPageProvider>();
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text(
            'ChatList',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight,
          width: _deviceWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _chatList(_auth.chatUser.uid),
            ],
          ),
        ),
      );
    });
  }

  Widget _chatList(String uid) {
    List<ChatRoom>? rooms = _pageProvider.chats;
    return Expanded(child: () {
      if (rooms != null) {
        if (rooms.isNotEmpty) {
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (BuildContext context, int index) {
              rooms.sort((a, b) => a.number.compareTo(b.number));
              return CustomListViewTile(
                height: _deviceHeight * 0.10,
                title: rooms[index].roomName,
                subtitle: rooms[index].number.toString(),
                isSelected: _pageProvider.selectedUsers.contains(
                  rooms[index],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("채팅방을 추가하시겠습니까?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(
                                () {
                                  _db.addMemberToRoom(rooms[index].uid, uid);
                                },
                              );
                              Navigator.pop(context);
                            },
                            child: const Text("예"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("아니오"),
                          )
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text(
              "대화방을 찾을 수 없습니다.",
            ),
          );
        }
      } else {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
    }());
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _db = GetIt.instance.get<DatabaseService>();
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatListPageProvider>(
          create: (_) => ChatListPageProvider(_auth),
        )
      ],
      child: _buildUI(),
    );
  }
}
