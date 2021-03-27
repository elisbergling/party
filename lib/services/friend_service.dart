import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/friend.dart';

class FriendService with ChangeNotifier {
  FriendService({
    @required this.uid,
    //@required this.user,
  }) : assert(uid != null, 'Cannot create FriendService with null uid');
  final String uid;
  //final Friend user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = '';
  String get error => _error;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection(USERS);

  Stream<Friend> friendStream({String uidTo}) {
    try {
      return userCollection
          .doc(uidTo)
          .snapshots()
          ?.map((map) => Friend?.fromJson(map?.data()));
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Stream<List<Friend>> friendsStream() {
    try {
      return userCollection
          .where(FRIEND_UIDS, arrayContains: uid)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<List<Friend>> friendsFuture() async {
    try {
      _isLoading = true;
      notifyListeners();
      return await userCollection
          .where(FRIEND_UIDS, arrayContains: uid)
          .get()
          .then((event) =>
              event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFriend({String uidTo}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await userCollection.doc(uid).update({
        FRIEND_UIDS: FieldValue.arrayRemove([uidTo])
      });
      await userCollection.doc(uidTo).update({
        FRIEND_UIDS: FieldValue.arrayRemove([uid])
      });
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFriend({Friend friend}) async {
    try {
      _isLoading = true;
      notifyListeners();
      if (friend.friendUids.contains(uid)) {
        return null;
      } else {
        if (friend.requestUids.contains(uid)) {
          await acceptFriendRequest(uidTo: friend.uid);
        } else {
          await makeFriendRequest(uidTo: friend.uid);
        }
      }
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptFriendRequest({String uidTo}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await userCollection.doc(uidTo).update({
        REQUEST_UIDS: FieldValue.arrayRemove([uid])
      });
      await userCollection.doc(uid).update({
        FRIEND_UIDS: FieldValue.arrayUnion([uidTo])
      });
      await userCollection.doc(uidTo).update({
        FRIEND_UIDS: FieldValue.arrayUnion([uid])
      });
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> denyFriendRequest({String uidTo}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await userCollection.doc(uidTo).update({
        REQUEST_UIDS: FieldValue.arrayRemove([uid])
      });
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> makeFriendRequest({String uidTo}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await userCollection.doc(uid).update({
        REQUEST_UIDS: FieldValue.arrayUnion([uidTo])
      });
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<Friend> getMyStream() {
    try {
      _isLoading = true;
      notifyListeners();
      return userCollection
          .doc(uid)
          .snapshots()
          .map((event) => Friend.fromJson(event.data()));
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
