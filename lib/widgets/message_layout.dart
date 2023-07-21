import 'package:flutter/material.dart';
import 'package:party/constants/colors.dart';
import 'package:party/constants/global.dart';
import 'package:party/models/message.dart';

class MessageLayout extends StatelessWidget {
  const MessageLayout({
    super.key,
    required this.isMe,
    required this.message,
  });

  final bool isMe;
  final Message message;

  @override
  Widget build(BuildContext context) {
    String time = timeAGo(timestamp: message.createdAt);
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: isMe ? 0 : 60,
        left: isMe ? 60 : 0,
      ),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: isMe
                ? const EdgeInsets.only(
                    bottom: 14,
                    top: 14,
                    left: 14,
                    right: 11,
                  )
                : const EdgeInsets.only(
                    bottom: 14,
                    top: 14,
                    left: 11,
                    right: 14,
                  ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: isMe
                    ? const Radius.circular(10.0)
                    : const Radius.circular(10.0),
                topLeft: isMe
                    ? const Radius.circular(10.0)
                    : const Radius.circular(10.0),
                bottomRight: isMe
                    ? const Radius.circular(0.0)
                    : const Radius.circular(10.0),
                bottomLeft: isMe
                    ? const Radius.circular(10.0)
                    : const Radius.circular(0.0),
              ),
              gradient: LinearGradient(
                colors: isMe
                    ? [
                        MyColors.blue.withOpacity(0.6),
                        MyColors.blue.withOpacity(0.8),
                      ]
                    : [MyColors.dark, MyColors.dark],
                tileMode: TileMode.clamp,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              //color: isMe ? blue : dark,
            ),
            child: Text(
              message.message,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: isMe ? MyColors.white : MyColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 0,
              left: 3,
              right: 3,
            ),
            child: Text(
              time,
              textAlign: isMe ? TextAlign.end : TextAlign.start,
              style: const TextStyle(
                color: MyColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
