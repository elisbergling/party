import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService with ChangeNotifier {
  AuthService({
    this.auth,
  });
  final FirebaseAuth auth;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = '';
  String get error => _error;
  set error(error) => _error = error;

  Future<void> logOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      await auth?.signOut();
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User> loginWithEmail({String email, String password}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await auth?.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return res?.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        _error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        _error = 'Wrong password provided for that user.';
      }
      notifyListeners();
      return null;
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

  Future<User> signUpAnonymously() async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await auth?.signInAnonymously();
      return res?.user;
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

  Future<User> signUpWithEmail({
    String email,
    String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      final res = await auth?.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return res?.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        _error = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        _error = 'The account already exists for that email.';
      }
      notifyListeners();
      return null;
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

  Future<User> signUpWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();
      GoogleSignIn gs = GoogleSignIn();
      final googleUser = await gs?.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider?.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final res = await auth?.signInWithCredential(credential);
      return res?.user;
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
