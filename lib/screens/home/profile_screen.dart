import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:party/widgets/custom_text_field.dart';
import 'package:party/widgets/friend_tile.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final userUserStream = useProvider(userUserStreamProvider);
    final controllerName = useTextEditingController();
    final controllerUsername = useTextEditingController();
    final friendFriendsStream = useProvider(friendFriendsStreamProvider);
    final partyMyPartiesStream = useProvider(partyMyPartiesStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 75),
                userUserStream.when(
                  data: (data) {
                    controllerName.text = data.name;
                    controllerUsername.text = data.username;
                    return Column(children: [
                      CachedImage(
                        data.imgUrl,
                        height: 250,
                        width: 250,
                        name: data.name,
                      ),
                      const SizedBox(height: 75),
                      CustomTextField(
                        text: 'name',
                        isForm: true,
                        textEditingController: controllerName,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Well, you have to enter a name';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        text: 'username',
                        isForm: true,
                        textEditingController: controllerUsername,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Username can not be empty!';
                          } else if (value.contains('\$') ||
                              value.contains('-') ||
                              value.contains('.') ||
                              value.contains(' ')) {
                            return 'Can not conatin such symbols';
                          }
                          return null;
                        },
                      ),
                    ]);
                  },
                  loading: () => MyLoadingWidget(),
                  error: (e, s) => MyErrorWidget(e: e, s: s),
                ),
                RaisedButton(
                  onPressed: () async =>
                      await context.read(userProvider).updateUser(
                            name: controllerName.text,
                            username: controllerUsername.text,
                          ),
                  child: Text('Save'),
                ),
                Text('Your Friends'),
                Container(
                  height: 160,
                  child: friendFriendsStream.when(
                    data: (friends) => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: friends.length,
                      itemBuilder: (context, index) =>
                          FriendTile(friend: friends[index]),
                    ),
                    loading: () => MyLoadingWidget(),
                    error: (e, s) => MyErrorWidget(e: e, s: s),
                  ),
                ),
                Text('Your Parties'),
                Container(
                  height: 160,
                  child: partyMyPartiesStream.when(
                    data: (parties) => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: parties.length,
                      itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(20),
                        width: 206,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).primaryColorDark,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CachedImage(
                              parties[index].imgUrl,
                              height: 80,
                              width: 80,
                              name: parties[index].name,
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    parties[index].name,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: 80,
                                    child: Text(
                                      parties[index].about,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    parties[index].price.toString() + ' kr',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    loading: () => MyLoadingWidget(),
                    error: (e, s) => MyErrorWidget(e: e, s: s),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
