import 'package:flutter/material.dart';
import 'package:party/screens/home/friend_screen.dart';
import 'package:party/screens/home/messages_screen.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  static const routeName = '/message';

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 400,
          child: MessagesScreen(),
        ),
        Expanded(
          child: FriendScreen(),
        )
      ],
    );
  }
}
