import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/widgets/add_friend_tile.dart';
import 'package:party/widgets/custom_button.dart';
import 'package:party/widgets/custom_close_button.dart';
import 'package:party/widgets/custom_text_field.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class AddFriendScreen extends HookConsumerWidget {
  const AddFriendScreen({super.key});

  static const routeName = '/add_friend';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userUsersFuture = ref.watch(userUsersFutureProvider);
    final userRequestStream = ref.watch(userRequestStreamProvider);
    final isRequest = ref.watch(isRequestProvider);
    final height = useState<double>(90);
    final opacity = useState<double>(1);
    return SizedBox(
      height: 550,
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          appBar: AppBar(
            leading: const CustomCloseButton(),
            centerTitle: true,
            title: const Text(
              'Add New Friend',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: MyColors.white,
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
                      ref.read(isRequestProvider.notifier).state = false;
                      height.value = 90;
                      opacity.value = 1;
                    },
                    text: 'All',
                  ),
                  CustomButton(
                    onTap: () {
                      ref.read(isRequestProvider.notifier).state = true;
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
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeIn,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn,
                  height: height.value,
                  child: CustomTextField(
                    text: 'search',
                    color: MyColors.black,
                    icon: CupertinoIcons.search,
                    onChanged: (String val) =>
                        ref.read(friendsSearchProvider.notifier).state = val,
                  ),
                ),
              ),
              if (isRequest) const SizedBox(height: 20),
              Expanded(
                child: isRequest
                    ? userRequestStream.when(
                        data: buildGridView,
                        loading: () => const MyLoadingWidget(),
                        error: (e, s) => MyErrorWidget(e: e, s: s),
                      )
                    : userUsersFuture.when(
                        data: (data) => data != null
                            ? buildGridView(data)
                            : throw Exception(),
                        loading: () => const MyLoadingWidget(),
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
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          color: MyColors.dark,
        );
      },
    );
  }
}
