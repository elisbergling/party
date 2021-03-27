import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/enum.dart';
import 'package:party/constants/global.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/group.dart';
import 'package:party/models/message.dart';
import 'package:party/models/party.dart';
import 'package:party/providers/message_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/screens/home/friend_screen.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

import 'cached_image.dart';

class ListItem extends HookWidget {
  final Friend friend;
  final Group group;
  final Party party;
  //final bool shouldAddGroup;
  //final bool isGroup;
  //final bool isFavorite;
  //final int index;

  ListItem({
    this.friend,
    this.group,
    this.party,
    //this.shouldAddGroup,
    //this.isGroup,
    //this.isFavorite,
    //this.index,
  });
  @override
  Widget build(BuildContext context) {
    final messageType = useProvider(messageTypeProvider);
    String uid;
    dynamic object;
    switch (messageType.state) {
      case MessageType.Friends:
        object = friend;
        uid = friend.uid;
        break;
      case MessageType.Groups:
        object = group;
        uid = group.id;
        break;
      case MessageType.Parties:
        object = party;
        uid = party.id;
        break;
    }
    final messageLastMessageStream =
        useProvider(messageLastMessageStreamProvider(uid));
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
        Navigator.pushNamed(context, FriendScreen.routeName);
      },
      child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 7,
          ),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColorDark,
          ),
          height: 70,
          child: messageLastMessageStream.when(
              data: (message) {
                return message.runtimeType == Message
                    ? Row(
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
                                  message.message,
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
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColorDark,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  timeAGo(timestamp: message.createdAt),
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
                      )
                    : Container(color: Colors.red, child: Text('Error'));
              },
              loading: () => MyLoadingWidget(),
              error: (e, s) => MyErrorWidget(e: e, s: s))),
    );
  }
}
