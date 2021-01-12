import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/enum.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/group_provider.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/providers/provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/list_item.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

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
    final pageController = useProvider(pageControllerProvider);
    final messageType = useProvider(messageTypeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              context.read(pageIndexProvider).state = 0;
              pageController.animateToPage(0,
                  duration: Duration(milliseconds: 800), curve: Curves.easeIn);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () => context.read(messageTypeProvider).state =
                      MessageType.Friends,
                  child: Text('Friends'),
                ),
                RaisedButton(
                  onPressed: () => context.read(messageTypeProvider).state =
                      MessageType.Groups,
                  child: Text('Groups'),
                ),
                RaisedButton(
                  onPressed: () => context.read(messageTypeProvider).state =
                      MessageType.Parties,
                  child: Text('Parties'),
                ),
              ],
            ),
          ),
          Expanded(
            child: messageType.state == MessageType.Friends
                ? friendFriendsStream.when(
                    data: (friends) => ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      cacheExtent: 1000,
                      itemCount: friends.length,
                      itemBuilder: (ctx, index) {
                        bool isFirst;
                        bool isLast;
                        index == 0 ? isFirst = true : isFirst = false;
                        index == 29 ? isLast = true : isLast = false;
                        return ListItem(
                          isFirst: isFirst,
                          isLast: isLast,
                          index: index,
                          friend: friends[index],
                        );
                      },
                    ),
                    loading: () => MyLoadingWidget(),
                    error: (e, s) => MyErrorWidget(e: e, s: s),
                  )
                : messageType.state == MessageType.Groups
                    ? groupGroupsStream.when(
                        data: (groups) => ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          cacheExtent: 1000,
                          itemCount: groups.length,
                          itemBuilder: (ctx, index) {
                            bool isFirst;
                            bool isLast;
                            index == 0 ? isFirst = true : isFirst = false;
                            index == 29 ? isLast = true : isLast = false;
                            return ListItem(
                              isFirst: isFirst,
                              isLast: isLast,
                              index: index,
                              group: groups[index],
                            );
                          },
                        ),
                        loading: () => MyLoadingWidget(),
                        error: (e, s) => MyErrorWidget(e: e, s: s),
                      )
                    : partyUpcomingPartiesStream.when(
                        data: (parties) => ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          cacheExtent: 1000,
                          itemCount: parties.length,
                          itemBuilder: (ctx, index) {
                            bool isFirst;
                            bool isLast;
                            index == 0 ? isFirst = true : isFirst = false;
                            index == 29 ? isLast = true : isLast = false;
                            return ListItem(
                              isFirst: isFirst,
                              isLast: isLast,
                              index: index,
                              party: parties[index],
                            );
                          },
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
