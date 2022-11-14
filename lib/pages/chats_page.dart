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
import '../pages/chat_list_page.dart';

//Widgets
import '../widgets/custom_list_view_tiles.dart';

//Models
import '../models/chat.dart';
import '../models/chat_user.dart';
import '../models/chat_message.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatsPageState();
  }
}

class _ChatsPageState extends State<ChatsPage> {
  late AuthenticationProvider _auth;
  late double _deviceHeight;
  late double _deviceWidth;
  late NavigationService _navigation;
  late ChatsPageProvider _pageProvider;

  Widget _buildUI() {
    return Builder(builder: (BuildContext context) {
      _pageProvider = context.watch<ChatsPageProvider>();
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text(
            'Chats',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.logout,
              ),
              onPressed: () {
                _auth.logout();
              },
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.03,
            ),
            height: _deviceHeight,
            width: _deviceWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _chatList(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigation.navigateToPage(
              const ChatListPage(),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      );
    });
  }

  Widget _chatList() {
    List<Chat>? rooms = _pageProvider.chats;
    return Expanded(child: () {
      if (rooms != null) {
        if (rooms.isNotEmpty) {
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (BuildContext context, int index) {
              return _chatTile(rooms[index]);
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

  Widget _chatTile(Chat chat) {
    // ignore: unused_local_variable
    List<ChatUser> recepients = chat.recepients();
    String subtitleText = "";
    if (chat.messages.isNotEmpty) {
      subtitleText = chat.messages.first.type != MessageType.text
          ? "사진"
          : chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
        height: _deviceHeight * 0.10,
        title: chat.title(),
        subtitle: subtitleText,
        onTap: () {
          _navigation.navigateToPage(
            ChatPage(chat: chat),
          );
        });
  }

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
}
