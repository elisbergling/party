import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/services/party_service.dart';

final partyProvider = ChangeNotifierProvider<PartyService>((ref) {
  final auth = ref?.watch(authStateChangesProvider);

  if (auth?.data?.value?.uid != null) {
    return PartyService(uid: auth?.data?.value?.uid);
  }
  return null;
});
