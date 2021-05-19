import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/image_provider.dart';

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

  Stream<List<Friend>> usersStream({String name}) {
    try {
      return userCollection.where(USERNAME, isEqualTo: name).snapshots().map(
          (event) => event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Future<List<Friend>> usersFuture({String name}) async {
    try {
      return await userCollection.where(USERNAME, isEqualTo: name).get().then(
          (event) => event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
      return null;
    }
  }

  Stream<List<Friend>> requestStream({String name}) {
    try {
      return userCollection
          //.where(NAME, isGreaterThanOrEqualTo: name)
          //.where(NAME, isLessThanOrEqualTo: name + '\uf8ff')
          .where(REQUEST_UIDS, arrayContains: uid)
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

  Future<Friend> getUserFuture() async {
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

  Future<void> updateImgUrl({String uid}) async {
    try {
      _isLoading = true;
      notifyListeners();
      String url;
      url = await ProviderContainer().read(imageProvider).getDownloadUrl(uid);
      await userCollection.doc(uid)?.update({
        IMG_URL: url,
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

  Future<void> updateUser({
    String name,
    String username,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      await userCollection.doc(uid)?.update({
        NAME: name,
        USERNAME: username,
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
        requestUids: [],
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
