import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/friend.dart';

class FriendService with ChangeNotifier {
  FriendService({
    @required this.uid,
  }) : assert(uid != null, 'Cannot create FriendService with null uid');
  final String uid;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = '';
  String get error => _error;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection(USERS);

  CollectionReference friendCollection() =>
      userCollection.doc(uid).collection(FRIENDS);

  Stream<Friend> friendStream({String uidTo}) {
    try {
      return friendCollection()
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
      return friendCollection().snapshots().map(
          (event) => event.docs.map((e) => Friend.fromJson(e.data())).toList());
      // return userCollection.where()
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<void> deleteFriend({String uidTo}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await friendCollection().doc(uidTo)?.delete();
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
      final user = await getFriendFuture();
      user.friendUids.add(friend.uid);
      await userCollection.doc(uid).update({'friendUids': user.friendUids});
      await friendCollection().doc(friend.uid).set(friend.toJson());
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Friend> getFriendFuture() async {
    try {
      _isLoading = true;
      notifyListeners();
      final userJson = await userCollection.doc(uid).get();
      return Friend.fromJson(userJson.data());
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

  Stream<Friend> getFriendStream() {
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
