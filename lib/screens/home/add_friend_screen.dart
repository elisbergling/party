import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/widgets/add_friend_tile.dart';
import 'package:party/widgets/custom_text_field.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class AddFriendScreen extends HookWidget {
  const AddFriendScreen({
    Key key,
  }) : super(key: key);
  static const routeName = '/add_friend';
  @override
  Widget build(BuildContext context) {
    final userUsersStream = useProvider(userUsersStreamProvider);
    final userRequestStream = useProvider(userRequestStreamProvider);
    final isRequest = useProvider(isRequestProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('fin new friend'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  context.read(isRequestProvider).state = false;
                  print('all');
                },
                child: Text('All'),
              ),
              RaisedButton(
                onPressed: () {
                  context.read(isRequestProvider).state = true;
                  print('requset');
                },
                child: Text('Requests'),
              ),
            ],
          ),
          CustomTextField(
            text: 'search',
            onChanged: (String val) =>
                context.read(friendsSearchProvider).state = val,
          ),
          Expanded(
            child: isRequest.state
                ? userRequestStream.when(
                    data: buildGridView,
                    loading: () => MyLoadingWidget(),
                    error: (e, s) => MyErrorWidget(e: e, s: s),
                  )
                : userUsersStream.when(
                    data: buildGridView,
                    loading: () => MyLoadingWidget(),
                    error: (e, s) => MyErrorWidget(e: e, s: s),
                  ),
          ),
        ],
      ),
    );
  }

  GridView buildGridView(List<Friend> users) {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        return AddFriendTile(
          isLeft: index % 2 == 0,
          friend: users[index],
        );
      },
    );
  }
}
