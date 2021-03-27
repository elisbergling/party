import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/group.dart';
import 'package:party/models/party.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/message_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/custom_text_field.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          messageData.state.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
          IconButton(icon: Icon(Icons.audiotrack), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: messageMessagesStream.when(
                data: (messages) => uid != null
                    ? ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        shrinkWrap: true,
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
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
              color: Theme.of(context).primaryColorLight,
            ),
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomTextField(
                    text: 'say something',
                    textEditingController: controllerMessage,
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Icon(Icons.camera_alt),
                ),
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Icon(Icons.photo),
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
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: uid != null
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    child: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
