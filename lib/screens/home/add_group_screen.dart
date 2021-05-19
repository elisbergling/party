import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/colors.dart';
import 'package:party/constants/global.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/group_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/background_gradient.dart';
import 'package:party/widgets/custom_back_button.dart';
import 'package:party/widgets/custom_button.dart';
import 'package:party/widgets/custom_text_field.dart';
import 'package:party/widgets/friend_tile.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class AddGroupScreen extends HookWidget {
  const AddGroupScreen({Key key}) : super(key: key);

  static const routeName = '/add_group';

  String validator(value) {
    if (value.isEmpty) {
      return 'Well, you have to enter a name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final group = useProvider(groupProvider);
    final controllerName = useTextEditingController();
    final friendFriendsStream = useProvider(friendFriendsStreamProvider);
    final groupMembersUids = useProvider(groupMembersUidsProvider);
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          leading: CustomBackButton(),
          title: Text(
            'New Group',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: dark,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                text: 'name',
                isForm: true,
                textEditingController: controllerName,
                validator: validator,
              ),
              Container(
                height: 141,
                child: friendFriendsStream.when(
                  data: (friends) => ListView.builder(
                    cacheExtent: 10000,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: friends.length,
                    itemBuilder: (context, index) => FriendTile(
                      friend: friends[index],
                      isForGroup: true,
                      isForParty: false,
                    ),
                  ),
                  loading: () => MyLoadingWidget(),
                  error: (e, s) => MyErrorWidget(e: e, s: s),
                ),
              ),
              const SizedBox(height: 40),
              !group.isLoading
                  ? CustomButton(
                      onTap: () async {
                        await context.read(groupProvider).addGroup(
                              imgUrl: '',
                              name: controllerName.text,
                              membersUids: groupMembersUids.state,
                            );
                        showActionDialog(
                          ctx: context,
                          service: group,
                          message: group.error,
                          title: group.error == ''
                              ? 'Created Group Sucessfully'
                              : 'Something went wrong',
                        );
                        if (group.error == '') {
                          controllerName.text = '';
                          context.read(groupMembersUidsProvider).state.clear();
                        }
                      },
                      text: 'Create Group',
                    )
                  : MyLoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
