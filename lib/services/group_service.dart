import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/group.dart';
import 'package:party/services/service_notifier.dart';
import 'package:party/utils/auth_state_mixin.dart';
import 'package:uuid/uuid.dart';

class GroupService extends ServiceNotifier with AuthState {
  CollectionReference groupCollection =
      FirebaseFirestore.instance.collection(MyStrings.groups);

  Stream<List<Group>>? groupsStream() {
    try {
      return groupCollection
          .where(MyStrings.membersUids, arrayContains: uid)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Group.fromJson(e.data())).toList());
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Future<void> addGroup({
    required String name,
    required String imgUrl,
    required List<String> membersUids,
  }) async {
    try {
      toggleLoading();
      Uuid uuid = const Uuid();
      if (!membersUids.contains(uid)) {
        membersUids.add(uid);
      }
      Group group = Group(
        id: uuid.v4(),
        imgUrl: imgUrl,
        membersUids: membersUids,
        name: name,
      );
      groupCollection.doc(group.id).set(group.toJson());
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }
}
