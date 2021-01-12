import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/enum.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/group.dart';
import 'package:party/models/party.dart';
import 'package:party/providers/state_provider.dart';

import 'cached_image.dart';

class ListItem extends HookWidget {
  final Friend friend;
  final Group group;
  final Party party;
  //final bool shouldAddGroup;
  //final bool isGroup;
  //final bool isFavorite;
  final bool isFirst;
  final bool isLast;
  final int index;

  ListItem({
    this.friend,
    this.group,
    this.party,
    //this.shouldAddGroup,
    //this.isGroup,
    //this.isFavorite,
    this.isFirst,
    this.isLast,
    this.index,
  });
  @override
  Widget build(BuildContext context) {
    final messageType = useProvider(messageTypeProvider);
    dynamic object;
    switch (messageType.state) {
      case MessageType.Friends:
        object = friend;
        break;
      case MessageType.Groups:
        object = group;
        break;
      case MessageType.Parties:
        object = party;
        break;
    }
    return GestureDetector(
      onTap: () {
        switch (messageType.state) {
          case MessageType.Friends:
            context.read(messageDataProvider).state = friend;
            break;
          case MessageType.Groups:
            context.read(messageDataProvider).state = group;
            break;
          case MessageType.Parties:
            context.read(messageDataProvider).state = party;
            break;
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          right: 10,
          left: 10,
          bottom: isLast ? 14 : 7,
          top: isFirst ? 14 : 7,
        ),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColorDark,
        ),
        height: 70,
        child: Row(
          children: <Widget>[
            const SizedBox(width: 10),
            CachedImage(
              object.imgUrl,
              height: 50,
              width: 50,
              name: object.name,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  //width: MediaQuery.of(context).size.width * 0.5,
                  width: 230,
                  child: Text(
                    object.name,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 22),
                Container(
                  //width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    'message',
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(child: Text('')),
            Container(
              height: 30,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColorDark,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
