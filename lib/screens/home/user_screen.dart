import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party/screens/home/add_friend_screen.dart';
import 'package:party/screens/home/add_party_screen.dart';
import 'package:party/screens/home/profile_screen.dart';
import 'package:party/screens/home/add_group_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(
          width: 400,
          child: ProfileScreen(),
        ),
        SizedBox(
          width: 400,
          child: AddFriendScreen(),
        ),
        SizedBox(
          width: 400,
          child: AddGroupScreen(),
        ),
        SizedBox(
          width: 400,
          child: AddPartyScreen(),
        ),
      ],
    );
  }
}
