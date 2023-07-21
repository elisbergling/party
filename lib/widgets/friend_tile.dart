import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/screens/home/friend_screen.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:party/widgets/border_gradient.dart';

class FriendTile extends HookConsumerWidget {
  const FriendTile({
    super.key,
    required this.friend,
    this.isForParty = false,
    this.isForGroup = false,
  });

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
  Widget build(BuildContext context, WidgetRef ref) {
    final invitedUids = ref.watch(invitedUidsProvider);
    final groupMembersUids = ref.watch(groupMembersUidsProvider);
    final isSelected = useState(initValue(invitedUids, groupMembersUids));
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
                    ? MyColors.black
                    : MyColors.dark,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: MyColors.white,
                    ),
                  ),
                  Text(
                    friend.username,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: MyColors.grey,
                    ),
                  ),
                  isForParty || isForGroup
                      ? IconButton(
                          padding: const EdgeInsets.all(0),
                          icon: isSelected.value
                              ? const Icon(CupertinoIcons.person_badge_minus)
                              : const Icon(CupertinoIcons.person_add),
                          iconSize: 24,
                          onPressed: () {
                            isSelected.value = !isSelected.value;
                            if (isForParty) {
                              if (invitedUids.any((uid) => uid == friend.uid)) {
                                ref
                                    .read(invitedUidsProvider.notifier)
                                    .state
                                    .remove(friend.uid);
                              } else {
                                ref
                                    .read(invitedUidsProvider.notifier)
                                    .state
                                    .add(friend.uid);
                              }
                              print(invitedUids.toString());
                            } else {
                              if (groupMembersUids
                                  .any((uid) => uid == friend.uid)) {
                                ref
                                    .read(groupMembersUidsProvider.notifier)
                                    .state
                                    .remove(friend.uid);
                              } else {
                                ref
                                    .read(groupMembersUidsProvider.notifier)
                                    .state
                                    .add(friend.uid);
                              }
                              print(groupMembersUids.toString());
                            }
                          },
                        )
                      : Row(
                          children: [
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(
                                CupertinoIcons.bubble_left,
                                color: MyColors.white,
                              ),
                              iconSize: 24,
                              onPressed: () {
                                ref.read(messageDataProvider).state = friend;
                                Navigator.of(context)
                                    .pushNamed(FriendScreen.routeName);
                              },
                            ),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(
                                CupertinoIcons.phone,
                                color: MyColors.white,
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
