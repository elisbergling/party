import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/providers/auth_provider.dart';

mixin AuthState {
  String get uid {
    final user = ProviderContainer().read(authStateChangesProvider);
    if (user.value?.uid != null) {
      return user.value!.uid;
    } else {
      return 'This should be impossible';
    }
  }
}
