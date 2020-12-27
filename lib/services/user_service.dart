import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/friend.dart';

abstract class AbstractUserService with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = '';
  String get error => _error;
  set error(error) => _error = error;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection(USERS);
}

class UserService extends AbstractUserService {
  UserService({
    @required this.uid,
  }) : assert(uid != null, 'Cannot create UserService with null uid');
  final String uid;

  Stream<Friend> userStream() {
    try {
      return userCollection
          .doc(uid)
          .snapshots()
          ?.map((map) => Friend?.fromJson(map?.data()));
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Stream<List<Friend>> usersStream() {
    try {
      return userCollection.snapshots().map(
          (event) => event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<Friend> userFuture() {
    try {
      _isLoading = true;
      notifyListeners();
      return userCollection
          .doc(uid)
          .get()
          ?.then((map) => Friend?.fromJson(map?.data()));
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

  Future<void> deleteUser() async {
    try {
      _isLoading = true;
      notifyListeners();
      await userCollection.doc(uid)?.delete();
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser({
    String name,
    String username,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      await userCollection.doc(uid)?.update({
        'name': name,
        'username': username,
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

  Future<void> updateFriendsUids({
    List<String> friendsUids,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      await userCollection.doc(uid)?.update({'friendsUids': friendsUids});
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

class UserServiceCreateUser extends AbstractUserService {
  Future<void> createUser({
    String email,
    String name,
    String username,
    String imgUrl,
    String uid,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      Friend user = Friend(
        name: name ?? '',
        username: username ?? uid,
        email: email ?? '',
        uid: uid,
        imgUrl: imgUrl ?? '',
        friendUids: [],
      );
      await userCollection.doc(uid)?.set(user?.toJson());
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
