//Packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/chat_input_fields.dart';

//Modles
import '../models/chat.dart';
import '../models/chat_message.dart';

//Porviders
import '../providers/authentication_provider.dart';
import '../providers/chat_page_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.chat});

  final Chat chat;

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  late AuthenticationProvider _auth;
  late double _deviceHeight;
  late double _deviceWidth;
  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;
  late ChatPageProvider _pageProvider;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext context) {
        _pageProvider = context.watch<ChatPageProvider>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Center(
              child: Text(
                widget.chat.title(),
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.output_rounded,
                ),
                onPressed: () {
                  _pageProvider.leaveChat();
                },
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          body: Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _deviceWidth * 0.03,
                ),
                height: _deviceHeight,
                width: _deviceWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _messagesListView(),
                    _sendMessageForm(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return CupertinoScrollbar(
          thickness: 6.0,
          thicknessWhileDragging: 10.0,
          radius: const Radius.circular(34.0),
          radiusWhileDragging: Radius.zero,
          child: SizedBox(
            height: _deviceHeight * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              controller: _messagesListViewController,
              itemCount: _pageProvider.messages!.length,
              itemBuilder: (BuildContext context, int index) {
                ChatMessage message = _pageProvider.messages![index];
                bool isOwnMessage = message.senderID == _auth.chatUser.uid;
                return CustomChatListViewTile(
                  deviceHeight: _deviceHeight,
                  width: _deviceWidth * 0.80,
                  message: message,
                  isOwnMessage: isOwnMessage,
                  sender: widget.chat.members
                      .where((m) => m.uid == message.senderID)
                      .first,
                );
              },
            ),
          ),
        );
      } else {
        return const Flexible(
          flex: 1,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "만나서 반가워요!",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }
  }

  Widget _sendMessageForm() {
    // ignore: unused_local_variable
    late String text;
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: Form(
        key: _messageFormState,
        child: ChatTextFormField(
          size: _deviceHeight * 0.04,
          onSaved: (value) {
            text = _pageProvider.message = value;
          },
          regEx: r"^(?!\s*$).+",
          message: '',
          send: () {
            if (_messageFormState.currentState!.validate()) {
              _messageFormState.currentState!.save();
              _pageProvider.sendTextMessage();
              _messageFormState.currentState!.reset();
            }
          },
          imageSend: () {
            _pageProvider.sendImageMessage();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatPageProvider>(
            create: (_) => ChatPageProvider(
              widget.chat.uid,
              _auth,
              _messagesListViewController,
            ),
          )
        ],
        child: _buildUI(),
      ),
    );
  }
}
