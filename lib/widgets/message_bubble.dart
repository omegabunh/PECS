// ignore_for_file: use_key_in_widget_constructors

//Packages
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

//Models
import '../models/chat_message.dart';

class TextMessageBubble extends StatelessWidget {
  const TextMessageBubble(
      {required this.isOwnMessage,
      required this.message,
      required this.height,
      required this.width});

  final double height;
  final bool isOwnMessage;
  final ChatMessage message;
  final double width;

  Widget _platformText() {
    return SelectableText(
      message.content,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: isOwnMessage
              ? const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
          color: isOwnMessage
              ? const Color.fromRGBO(204, 255, 204, 1.0)
              : const Color.fromRGBO(153, 255, 153, 1.0),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _platformText(),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageMessageBubble extends StatelessWidget {
  const ImageMessageBubble(
      {required this.isOwnMessage,
      required this.message,
      required this.height,
      required this.width});

  final double height;
  final bool isOwnMessage;
  final ChatMessage message;
  final double width;

  @override
  Widget build(BuildContext context) {
    DecorationImage image = DecorationImage(
        image: NetworkImage(message.content), fit: BoxFit.cover);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: height * 0.03,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isOwnMessage
            ? const Color.fromRGBO(204, 255, 204, 1.0)
            : const Color.fromRGBO(153, 255, 153, 1.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: SizedBox(
              height: height,
              width: width,
              child: Hero(
                tag: '$image',
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: image,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      body: GestureDetector(
                        child: Center(
                          child: Hero(
                            tag: '$image',
                            child: PinchZoom(
                              resetDuration: const Duration(milliseconds: 100),
                              maxScale: 3,
                              child: Image.network(message.content),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
