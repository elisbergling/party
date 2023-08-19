import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/constants/global.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/group_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/custom_button.dart';
import 'package:party/widgets/custom_close_button.dart';
import 'package:party/widgets/custom_text_field.dart';
import 'package:party/widgets/friend_tile.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class AddGroupScreen extends HookConsumerWidget {
  const AddGroupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupProvider);
    final controllerName = useTextEditingController();
    final friendFriendsStream = ref.watch(friendFriendsStreamProvider);
    final groupMembersUids = ref.watch(groupMembersUidsProvider);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SingleChildScrollView(
        child: Scaffold(
          backgroundColor: MyColors.dark,
          appBar: AppBar(
            leading: const CustomCloseButton(),
            centerTitle: true,
            title: const Text(
              'New Group',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: MyColors.white,
              ),
            ),
          ),
          body: Column(
            children: [
              CustomTextField(
                text: 'name',
                color: MyColors.black,
                textEditingController: controllerName,
              ),
              SizedBox(
                height: 141,
                child: friendFriendsStream.when(
                  data: (friends) => ListView.builder(
                    cacheExtent: 10000,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: friends.length,
                    itemBuilder: (context, index) => FriendTile(
                      friend: friends[index],
                      isForGroup: true,
                      isForParty: false,
                    ),
                  ),
                  loading: () => const MyLoadingWidget(),
                  error: (e, s) => MyErrorWidget(e: e, s: s),
                ),
              ),
              const SizedBox(height: 40),
              !group.isLoading
                  ? CustomButton(
                      onTap: () async {
                        if (controllerName.text.isEmpty) {
                          ref
                              .read(groupProvider.notifier)
                              .setError('Well, you have to enter a name');
                        }
                        await ref.read(groupProvider.notifier).addGroup(
                              imgUrl: '',
                              name: controllerName.text,
                              membersUids: groupMembersUids,
                            );
                        showActionDialog(
                          ctx: context,
                          onPressed: () =>
                              ref.read(groupProvider.notifier).setError(''),
                          message: group.error,
                          title: group.error == ''
                              ? 'Created Group Sucessfully'
                              : 'Something went wrong',
                        );
                        if (group.error == '') {
                          controllerName.text = '';
                          ref
                              .read(groupMembersUidsProvider.notifier)
                              .state
                              .clear();
                        }
                      },
                      text: 'Create Group',
                    )
                  : const MyLoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
