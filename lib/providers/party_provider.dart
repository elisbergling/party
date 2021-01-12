import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/party.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/services/party_service.dart';

final partyProvider = ChangeNotifierProvider<PartyService>((ref) {
  final auth = ref?.watch(authStateChangesProvider);

  if (auth?.data?.value?.uid != null) {
    return PartyService(uid: auth?.data?.value?.uid);
  }
  return null;
});

final partyPartiesStreamProvider =
    StreamProvider.autoDispose<List<Party>>((ref) {
  final party = ref?.watch(partyProvider);
  ref.maintainState = true;
  return party?.partiesStream() ?? const Stream.empty();
});

final partyMyPartiesStreamProvider =
    StreamProvider.autoDispose<List<Party>>((ref) {
  final party = ref?.watch(partyProvider);
  ref.maintainState = true;
  return party?.myPartiesStream() ?? const Stream.empty();
});

final partyUpcomingPartiesStreamProvider =
    StreamProvider.autoDispose<List<Party>>((ref) {
  final party = ref?.watch(partyProvider);
  ref.maintainState = true;
  return party?.upcomingPartiesStream() ?? const Stream.empty();
});

final partyComingStreamProvider =
    StreamProvider.autoDispose.family<List<Friend>, Party>((ref, party) {
  final partyService = ref?.watch(partyProvider);
  ref.maintainState = true;
  return partyService?.comingStream(party: party) ?? const Stream.empty();
});
