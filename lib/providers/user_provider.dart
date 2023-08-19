import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/service_data.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/services/user_service.dart';

final userProvider =
    NotifierProvider<UserService, ServiceData>(() => UserService());

final userCreateUserProvider =
    NotifierProvider<UserServiceCreateUser, ServiceData>(
        () => UserServiceCreateUser());

final userUserStreamProvider = StreamProvider<Friend>((ref) {
  final user = ref.watch(userProvider.notifier);
  return user.userStream() ?? const Stream.empty();
});

final userUsersStreamProvider = StreamProvider<List<Friend>>((ref) {
  final user = ref.watch(userProvider.notifier);
  final name = ref.watch(friendsSearchProvider);
  return user.usersStream(name: name) ?? const Stream.empty();
});

final userUsersFutureProvider = FutureProvider<List<Friend>>((ref) async {
  final user = ref.watch(userProvider.notifier);
  final name = ref.watch(friendsSearchProvider);
  final res = await user.usersFuture(name: name);
  if (res != null) {
    return res;
  } else {
    return [];
  }
});

final userRequestStreamProvider = StreamProvider<List<Friend>>((ref) {
  final user = ref.watch(userProvider.notifier);
  final name = ref.watch(friendsSearchProvider);
  return user.requestStream(name: name) ?? const Stream.empty();
});
