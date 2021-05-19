import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/screens/home/friend_screen.dart';

import 'cached_image.dart';

class AddFriendTile extends HookWidget {
  final Friend friend;
  final bool isLeft;

  AddFriendTile({
    this.friend,
    this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    final uid = useProvider(authStateChangesProvider).data.value.uid;
    return Container(
      margin: EdgeInsets.only(
        left: isLeft ? 10 : 0,
        right: !isLeft ? 10 : 0,
      ),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 165,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: babyWhite,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 10),
                  CachedImage(
                    friend.imgUrl,
                    height: 50,
                    width: 50,
                    name: friend.name,
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          friend.name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: dark,
                          ),
                        ),
                        Text(
                          friend.username,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                            color: darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Container(width: 0.0, height: 0.0)),
                  friend.friendUids.contains(uid)
                      ? buildButton(context, CupertinoIcons.bubble_left, () {
                          context.read(messageDataProvider).state = friend;
                          Navigator.pushNamed(context, FriendScreen.routeName);
                        })
                      : buildButton(
                          context,
                          CupertinoIcons.person_add,
                          () async => await context
                              .read(friendProvider)
                              .addFriend(friend: friend)),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildButton(
      BuildContext context, IconData icon, Function onPressed) {
    return Container(
      width: 35,
      height: 35,
      child: IconButton(
        icon: Icon(icon),
        iconSize: 20,
        onPressed: onPressed,
      ),
    );
  }
}
