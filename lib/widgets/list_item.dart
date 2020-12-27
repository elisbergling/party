import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/state_provider.dart';

import 'cached_image.dart';

class ListItem extends HookWidget {
  final Friend friend;
  //final bool shouldAddGroup;
  //final bool isGroup;
  //final bool isFavorite;
  final bool isFirst;
  final bool isLast;
  final int index;

  ListItem({
    this.friend,
    //this.shouldAddGroup,
    //this.isGroup,
    //this.isFavorite,
    this.isFirst,
    this.isLast,
    this.index,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read(messageDataProvider).state = friend,
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
              friend.imgUrl,
              height: 50,
              width: 50,
              name: friend.name,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  //width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    friend.name,
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
