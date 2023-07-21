import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
import 'package:party/screens/home/add_group_screen.dart';

class MessagesScreen extends HookConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendFriendsStream = ref.watch(friendFriendsStreamProvider);
    final groupGroupsStream = ref.watch(groupGroupsStreamProvider);
    final partyUpcomingPartiesStream =
        ref.watch(partyUpcomingPartiesStreamProvider);
    final messageType = ref.watch(messageTypeProvider);
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Messages',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: MyColors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.userAlt,
                color: MyColors.white,
              ),
              onPressed: () => showModalBottomSheet(
                context: context,
                backgroundColor: MyColors.dark,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                builder: (context) => const AddFriendScreen(),
              ),
            ),
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.users,
                color: MyColors.white,
              ),
              onPressed: () => showModalBottomSheet(
                context: context,
                backgroundColor: MyColors.dark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                builder: (context) => const AddGroupScreen(),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  onTap: () => ref.read(messageTypeProvider.notifier).state =
                      MessageType.friends,
                  text: 'Friends',
                ),
                CustomButton(
                  onTap: () => ref.read(messageTypeProvider.notifier).state =
                      MessageType.groups,
                  text: 'Groups',
                ),
                CustomButton(
                  onTap: () => ref.read(messageTypeProvider.notifier).state =
                      MessageType.parties,
                  text: 'Parties',
                ),
              ],
            ),
            Expanded(
              child: messageType == MessageType.friends
                  ? friendFriendsStream.when(
                      data: (friends) => ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: friends.length,
                        itemBuilder: (ctx, index) =>
                            ListItem(friend: friends[index]),
                      ),
                      loading: () => const MyLoadingWidget(),
                      error: (e, s) => MyErrorWidget(e: e, s: s),
                    )
                  : messageType == MessageType.groups
                      ? groupGroupsStream.when(
                          data: (groups) => ListView.builder(
                            padding: const EdgeInsets.only(top: 20),
                            physics: const BouncingScrollPhysics(),
                            itemCount: groups.length,
                            itemBuilder: (ctx, index) =>
                                ListItem(group: groups[index]),
                          ),
                          loading: () => const MyLoadingWidget(),
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
                          loading: () => const MyLoadingWidget(),
                          error: (e, s) => MyErrorWidget(e: e, s: s),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
