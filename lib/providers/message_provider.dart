import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/message.dart';
import 'package:party/models/service_data.dart';
import 'package:party/services/message_service.dart';

final messageProvider =
    NotifierProvider<MessageService, ServiceData>(() => MessageService());

final messageMessagesStreamProvider =
    StreamProvider.autoDispose.family<List<Message>, String?>((ref, uidTo) {
  final message = ref.watch(messageProvider.notifier);
  ref.keepAlive();
  if (uidTo != null) {
    return message.messagesStream(uidTo: uidTo) ?? const Stream.empty();
  } else {
    return const Stream.empty();
  }
});

final messageLastMessageStreamProvider =
    StreamProvider.autoDispose.family<Message, String>((ref, uidTo) {
  final message = ref.watch(messageProvider.notifier);
  ref.keepAlive();
  return message.lastMessageStream(uidTo: uidTo) ?? const Stream.empty();
});

final messageLastMessageFutureProvider =
    FutureProvider.autoDispose.family<Message?, String>((ref, uidTo) async {
  final message = ref.watch(messageProvider.notifier);
  ref.keepAlive();
  try {
    return await message.lastMessageFuture(uidTo: uidTo);
  } catch (e) {
    return null;
  }
});
