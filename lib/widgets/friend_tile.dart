import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/screens/home/friend_screen.dart';
import 'package:party/widgets/cached_image.dart';

import 'border_gradient.dart';

class FriendTile extends HookWidget {
  const FriendTile({
    Key key,
    this.friend,
    this.isForParty = false,
    this.isForGroup = false,
  }) : super(key: key);

  final Friend friend;
  final bool isForParty;
  final bool isForGroup;

  bool initValue(List<String> party, List<String> group) {
    if (isForParty) {
      return party.any((uid) => uid == friend.uid);
    } else {
      return group.any((uid) => uid == friend.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final invitedUids = useProvider(invitedUidsProvider);
    final groupMembersUids = useProvider(groupMembersUidsProvider);
    final isSelected =
        useState(initValue(invitedUids.state, groupMembersUids.state));
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
      height: 120,
      child: BorderGradient(
        child: Container(
          key: Key(friend.uid),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected.value
                ? Colors.transparent
                : !isForGroup && !isForParty
                    ? black
                    : dark,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: CachedImage(
                  friend.imgUrl,
                  height: 80,
                  width: 80,
                  name: friend.name,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    friend.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: white,
                    ),
                  ),
                  Text(
                    friend.username,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: grey,
                    ),
                  ),
                  isForParty || isForGroup
                      ? IconButton(
                          padding: const EdgeInsets.all(0),
                          icon: isSelected.value
                              ? Icon(CupertinoIcons.person_badge_minus)
                              : Icon(CupertinoIcons.person_add),
                          iconSize: 24,
                          onPressed: () {
                            isSelected.value = !isSelected.value;

                            if (isForParty) {
                              if (invitedUids.state
                                  .any((uid) => uid == friend.uid)) {
                                context
                                    .read(invitedUidsProvider)
                                    .state
                                    .remove(friend.uid);
                              } else {
                                context
                                    .read(invitedUidsProvider)
                                    .state
                                    .add(friend.uid);
                              }
                              print(invitedUids.state.toString());
                            } else {
                              if (groupMembersUids.state
                                  .any((uid) => uid == friend.uid)) {
                                context
                                    .read(groupMembersUidsProvider)
                                    .state
                                    .remove(friend.uid);
                              } else {
                                context
                                    .read(groupMembersUidsProvider)
                                    .state
                                    .add(friend.uid);
                              }
                              print(groupMembersUids.state.toString());
                            }
                          },
                        )
                      : Row(
                          children: [
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: Icon(
                                CupertinoIcons.bubble_left,
                                color: white,
                              ),
                              iconSize: 24,
                              onPressed: () {
                                context.read(messageDataProvider).state =
                                    friend;
                                Navigator.of(context)
                                    .pushNamed(FriendScreen.routeName);
                              },
                            ),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: Icon(
                                CupertinoIcons.phone,
                                color: white,
                              ),
                              iconSize: 24,
                              onPressed: () {},
                            ),
                          ],
                        ),
                ],
              ),
              const SizedBox(width: 20)
            ],
          ),
        ),
      ),
    );
  }
}
