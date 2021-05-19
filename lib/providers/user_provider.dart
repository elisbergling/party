import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/services/user_service.dart';

final userProvider = ChangeNotifierProvider<UserService>((ref) {
  final auth = ref?.watch(authStateChangesProvider);
  if (auth?.data?.value?.uid != null) {
    return UserService(uid: auth?.data?.value?.uid);
  }
  return null;
});

final userCreateUserProvider = ChangeNotifierProvider<UserServiceCreateUser>(
    (_) => UserServiceCreateUser());

final userUserStreamProvider = StreamProvider.autoDispose<Friend>((ref) {
  final user = ref?.watch(userProvider);
  ref.maintainState = true;
  return user?.userStream() ?? const Stream.empty();
});

final userUsersStreamProvider = StreamProvider.autoDispose<List<Friend>>((ref) {
  final user = ref?.watch(userProvider);
  final name = ref?.watch(friendsSearchProvider);
  ref.maintainState = true;
  return user?.usersStream(name: name.state) ?? const Stream.empty();
});

final userUsersFutureProvider =
    FutureProvider.autoDispose<List<Friend>>((ref) async {
  final user = ref?.watch(userProvider);
  final name = ref?.watch(friendsSearchProvider);
  ref.maintainState = true;
  return await user?.usersFuture(name: name.state) ?? const Stream.empty();
});

final userRequestStreamProvider =
    StreamProvider.autoDispose<List<Friend>>((ref) {
  final user = ref?.watch(userProvider);
  final name = ref?.watch(friendsSearchProvider);
  ref.maintainState = true;
  return user?.requestStream(name: name.state) ?? const Stream.empty();
});
