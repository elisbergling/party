import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/constants/enum.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/screens/home/update_user_info_screen.dart';
import 'package:party/widgets/background_gradient.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:party/widgets/custom_button.dart';
import 'package:party/widgets/friend_tile.dart';
import 'package:party/widgets/last_item_on_profile.dart';
import 'package:party/widgets/party_tile.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userUserStream = ref.watch(userUserStreamProvider);
    final profileStreamType = ref.watch(profileStreamTypeProvider);
    final friendFriendsStream = ref.watch(friendFriendsStreamProvider);
    final partyMyPartiesStream = ref.watch(partyMyPartiesStreamProvider);
    final partyUpcomingPartiesStream =
        ref.watch(partyUpcomingPartiesStreamProvider);
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: MyColors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const FaIcon(
                Icons.logout,
                color: MyColors.white,
              ),
              onPressed: () async =>
                  await ref.read(authProvider.notifier).logOut(),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            userUserStream.when(
              data: (data) {
                return Row(
                  children: [
                    const SizedBox(width: 25),
                    CachedImage(
                      data.imgUrl,
                      height: 100,
                      width: 100,
                      name: data.name,
                    ),
                    const SizedBox(width: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: MyColors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data.username,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: MyColors.grey,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    IconButton(
                      icon: const Icon(
                        CupertinoIcons.refresh_thick,
                        color: MyColors.white,
                        size: 30,
                      ),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        backgroundColor: MyColors.dark,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        builder: (context) => UpdateUserInfoScreen(
                          name: data.name,
                          username: data.username,
                          imgUrl: data.imgUrl,
                          uid: data.uid,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                );
              },
              loading: () => const MyLoadingWidget(),
              error: (e, s) => MyErrorWidget(e: e, s: s),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  onTap: () => ref
                      .read(profileStreamTypeProvider.notifier)
                      .state = ProfileStreamType.friends,
                  text: 'Friends',
                ),
                CustomButton(
                  onTap: () => ref
                      .read(profileStreamTypeProvider.notifier)
                      .state = ProfileStreamType.yourParties,
                  text: 'Your Parties',
                ),
                CustomButton(
                  onTap: () => ref
                      .read(profileStreamTypeProvider.notifier)
                      .state = ProfileStreamType.upcomingParties,
                  text: 'Upcoming Parties',
                ),
              ],
            ),
            Expanded(
              child: profileStreamType == ProfileStreamType.friends
                  ? friendFriendsStream.when(
                      data: (friends) => ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: friends.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 20),
                        itemBuilder: (context, index) => LastItemOnProfile(
                          index: index,
                          length: friends.length,
                          child: FriendTile(friend: friends[index]),
                        ),
                      ),
                      loading: () => const MyLoadingWidget(),
                      error: (e, s) => MyErrorWidget(e: e, s: s),
                    )
                  : profileStreamType == ProfileStreamType.yourParties
                      ? partyMyPartiesStream.when(
                          data: (parties) => ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: parties.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 20),
                            itemBuilder: (context, index) => LastItemOnProfile(
                              index: index,
                              length: parties.length,
                              child: PartyTile(party: parties[index]),
                            ),
                          ),
                          loading: () => const MyLoadingWidget(),
                          error: (e, s) => MyErrorWidget(e: e, s: s),
                        )
                      : partyUpcomingPartiesStream.when(
                          data: (parties) => ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: parties.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 20),
                            itemBuilder: (context, index) => LastItemOnProfile(
                              index: index,
                              length: parties.length,
                              child: PartyTile(party: parties[index]),
                            ),
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
