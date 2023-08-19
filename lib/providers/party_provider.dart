import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/party.dart';
import 'package:party/models/service_data.dart';
import 'package:party/services/party_service.dart';

final partyProvider = NotifierProvider<PartyService, ServiceData>(() {
  return PartyService();
});

final partyPartiesStreamProvider = StreamProvider<List<Party>?>((ref) {
  return ref.watch(partyProvider.notifier).partiesStream();
});

final partyMyPartiesStreamProvider = StreamProvider<List<Party>>((ref) {
  return ref.watch(partyProvider.notifier).myPartiesStream();
});

final partyUpcomingPartiesStreamProvider = StreamProvider<List<Party>>((ref) {
  return ref.watch(partyProvider.notifier).upcomingPartiesStream();
});

final partyComingStreamProvider =
    StreamProvider.family<List<Friend>, Party>((ref, party) {
  return ref.watch(partyProvider.notifier).comingStream(party: party);
});
