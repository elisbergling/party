import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/service_data.dart';
import 'package:party/services/auth_service.dart';

final initializeAppProvider =
    FutureProvider.autoDispose((_) async => await Firebase.initializeApp());

final firebaseAuthProvider =
    Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final authProvider = NotifierProvider<AuthService, ServiceData>(
  () => AuthService(),
);
