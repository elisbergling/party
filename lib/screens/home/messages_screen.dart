import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/colors.dart';
import 'package:party/constants/enum.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/group_provider.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/screens/home/add_friend_screen.dart';
import 'package:party/widgets/background_gradient.dart';
import 'package:party/widgets/custom_button.dart';
import 'package:party/widgets/list_item.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

import 'add_group_screen.dart';

class MessagesScreen extends HookWidget {
  const MessagesScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final friendFriendsStream = useProvider(friendFriendsStreamProvider);
    final groupGroupsStream = useProvider(groupGroupsStreamProvider);
    final partyUpcomingPartiesStream =
        useProvider(partyUpcomingPartiesStreamProvider);
    final messageType = useProvider(messageTypeProvider);
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Messages',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: dark,
            ),
          ),
          actions: [
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.userAlt,
                color: dark,
              ),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddFriendScreen.routeName),
            ),
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.users,
                color: dark,
              ),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddGroupScreen.routeName),
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  onTap: () => context.read(messageTypeProvider).state =
                      MessageType.Friends,
                  text: 'Friends',
                ),
                CustomButton(
                  onTap: () => context.read(messageTypeProvider).state =
                      MessageType.Groups,
                  text: 'Groups',
                ),
                CustomButton(
                  onTap: () => context.read(messageTypeProvider).state =
                      MessageType.Parties,
                  text: 'Parties',
                ),
              ],
            ),
            Expanded(
              child: messageType.state == MessageType.Friends
                  ? friendFriendsStream.when(
                      data: (friends) => ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: friends.length,
                        itemBuilder: (ctx, index) =>
                            ListItem(friend: friends[index]),
                      ),
                      loading: () => MyLoadingWidget(),
                      error: (e, s) => MyErrorWidget(e: e, s: s),
                    )
                  : messageType.state == MessageType.Groups
                      ? groupGroupsStream.when(
                          data: (groups) => ListView.builder(
                            padding: const EdgeInsets.only(top: 20),
                            physics: const BouncingScrollPhysics(),
                            itemCount: groups.length,
                            itemBuilder: (ctx, index) =>
                                ListItem(group: groups[index]),
                          ),
                          loading: () => MyLoadingWidget(),
                          error: (e, s) => MyErrorWidget(e: e, s: s),
                        )
                      : partyUpcomingPartiesStream.when(
                          data: (parties) => ListView.builder(
                            padding: const EdgeInsets.only(top: 20),
                            physics: const BouncingScrollPhysics(),
                            itemCount: parties.length,
                            itemBuilder: (ctx, index) =>
                                ListItem(party: parties[index]),
                          ),
                          loading: () => MyLoadingWidget(),
                          error: (e, s) => MyErrorWidget(e: e, s: s),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
