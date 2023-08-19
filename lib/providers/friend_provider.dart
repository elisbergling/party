import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/service_data.dart';
import 'package:party/services/friend_service.dart';

final friendProvider =
    NotifierProvider<FriendService, ServiceData>(() => FriendService());

final friendFriendsStreamProvider = StreamProvider<List<Friend>>((ref) {
  final friend = ref.watch(friendProvider.notifier);
  return friend.friendsStream() ?? Stream.value([]);
});

final friendFriendsFutureProvider = FutureProvider<List<Friend>?>((ref) async {
  final friend = ref.watch(friendProvider.notifier);
  try {
    return await friend.friendsFuture();
  } catch (e) {
    return null;
  }
});
