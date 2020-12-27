import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/providers/user_provider.dart';
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
    final pageController = useProvider(pageControllerProvider);
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
                  onPressed: () {},
                  child: Text('Friends'),
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text('Groups'),
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text('Parties'),
                ),
              ],
            ),
          ),
          Expanded(
            child: friendFriendsStream.when(
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
            ),
          ),
        ],
      ),
    );
  }
}
