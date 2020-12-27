import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/friend_provider.dart';

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColorDark,
      ),
      margin: EdgeInsets.only(
        left: isLeft ? 10 : 0,
        right: !isLeft ? 10 : 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 15),
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
                        fontSize: 15,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    Text(
                      friend.username,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container(width: 0.0, height: 0.0)),
              Container(
                width: 35,
                height: 35,
                child: IconButton(
                  icon: Icon(Icons.person_add),
                  iconSize: 20,
                  onPressed: () async => await context
                      .read(friendProvider)
                      .addFriend(friend: friend),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
