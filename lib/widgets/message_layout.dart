import 'package:flutter/material.dart';
import 'package:party/models/message.dart';

class MessageLayout extends StatelessWidget {
  const MessageLayout({
    Key key,
    @required this.isMe,
    @required this.message,
  }) : super(key: key);

  final bool isMe;
  final Message message;

  @override
  Widget build(BuildContext context) {
    List<String> dateTime =
        message.createdAt.toDate().toIso8601String().split('T');
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
                topRight: isMe ? Radius.circular(10.0) : Radius.circular(10.0),
                topLeft: isMe ? Radius.circular(10.0) : Radius.circular(10.0),
                bottomRight:
                    isMe ? Radius.circular(0.0) : Radius.circular(10.0),
                bottomLeft: isMe ? Radius.circular(10.0) : Radius.circular(0.0),
              ),
              color: isMe
                  ? Theme.of(context).primaryColorDark
                  : Theme.of(context).primaryColorDark,
            ),
            child: Text(
              message.message,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: !isMe
                    ? Theme.of(context).primaryColorLight
                    : Theme.of(context).primaryColorLight,
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
              dateTime[0] +
                  ' ' +
                  dateTime[1].split(':')[0] +
                  ':' +
                  dateTime[1].split(':')[1],
              textAlign: isMe ? TextAlign.end : TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
