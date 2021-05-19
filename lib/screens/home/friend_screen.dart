import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/group.dart';
import 'package:party/models/party.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/message_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/custom_back_button.dart';
import 'package:party/widgets/background_gradient.dart';
import 'package:party/widgets/custom_text_field.dart';
import 'package:party/widgets/glass_app_bar.dart';
import 'package:party/widgets/message_layout.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class FriendScreen extends HookWidget {
  const FriendScreen({
    Key key,
  }) : super(key: key);

  static const routeName = '/friend_screen';

  @override
  Widget build(BuildContext context) {
    final messageData = useProvider(messageDataProvider);
    String uid;
    switch (messageData.state.runtimeType) {
      case Friend:
        uid = messageData.state.uid;
        break;
      case Group:
        uid = messageData.state.id;
        break;
      case Party:
        uid = messageData.state.id;
        break;
    }
    final messageMessagesStream =
        useProvider(messageMessagesStreamProvider(uid));
    final controllerMessage = useTextEditingController();
    final authStateChanges = useProvider(authStateChangesProvider);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: BackgroundGradient(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: GlassAppBar(
            child: AppBar(
              leading: CustomBackButton(),
              title: Text(
                messageData.state.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: dark,
                ),
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      CupertinoIcons.phone,
                      color: dark,
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              messageMessagesStream.when(
                data: (messages) => uid != null
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        padding: EdgeInsets.only(
                            bottom: 70,
                            top: MediaQuery.of(context).padding.top +
                                AppBar().preferredSize.height),
                        itemCount: messages.length,
                        itemBuilder: (ctx, index) {
                          final bool isMe = authStateChanges.data.value.uid ==
                              messages[index].uidFrom;
                          return MessageLayout(
                              isMe: isMe, message: messages[index]);
                        },
                      )
                    : Center(child: Text('You can not messge Mr Bean')),
                loading: () => MyLoadingWidget(),
                error: (e, s) => MyErrorWidget(e: e, s: s),
              ),
              Positioned(
                bottom: 0,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: babyWhite,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              text: 'say something',
                              textEditingController: controllerMessage,
                              color: babyBlue,
                              margin: 10,
                              borderRadius: 20,
                              onSubmitted: (value) async {
                                await context.read(messageProvider).addMessage(
                                      uidTo: uid,
                                      message: value,
                                    );
                                controllerMessage.clear();
                              },
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: blue,
                            ),
                            child: Icon(
                              CupertinoIcons.photo_camera,
                              color: babyWhite,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: blue,
                            ),
                            child: Icon(
                              CupertinoIcons.photo,
                              color: babyWhite,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (uid != null) {
                                await context.read(messageProvider).addMessage(
                                      uidTo: uid,
                                      message: controllerMessage.text,
                                    );
                                controllerMessage.text = '';
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              margin: const EdgeInsets.only(
                                right: 10,
                                left: 5,
                                top: 5,
                                bottom: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: blue,
                              ),
                              padding: const EdgeInsets.all(0),
                              child: Transform.translate(
                                offset: const Offset(-2, 0),
                                child: Transform.rotate(
                                  angle: pi / 4,
                                  child: Icon(
                                    CupertinoIcons.paperplane,
                                    color: babyWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
