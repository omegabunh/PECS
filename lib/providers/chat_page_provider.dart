// ignore_for_file: unused_field, avoid_print

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

  final AuthenticationProvider _auth;
  final String _chatID;
  late DatabaseService _db;
  late KeyboardVisibilityController _keyboardVisibilityController;
  late StreamSubscription _keyboardVisibilityStream;
  late MediaService _media;
  String? _message;
  final ScrollController _messagesListViewController;
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

  set message(String value) {
    _message = value;
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessagesForChat(_chatID).listen(
        (snapshot) {
          List<ChatMessage> messageList = snapshot.docs.map(
            (m) {
              Map<String, dynamic> messageData =
                  m.data() as Map<String, dynamic>;
              return ChatMessage.fromJSON(messageData);
            },
          ).toList();
          messages = messageList;
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
      print(e);
    }
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage messageToSend = ChatMessage(
        content: _message!,
        type: MessageType.text,
        senderID: _auth.chatUser.uid,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(_chatID, messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? file = await _media.pickImageFromLibrary();
      if (file != null) {
        String? downloadURL = await _storage.saveChatImageToStorage(
            _chatID, _auth.chatUser.uid, file);
        ChatMessage messageToSend = ChatMessage(
          content: downloadURL!,
          type: MessageType.image,
          senderID: _auth.chatUser.uid,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(_chatID, messageToSend);
      }
    } catch (e) {
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
