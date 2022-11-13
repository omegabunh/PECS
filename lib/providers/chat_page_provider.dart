// ignore_for_file: unused_field, prefer_final_fields, avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:async';

//Packages
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

//Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';

//Providers
import '../providers/authentication_provider.dart';

//Models
import '../models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier {
  ChatPageProvider(this._chatID, this._auth, this._messagesListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
  }

  List<ChatMessage>? messages;

  AuthenticationProvider _auth;
  String _chatID;
  late DatabaseService _db;
  late KeyboardVisibilityController _keyboardVisibilityController;
  late StreamSubscription _keyboardVisibilityStream;
  late MediaService _media;
  String? _message;
  ScrollController _messagesListViewController;
  late StreamSubscription _messagesStream;
  late NavigationService _navigation;
  late CloudStorageService _storage;

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  String get message {
    // ignore: recursive_getters
    return message;
  }

  set message(String _value) {
    _message = _value;
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessagesForChat(_chatID).listen(
        (_snapshot) {
          List<ChatMessage> _messages = _snapshot.docs.map(
            (_m) {
              Map<String, dynamic> _messageData =
                  _m.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(_messageData);
            },
          ).toList();
          messages = _messages;
          notifyListeners();
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              if (_messagesListViewController.hasClients) {
                _messagesListViewController.jumpTo(
                    _messagesListViewController.position.maxScrollExtent);
              }
            },
          );
        },
      );
    } catch (e) {
      print("메시지를 가져오는데 문제가 발생하였습니다.");
      print(e);
    }
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
        content: _message!,
        type: MessageType.TEXT,
        senderID: _auth.chatUser.uid,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(_chatID, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        String? _downloadURL = await _storage.saveChatImageToStorage(
            _chatID, _auth.chatUser.uid, _file);
        ChatMessage _messageToSend = ChatMessage(
          content: _downloadURL!,
          type: MessageType.IMAGE,
          senderID: _auth.chatUser.uid,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(_chatID, _messageToSend);
      }
    } catch (e) {
      print("이미지를 보내는데 문제가 발생하였습니다.");
      print(e);
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatID);
  }

  void leaveChat() {
    goBack();
    _db.leaveChat(_chatID, _auth.chatUser.uid);
  }

  void goBack() {
    _navigation.goBack();
  }
}
