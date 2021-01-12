import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/cached_image.dart';

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

  @override
  Widget build(BuildContext context) {
    final pageController = useProvider(pageControllerProvider);
    final invitedUids = useProvider(invitedUidsProvider);
    final groupMembersUids = useProvider(groupMembersUidsProvider);
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(20),
      width: 206,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: (isForParty && groupMembersUids.state.contains(friend.uid)) ||
                (isForGroup && invitedUids.state.contains(friend.uid))
            ? Colors.greenAccent
            : Theme.of(context).primaryColorDark,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedImage(
            friend.imgUrl,
            height: 80,
            width: 80,
            name: friend.name,
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              isForParty || isForGroup
                  ? IconButton(
                      icon: Icon(Icons.person_add),
                      iconSize: 20,
                      onPressed: () {
                        if (isForParty) {
                          if (invitedUids.state.contains(friend.uid)) {
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
                        } else {
                          if (groupMembersUids.state.contains(friend.uid)) {
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
                        }
                        print(groupMembersUids.state.toString());
                        print(invitedUids.state.toString());
                      },
                    )
                  : Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.message),
                          iconSize: 20,
                          onPressed: () {
                            context.read(messageDataProvider).state = friend;
                            context.read(pageIndexProvider).state = 1;
                            pageController.animateToPage(1,
                                duration: Duration(milliseconds: 800),
                                curve: Curves.easeIn);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.call),
                          iconSize: 20,
                          onPressed: () {},
                        ),
                      ],
                    )
            ],
          )
        ],
      ),
    );
  }
}
