import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/enum.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/message.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/services/service_notifier.dart';
import 'package:party/utils/auth_state_mixin.dart';
import 'package:uuid/uuid.dart';

class MessageService extends ServiceNotifier with AuthState {
  MessageType get messageType {
    return ProviderContainer().read(messageTypeProvider);
  }

  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection(MyStrings.messages);

  String chatRoomIdGenerator(String uidTo) {
    String chatRoomId = '';
    switch (messageType) {
      case MessageType.friends:
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
      case MessageType.groups:
        chatRoomId = uidTo;
        break;
      case MessageType.parties:
        chatRoomId = uidTo;
        break;
    }
    return chatRoomId;
  }

  Stream<List<Message>>? messagesStream({required String uidTo}) {
    try {
      String chatRoomId = chatRoomIdGenerator(uidTo);
      return messageCollection
          .doc(chatRoomId)
          .collection(MyStrings.messages)
          .orderBy(MyStrings.createdAt, descending: true)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Message.fromJson(e.data())).toList());
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Stream<Message>? lastMessageStream({required String uidTo}) {
    try {
      String chatRoomId = chatRoomIdGenerator(uidTo);
      return messageCollection
          .doc(chatRoomId)
          .collection(MyStrings.messages)
          .orderBy(MyStrings.createdAt, descending: true)
          .limit(1)
          .snapshots()
          .map((event) => event.docs.isNotEmpty
              ? Message.fromJson(event.docs.single.data())
              : Message(
                  message: 'Start Messaging',
                  createdAt: Timestamp.fromMicrosecondsSinceEpoch(0),
                ));
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Future<Message?> lastMessageFuture({required String uidTo}) async {
    try {
      String chatRoomId = chatRoomIdGenerator(uidTo);
      final doc = await messageCollection
          .doc(chatRoomId)
          .collection(MyStrings.messages)
          .orderBy(MyStrings.createdAt, descending: true)
          .limit(1)
          .get();

      return doc.docs.map((e) => Message.fromJson(e.data())).single;
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Future<void> removeMessage({
    required String uidTo,
    required String id,
  }) async {
    try {
      String chatRoomId = chatRoomIdGenerator(uidTo);
      await messageCollection
          .doc(chatRoomId)
          .collection(MyStrings.messages)
          .doc(id)
          .delete();
    } catch (e) {
      setError(e);
    }
  }

  Future<void> addMessage({
    required String? message,
    required String uidTo,
  }) async {
    try {
      if (message == null || message.trim() == '') {
        return;
      } else {
        String chatRoomId = chatRoomIdGenerator(uidTo);
        Uuid uuid = const Uuid();
        Message data = Message(
          createdAt: Timestamp.now(),
          uidFrom: uid,
          uidTo: uidTo,
          message: message,
          id: uuid.v4(),
        );
        await messageCollection
            .doc(chatRoomId)
            .collection(MyStrings.messages)
            .doc(data.id)
            .set(data.toJson());
      }
    } catch (e) {
      setError(e);
    }
  }
}
