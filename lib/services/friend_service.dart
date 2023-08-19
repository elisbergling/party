import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/friend.dart';
import 'package:party/services/service_notifier.dart';

class FriendService extends ServiceNotifier {
  final String? uid = FirebaseAuth.instance.currentUser?.uid;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection(MyStrings.users);

  Stream<Friend>? friendStream({required String uidTo}) {
    try {
      return userCollection
          .doc(uidTo)
          .snapshots()
          .map((map) => Friend?.fromJson(map.data()));
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Stream<List<Friend>>? friendsStream() {
    try {
      return userCollection
          .where(MyStrings.friendUids, arrayContains: uid)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Future<List<Friend>?> friendsFuture() async {
    try {
      toggleLoading();
      return await userCollection
          .where(MyStrings.friendUids, arrayContains: uid)
          .get()
          .then((event) =>
              event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      setError(e);
      return null;
    } finally {
      toggleLoading();
    }
  }

  Future<void> deleteFriend({required String uidTo}) async {
    try {
      toggleLoading();
      await userCollection.doc(uid).update({
        MyStrings.friendUids: FieldValue.arrayRemove([uidTo])
      });
      await userCollection.doc(uidTo).update({
        MyStrings.friendUids: FieldValue.arrayRemove([uid])
      });
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Future<void> addFriend({required Friend friend}) async {
    try {
      toggleLoading();
      if (friend.friendUids.contains(uid)) {
        return;
      } else {
        if (friend.requestUids.contains(uid)) {
          await acceptFriendRequest(uidTo: friend.uid);
        } else {
          await makeFriendRequest(uidTo: friend.uid);
        }
      }
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Future<void> acceptFriendRequest({required String uidTo}) async {
    try {
      toggleLoading();
      await userCollection.doc(uidTo).update({
        MyStrings.requestUids: FieldValue.arrayRemove([uid])
      });
      await userCollection.doc(uid).update({
        MyStrings.friendUids: FieldValue.arrayUnion([uidTo])
      });
      await userCollection.doc(uidTo).update({
        MyStrings.friendUids: FieldValue.arrayUnion([uid])
      });
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Future<void> denyFriendRequest({required String uidTo}) async {
    try {
      toggleLoading();
      await userCollection.doc(uidTo).update({
        MyStrings.requestUids: FieldValue.arrayRemove([uid])
      });
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Future<void> makeFriendRequest({required String uidTo}) async {
    try {
      toggleLoading();
      await userCollection.doc(uid).update({
        MyStrings.requestUids: FieldValue.arrayUnion([uidTo])
      });
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Stream<Friend>? getMyStream() {
    try {
      toggleLoading();
      return userCollection
          .doc(uid)
          .snapshots()
          .map((event) => Friend.fromJson(event.data()));
    } catch (e) {
      setError(e);
      return null;
    } finally {
      toggleLoading();
    }
  }
}
