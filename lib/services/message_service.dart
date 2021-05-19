import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:party/constants/enum.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/message.dart';
import 'package:uuid/uuid.dart';

class MessageService with ChangeNotifier {
  MessageService({
    @required this.uid,
    @required this.messageType,
  }) : assert(uid != null, 'Cannot create FriendService with null uid');
  final String uid;
  final MessageType messageType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = '';
  String get error => _error;

  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection(MESSEGES);

  String chatRoomIdGenerator(
    String uidTo,
  ) {
    String chatRoomId;
    switch (messageType) {
      case MessageType.Friends:
        if (uid.hashCode < uidTo.hashCode) {
          chatRoomId = uid + uidTo;
        } else if (uidTo.hashCode < uid.hashCode) {
          chatRoomId = uidTo + uid;
        } else if (uidTo == uid) {
          chatRoomId = uid;
        } else if (uidTo.hashCode == uid.hashCode) {
          chatRoomId = uidTo.hashCode.toString() + uid.hashCode.toString();
        }
        break;
      case MessageType.Groups:
        chatRoomId = uidTo;
        break;
      case MessageType.Parties:
        chatRoomId = uidTo;
        break;
    }
    return chatRoomId;
  }

  Stream<List<Message>> messagesStream({String uidTo}) {
    try {
      String chatRoomId = chatRoomIdGenerator(uidTo);
      return messageCollection
          .doc(chatRoomId)
          .collection(MESSEGES)
          .orderBy(CREATED_AT, descending: true)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Message.fromJson(e.data())).toList());
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<Message> lastMessageStream({String uidTo}) {
    try {
      String chatRoomId = chatRoomIdGenerator(uidTo);
      return messageCollection
          .doc(chatRoomId)
          .collection(MESSEGES)
          .orderBy(CREATED_AT, descending: true)
          .limit(1)
          .snapshots()
          .map((event) => event.docs.isNotEmpty
              ? Message.fromJson(event.docs.single.data())
              : Message(
                  message: 'Start Messaging',
                  createdAt: Timestamp.fromMicrosecondsSinceEpoch(0),
                ));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Message> lastMessageFuture({String uidTo}) async {
    try {
      String chatRoomId = chatRoomIdGenerator(uidTo);
      final doc = await messageCollection
          .doc(chatRoomId)
          .collection(MESSEGES)
          .orderBy(CREATED_AT, descending: true)
          .limit(1)
          .get();

      return doc.docs.map((e) => Message.fromJson(e.data())).single;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> removeMessage({
    String uidTo,
    String id,
  }) async {
    try {
      String chatRoomId = chatRoomIdGenerator(uidTo);
      await messageCollection
          .doc(chatRoomId)
          .collection(MESSEGES)
          .doc(id)
          .delete();
    } catch (e) {
      print(e.toString());

      return null;
    }
  }

  Future<void> addMessage({
    String message,
    String uidTo,
  }) async {
    try {
      if (message == null || message.trim() == '') {
        return;
      } else {
        String chatRoomId = chatRoomIdGenerator(uidTo);
        Uuid uuid = Uuid();
        Message data = Message(
          createdAt: Timestamp.now(),
          uidFrom: uid,
          uidTo: uidTo,
          message: message,
          id: uuid.v4(),
        );
        await messageCollection
            .doc(chatRoomId)
            .collection(MESSEGES)
            .doc(data.id)
            .set(data.toJson());
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
