import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/group.dart';
import 'package:uuid/uuid.dart';

class GroupService with ChangeNotifier {
  GroupService({
    @required this.uid,
  }) : assert(uid != null, 'Cannot create FriendService with null uid');
  final String uid;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = '';
  String get error => _error;
  set error(error) => _error = error;
  static List<String> groupUids = [];

  CollectionReference groupCollection =
      FirebaseFirestore.instance.collection(GROUPS);

  Stream<List<Group>> groupsStream() {
    try {
      return groupCollection
          .where(MEMBERS_UIDS, arrayContains: uid)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Group.fromJson(e.data())).toList());
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> addGroup({
    String name,
    String imgUrl,
    List<String> membersUids,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      Uuid uuid = Uuid();
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
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
