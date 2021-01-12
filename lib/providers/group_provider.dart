import 'package:hooks_riverpod/all.dart';
import 'package:party/models/group.dart';
import 'package:party/services/group_service.dart';

import 'auth_provider.dart';

final groupProvider = ChangeNotifierProvider<GroupService>((ref) {
  final auth = ref?.watch(authStateChangesProvider);
  if (auth?.data?.value?.uid != null) {
    return GroupService(
      uid: auth?.data?.value?.uid,
    );
  }
  return null;
});

final groupGroupsStreamProvider =
    StreamProvider.autoDispose<List<Group>>((ref) {
  final friend = ref?.watch(groupProvider);
  ref.maintainState = true;
  return friend?.groupsStream() ?? const Stream.empty();
});
