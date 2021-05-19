import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/enum.dart';
import 'package:party/constants/global.dart';
import 'package:party/constants/colors.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/group.dart';
import 'package:party/models/message.dart';
import 'package:party/models/party.dart';
import 'package:party/providers/message_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/screens/home/friend_screen.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
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
    final controller =
        useAnimationController(duration: Duration(milliseconds: 10));
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
      onTapDown: (_) => controller.forward(),
      onTapUp: (_) => controller.reverse(),
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
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        key: Key(uid),
        child: AnimatedListTile(
          controller: controller,
          messageLastMessageStream: messageLastMessageStream,
          object: object,
        ),
      ),
    );
  }
}

class AnimatedListTile extends AnimatedWidget {
  const AnimatedListTile({
    AnimationController controller,
    @required this.messageLastMessageStream,
    @required this.object,
  }) : super(listenable: controller);

  final AsyncValue<Message> messageLastMessageStream;
  final object;
  AnimationController get controller => listenable;

  Row buildContent(object, BuildContext context, Message message) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 5),
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
              width: MediaQuery.of(context).size.width * 0.35,
              //width: 130,
              child: Text(
                object.name,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: dark,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Text(
                message.runtimeType == Message
                    ? message.message
                    : 'blablablabla',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: darkGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const Expanded(child: Text('')),
        if (message.runtimeType == Message &&
            Timestamp.fromMicrosecondsSinceEpoch(0) != message.createdAt)
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  message.runtimeType == Message
                      ? timeAGo(timestamp: message.createdAt)
                      : '24 hours',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: babyWhite,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(width: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 1.0, end: 0.0).animate(controller);
    return Material(
      elevation: animation.value,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.only(
          left: 6,
          top: 5,
          bottom: 5,
          right: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: babyWhite,
        ),
        height: 70,
        child: messageLastMessageStream.when(
          data: (message) {
            return buildContent(object, context, message);
          },
          loading: () => buildContent(object, context, null),
          error: (e, s) => MyErrorWidget(e: e, s: s),
        ),
      ),
    );
  }
}
