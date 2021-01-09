import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/friend.dart';
import 'package:party/services/friend_service.dart';

import 'auth_provider.dart';

final friendProvider = ChangeNotifierProvider<FriendService>((ref) {
  final auth = ref?.watch(authStateChangesProvider);
  if (auth?.data?.value?.uid != null) {
    return FriendService(
      uid: auth?.data?.value?.uid,
    );
  }
  return null;
});

final friendFriendsStreamProvider =
    StreamProvider.autoDispose<List<Friend>>((ref) {
  final friend = ref?.watch(friendProvider);
  ref.maintainState = true;
  return friend?.friendsStream() ?? const Stream.empty();
});
