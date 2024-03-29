import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/screens/home/friend_screen.dart';
import 'package:party/widgets/border_gradient.dart';
import 'package:party/widgets/cached_image.dart';

class AddFriendTile extends HookConsumerWidget {
  final Friend friend;
  final bool isLeft;
  final Color color;

  const AddFriendTile({
    super.key,
    required this.friend,
    required this.isLeft,
    this.color = MyColors.black,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(authStateChangesProvider).value?.uid;
    return Container(
      margin: EdgeInsets.only(
        left: isLeft ? 10 : 0,
        right: !isLeft ? 10 : 0,
      ),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(20),
        child: BorderGradient(
          child: Container(
            width: 165,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color,
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
                    SizedBox(
                      width: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            friend.name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: MyColors.white,
                            ),
                          ),
                          Text(
                            friend.username,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                              color: MyColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(child: SizedBox(width: 0.0, height: 0.0)),
                    friend.friendUids.contains(uid)
                        ? buildButton(context, CupertinoIcons.bubble_left, () {
                            ref.read(messageDataProvider.notifier).state =
                                friend;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const FriendScreen(),
                              ),
                            );
                          })
                        : buildButton(
                            context,
                            CupertinoIcons.person_add,
                            () async => await ref
                                .read(friendProvider.notifier)
                                .addFriend(friend: friend),
                          ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildButton(
    BuildContext context,
    IconData icon,
    Function() onPressed,
  ) {
    return SizedBox(
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
