import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/image_provider.dart';
import 'package:party/services/service_notifier.dart';
import 'package:party/utils/auth_state_mixin.dart';

class UserService extends ServiceNotifier with AuthState {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection(MyStrings.users);

  Stream<Friend>? userStream() {
    try {
      return userCollection
          .doc(uid)
          .snapshots()
          .map((map) => Friend?.fromJson(map.data()));
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Stream<List<Friend>>? usersStream({required String name}) {
    try {
      return userCollection
          .where(MyStrings.username, isEqualTo: name)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Future<List<Friend>?> usersFuture({required String name}) async {
    try {
      return await userCollection
          .where(MyStrings.username, isEqualTo: name)
          .get()
          .then((event) =>
              event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Stream<List<Friend>>? requestStream({required String name}) {
    try {
      return userCollection
          //.where(NAME, isGreaterThanOrEqualTo: name)
          //.where(NAME, isLessThanOrEqualTo: name + '\uf8ff')
          .where(MyStrings.requestUids, arrayContains: uid)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Future<Friend?> getUserFuture() async {
    try {
      toggleLoading();
      final userJson = await userCollection.doc(uid).get();
      return Friend.fromJson(userJson.data());
    } catch (e) {
      setError(e);
      return null;
    } finally {
      toggleLoading();
    }
  }

  Future<void> deleteUser() async {
    try {
      toggleLoading();
      await userCollection.doc(uid).delete();
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Future<void> updateImgUrl({required String uid}) async {
    try {
      toggleLoading();
      String? url;
      url = await ProviderContainer()
          .read(imageProvider.notifier)
          .getDownloadUrl(uid);
      await userCollection.doc(uid).update({
        MyStrings.imgUrl: url,
      });
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Future<void> updateUser({
    required String name,
    required String username,
  }) async {
    try {
      toggleLoading();
      await userCollection.doc(uid).update({
        MyStrings.name: name,
        MyStrings.username: username,
      });
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }
}

class UserServiceCreateUser extends ServiceNotifier {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection(MyStrings.users);
  Future<void> createUser({
    required String? email,
    required String? name,
    required String? username,
    required String? imgUrl,
    required String uid,
  }) async {
    try {
      toggleLoading();
      Friend user = Friend(
        name: name ?? '',
        username: username ?? uid,
        email: email ?? '',
        uid: uid,
        imgUrl: imgUrl ?? '',
        friendUids: [],
        requestUids: [],
      );
      await userCollection.doc(uid).set(user.toJson());
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }
}
