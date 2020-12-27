import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/message.dart';
import 'package:party/services/message_service.dart';

import 'auth_provider.dart';

final messageProvider = ChangeNotifierProvider<MessageService>((ref) {
  final auth = ref?.watch(authStateChangesProvider);
  if (auth?.data?.value?.uid != null) {
    return MessageService(uid: auth?.data?.value?.uid);
  }
  return null;
});

final messageMessagesStreamProvider =
    StreamProvider.autoDispose.family<List<Message>, String>((ref, uidTo) {
  final message = ref?.watch(messageProvider);
  ref.maintainState = true;
  return message?.messagesStream(uidTo: uidTo) ?? const Stream.empty();
});
