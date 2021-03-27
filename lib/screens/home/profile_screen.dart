import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/enum.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/screens/home/update_user_info_screen.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:party/widgets/friend_tile.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 75),
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(data.username),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.update),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdateUserInfoScreen(
                          name: data.name,
                          username: data.username,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => MyLoadingWidget(),
            error: (e, s) => MyErrorWidget(e: e, s: s),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                    onPressed: () => context
                        .read(profileStreamTypeProvider)
                        .state = ProfileStreamType.Friends,
                    child: Text('Friends')),
                RaisedButton(
                    onPressed: () => context
                        .read(profileStreamTypeProvider)
                        .state = ProfileStreamType.YourParties,
                    child: Text('Your Parties')),
                RaisedButton(
                    onPressed: () => context
                        .read(profileStreamTypeProvider)
                        .state = ProfileStreamType.UpcomingParties,
                    child: Text('Upcoming Parties')),
              ],
            ),
          ),
          Expanded(
            child: profileStreamType.state == ProfileStreamType.Friends
                ? friendFriendsStream.when(
                    data: (friends) => ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: friends.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          FriendTile(friend: friends[index]),
                    ),
                    loading: () => MyLoadingWidget(),
                    error: (e, s) => MyErrorWidget(e: e, s: s),
                  )
                : profileStreamType.state == ProfileStreamType.YourParties
                    ? partyMyPartiesStream.when(
                        data: (parties) => ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: parties.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              PartyTile(party: parties[index]),
                        ),
                        loading: () => MyLoadingWidget(),
                        error: (e, s) => MyErrorWidget(e: e, s: s),
                      )
                    : partyUpcomingPartiesStream.when(
                        data: (parties) => ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: parties.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) =>
                              PartyTile(party: parties[index]),
                        ),
                        loading: () => MyLoadingWidget(),
                        error: (e, s) => MyErrorWidget(e: e, s: s),
                      ),
          ),
        ],
      ),
    );
  }
}
