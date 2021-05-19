import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/colors.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/widgets/add_friend_tile.dart';
import 'package:party/widgets/background_gradient.dart';
import 'package:party/widgets/custom_back_button.dart';
import 'package:party/widgets/custom_button.dart';
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
    final userUsersFuture = useProvider(userUsersFutureProvider);
    final userRequestStream = useProvider(userRequestStreamProvider);
    final isRequest = useProvider(isRequestProvider);
    final height = useState<double>(90);
    final opacity = useState<double>(1);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: BackgroundGradient(
        child: Scaffold(
          appBar: AppBar(
            leading: CustomBackButton(),
            title: Text(
              'Add new friend',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: dark,
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    onTap: () {
                      context.read(isRequestProvider).state = false;
                      height.value = 90;
                      opacity.value = 1;
                    },
                    text: 'All',
                  ),
                  CustomButton(
                    onTap: () {
                      context.read(isRequestProvider).state = true;
                      height.value = 0;
                      opacity.value = 0;
                      FocusScope.of(context).unfocus();
                    },
                    text: 'Requests',
                  ),
                ],
              ),
              AnimatedOpacity(
                opacity: opacity.value,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeIn,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  curve: Curves.easeIn,
                  height: height.value,
                  child: CustomTextField(
                    text: 'search',
                    icon: CupertinoIcons.search,
                    onChanged: (String val) =>
                        context.read(friendsSearchProvider).state = val,
                  ),
                ),
              ),
              Expanded(
                child: isRequest.state
                    ? userRequestStream.when(
                        data: buildGridView,
                        loading: () => MyLoadingWidget(),
                        error: (e, s) => MyErrorWidget(e: e, s: s),
                      )
                    : userUsersFuture.when(
                        data: buildGridView,
                        loading: () => MyLoadingWidget(),
                        error: (e, s) => MyErrorWidget(e: e, s: s),
                      ),
              ),
            ],
          ),
        ),
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
