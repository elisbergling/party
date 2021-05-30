import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/enum.dart';
import 'package:party/constants/colors.dart';
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

class ProfileScreen extends HookWidget {
  const ProfileScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userUserStream = useProvider(userUserStreamProvider);
    final profileStreamType = useProvider(profileStreamTypeProvider);
    final friendFriendsStream = useProvider(friendFriendsStreamProvider);
    final partyMyPartiesStream = useProvider(partyMyPartiesStreamProvider);
    final partyUpcomingPartiesStream =
        useProvider(partyUpcomingPartiesStreamProvider);
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: white,
            ),
          ),
          actions: [
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.signOutAlt,
                color: white,
              ),
              onPressed: () async => await context.read(authProvider).logOut(),
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
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          data.username,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: grey,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.refresh_thick,
                        color: white,
                        size: 30,
                      ),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        backgroundColor: dark,
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
              loading: () => MyLoadingWidget(),
              error: (e, s) => MyErrorWidget(e: e, s: s),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  onTap: () => context.read(profileStreamTypeProvider).state =
                      ProfileStreamType.Friends,
                  text: 'Friends',
                ),
                CustomButton(
                  onTap: () => context.read(profileStreamTypeProvider).state =
                      ProfileStreamType.YourParties,
                  text: 'Your Parties',
                ),
                CustomButton(
                  onTap: () => context.read(profileStreamTypeProvider).state =
                      ProfileStreamType.UpcomingParties,
                  text: 'Upcoming Parties',
                ),
              ],
            ),
            Expanded(
              child: profileStreamType.state == ProfileStreamType.Friends
                  ? friendFriendsStream.when(
                      data: (friends) => ListView.builder(
                        physics: BouncingScrollPhysics(),
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
                      loading: () => MyLoadingWidget(),
                      error: (e, s) => MyErrorWidget(e: e, s: s),
                    )
                  : profileStreamType.state == ProfileStreamType.YourParties
                      ? partyMyPartiesStream.when(
                          data: (parties) => ListView.builder(
                            physics: BouncingScrollPhysics(),
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
                          loading: () => MyLoadingWidget(),
                          error: (e, s) => MyErrorWidget(e: e, s: s),
                        )
                      : partyUpcomingPartiesStream.when(
                          data: (parties) => ListView.builder(
                            physics: BouncingScrollPhysics(),
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
