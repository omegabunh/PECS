//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//Providers
import '../providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';

//Services
import '../services/navigation_service.dart';

//Pages
import '../pages/chat_page.dart';

//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

//Models
import '../models/chat.dart';
import '../models/chat_user.dart';
import '../models/chat_message.dart';
import '../models/chat_room.dart';
import '../widgets/rounded_button.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatsPageState();
  }
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late NavigationService _navigation;
  late ChatsPageProvider _pageProvider;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_auth),
        )
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<ChatsPageProvider>();
      return Container(
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
            TopBar(
              'Chats',
              primaryAction: IconButton(
                icon: const Icon(
                  Icons.logout,
                ),
                onPressed: () {
                  _auth.logout();
                },
              ),
            ),
            _chatList(),
          ],
        ),
      );
    });
  }

  Widget _chatList() {
    List<Chat>? _rooms = _pageProvider.chats;
    return Expanded(child: () {
      if (_rooms != null) {
        if (_rooms.isNotEmpty) {
          return ListView.builder(
            itemCount: _rooms.length,
            itemBuilder: (BuildContext _context, int _index) {
              return _chatTile(_rooms[_index]);
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

  // Widget _createChatButton() {
  //   return Visibility(
  //     visible: _pageProvider.selectedUsers.isNotEmpty,
  //     child: RoundedButton(
  //       name: _pageProvider.selectedUsers.length == 1 ? "1:1 채팅" : "그룹 채팅",
  //       height: _deviceHeight * 0.08,
  //       width: _deviceWidth * 0.80,
  //       onPressed: () {
  //         _pageProvider.createChat();
  //       },
  //     ),
  //   );
  // }

  Widget _chatTile(Chat _chat) {
    List<ChatUser> _recepients = _chat.recepients();
    String _subtitleText = "";
    if (_chat.messages.isNotEmpty) {
      _subtitleText = _chat.messages.first.type != MessageType.TEXT
          ? "사진"
          : _chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
        height: _deviceHeight * 0.10,
        title: _chat.title(),
        subtitle: _subtitleText,
        onTap: () {
          _navigation.navigateToPage(
            ChatPage(chat: _chat),
          );
        });
  }
}
