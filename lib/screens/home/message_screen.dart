import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:party/screens/home/friend_screen.dart';
import 'package:party/screens/home/messages_screen.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key key}) : super(key: key);

  static const routeName = '/message';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 400,
            child: MessagesScreen(),
          ),
          Expanded(
            child: FriendScreen(),
          )
        ],
      ),
    );
  }
}
