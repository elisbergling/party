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

final userUserStreamProvider = StreamProvider.autoDispose<Friend>((ref) {
  final user = ref.watch(userProvider.notifier);
  ref.keepAlive();
  return user.userStream() ?? const Stream.empty();
});

final userUsersStreamProvider = StreamProvider.autoDispose<List<Friend>>((ref) {
  final user = ref.watch(userProvider.notifier);
  final name = ref.watch(friendsSearchProvider);
  ref.keepAlive();
  return user.usersStream(name: name) ?? const Stream.empty();
});

final userUsersFutureProvider =
    FutureProvider.autoDispose<List<Friend>?>((ref) async {
  final user = ref.watch(userProvider.notifier);
  final name = ref.watch(friendsSearchProvider);
  ref.keepAlive();
  try {
    return await user.usersFuture(name: name);
  } catch (e) {
    return null;
  }
});

final userRequestStreamProvider =
    StreamProvider.autoDispose<List<Friend>>((ref) {
  final user = ref.watch(userProvider.notifier);
  final name = ref.watch(friendsSearchProvider);
  ref.keepAlive();
  return user.requestStream(name: name) ?? const Stream.empty();
});
