import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party/screens/home/add_friend_screen.dart';
import 'package:party/screens/home/add_party_screen.dart';
import 'package:party/screens/home/profile_screen.dart';

import 'add_group_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key key}) : super(key: key);

  static const routeName = '/user';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 400,
            child: ProfileScreen(),
          ),
          Container(
            width: 400,
            child: AddFriendScreen(),
          ),
          Container(
            width: 400,
            child: AddGroupScreen(),
          ),
          Container(
            width: 400,
            child: AddPartyScreen(),
          ),
        ],
      ),
    );
  }
}
