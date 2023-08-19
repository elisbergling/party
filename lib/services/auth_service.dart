import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/strings.dart';
import 'package:party/providers/user_provider.dart';
import 'package:party/services/service_notifier.dart';

class AuthService extends ServiceNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection(MyStrings.users);

  Future<void> logOut() async {
    try {
      toggleLoading();
      await auth.signOut();
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      toggleLoading();
      final res = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return res.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setError('Wrong password provided for that user.');
      }
      return null;
    } catch (e) {
      setError(e);
      return null;
    } finally {
      toggleLoading();
    }
  }

  Future<User?> signUpAnonymously() async {
    try {
      toggleLoading();
      final res = await auth.signInAnonymously();
      return res.user;
    } catch (e) {
      setError(e);
      return null;
    } finally {
      toggleLoading();
    }
  }

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String username,
  }) async {
    try {
      toggleLoading();
      final res = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (res.user != null) {
        await ProviderContainer()
            .read(userCreateUserProvider.notifier)
            .createUser(
              uid: res.user!.uid,
              email: email,
              name: name,
              username: username,
              imgUrl: '',
            );
      } else {
        throw Exception('User was enexceptedly null');
      }
      return res.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setError('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      setError(e);
      return null;
    } finally {
      toggleLoading();
    }
  }

  Future<User?> signUpWithGoogle() async {
    try {
      toggleLoading();
      GoogleSignIn gs = GoogleSignIn();
      final googleUser = await gs
          .signIn()
          .onError((error, stackTrace) => throw Exception(error.toString()));
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final res = await auth.signInWithCredential(credential);
      final user = await userCollection.doc(res.user?.uid).get();
      if (!user.exists) {
        await ProviderContainer()
            .read(userCreateUserProvider.notifier)
            .createUser(
              email: res.user!.email!,
              name: res.user!.displayName!,
              username: res.user!.email!,
              imgUrl: res.user!.photoURL!,
              uid: res.user!.uid,
            );
      }

      return res.user;
    } catch (e) {
      setError(e);
      return null;
    } finally {
      toggleLoading();
    }
  }
}
