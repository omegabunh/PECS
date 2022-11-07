// ignore_for_file: prefer_const_constructors_in_immutables

//Packages
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

//Widgets
import '../widgets/rounded_image.dart';
import '../widgets/message_bubble.dart';

//Models
import '../models/chat_user.dart';
import '../models/chat_message.dart';

class CustomListViewTile extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final bool isSelected;
  final Function onTap;

  CustomListViewTile({
    Key? key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    return ListTile(
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.white) : null,
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class CustomListViewTileWithActivity extends StatelessWidget {
  final double height;
  final String title;
  final String subtitle;
  final Function onTap;

  CustomListViewTileWithActivity({
    Key? key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
      ),
    );
  }
}

class CustomChatListViewTile extends StatelessWidget {
  final double width;
  final double deviceHeight;
  final bool isOwnMessage;
  final ChatMessage message;
  final ChatUser sender;

  CustomChatListViewTile({
    Key? key,
    required this.width,
    required this.deviceHeight,
    required this.isOwnMessage,
    required this.message,
    required this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !isOwnMessage
              ? Text(
                  sender.name,
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                )
              : Container(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment:
                isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              !isOwnMessage
                  ? Container()
                  : Text(
                      timeago.format(message.sentTime, locale: 'ko'),
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
              SizedBox(
                width: width * 0.01,
              ),
              message.type == MessageType.TEXT
                  ? TextMessageBubble(
                      isOwnMessage: isOwnMessage,
                      message: message,
                      height: deviceHeight * 0.06,
                      width: width,
                    )
                  : ImageMessageBubble(
                      isOwnMessage: isOwnMessage,
                      message: message,
                      height: deviceHeight * 0.30,
                      width: width * 0.55,
                    ),
              isOwnMessage
                  ? Container()
                  : Text(
                      timeago.format(message.sentTime, locale: 'ko'),
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomProfileTile extends StatelessWidget {
  final double height;
  final String title;
  final String imagePath;
  final bool isActive;

  CustomProfileTile(
      {Key? key,
      required this.height,
      required this.title,
      required this.imagePath,
      required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    return Column(
      children: [
        ListTile(
          minVerticalPadding: height * 0.20,
          leading: RoundedImageNetwork(
            key: UniqueKey(),
            size: height / 2,
            imagePath: imagePath,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
