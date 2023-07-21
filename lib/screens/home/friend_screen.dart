import 'dart:math';

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

class FriendScreen extends HookConsumerWidget {
  const FriendScreen({super.key});

  static const routeName = '/friend_screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageData = ref.watch(messageDataProvider);
    String? uid;
    switch (messageData.runtimeType) {
      case Friend:
        uid = messageData.uid;
        break;
      case Group:
        uid = messageData.id;
        break;
      case Party:
        uid = messageData.id;
        break;
    }
    final messageMessagesStream = ref.watch(messageMessagesStreamProvider(uid));
    final controllerMessage = useTextEditingController();
    final authStateChanges = ref.watch(authStateChangesProvider);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: BackgroundGradient(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: GlassAppBar(
            child: AppBar(
              leading: const CustomBackButton(),
              title: Text(
                messageData.state.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: MyColors.white,
                ),
              ),
              actions: [
                IconButton(
                    icon: const Icon(
                      CupertinoIcons.phone,
                      color: MyColors.white,
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
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        padding: EdgeInsets.only(
                            bottom: 70,
                            top: MediaQuery.of(context).padding.top +
                                AppBar().preferredSize.height),
                        itemCount: messages.length,
                        itemBuilder: (ctx, index) {
                          final bool isMe = authStateChanges.value!.uid ==
                              messages[index].uidFrom;
                          return MessageLayout(
                              isMe: isMe, message: messages[index]);
                        },
                      )
                    : const Center(child: Text('You can not messge Mr Bean')),
                loading: () => const MyLoadingWidget(),
                error: (e, s) => MyErrorWidget(e: e, s: s),
              ),
              Positioned(
                bottom: 0,
                child: Material(
                  elevation: 10,
                  color: MyColors.black,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: MyColors.dark,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              text: 'say something',
                              textEditingController: controllerMessage,
                              color: MyColors.black,
                              margin: 10,
                              borderRadius: 20,
                              onSubmitted: (value) async {
                                await ref
                                    .read(messageProvider.notifier)
                                    .addMessage(
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
                              color: MyColors.blue.withOpacity(0.2),
                            ),
                            child: const Icon(
                              CupertinoIcons.photo_camera,
                              color: MyColors.blue,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: MyColors.blue.withOpacity(0.2),
                            ),
                            child: const Icon(
                              CupertinoIcons.photo,
                              color: MyColors.blue,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (uid != null) {
                                await ref
                                    .read(messageProvider.notifier)
                                    .addMessage(
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
                                color: MyColors.blue.withOpacity(0.2),
                              ),
                              padding: const EdgeInsets.all(0),
                              child: Transform.translate(
                                offset: const Offset(-2, 0),
                                child: Transform.rotate(
                                  angle: pi / 4,
                                  child: const Icon(
                                    CupertinoIcons.paperplane,
                                    color: MyColors.blue,
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
