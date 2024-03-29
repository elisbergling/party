import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/group.dart';
import 'package:party/models/service_data.dart';
import 'package:party/services/group_service.dart';

final groupProvider =
    NotifierProvider<GroupService, ServiceData>(() => GroupService());

final groupGroupsStreamProvider = StreamProvider<List<Group>>((ref) {
  final friend = ref.watch(groupProvider.notifier);
  return friend.groupsStream() ?? Stream.value([]);
});
