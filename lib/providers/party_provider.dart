import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/party.dart';
import 'package:party/models/service_data.dart';
import 'package:party/services/party_service.dart';

final partyProvider = NotifierProvider<PartyService, ServiceData>(() {
  return PartyService();
});

final partyPartiesStreamProvider =
    StreamProvider.autoDispose<List<Party>>((ref) {
  final party = ref.watch(partyProvider.notifier);
  ref.keepAlive();
  return party.partiesStream() ?? const Stream.empty();
});

final partyMyPartiesStreamProvider =
    StreamProvider.autoDispose<List<Party>>((ref) {
  final party = ref.watch(partyProvider.notifier);
  ref.keepAlive();
  return party.myPartiesStream() ?? const Stream.empty();
});

final partyUpcomingPartiesStreamProvider =
    StreamProvider.autoDispose<List<Party>>((ref) {
  final party = ref.watch(partyProvider.notifier);
  ref.keepAlive();
  return party.upcomingPartiesStream() ?? const Stream.empty();
});

final partyComingStreamProvider =
    StreamProvider.autoDispose.family<List<Friend>, Party>((ref, party) {
  final partyService = ref.watch(partyProvider.notifier);
  ref.keepAlive();
  return partyService.comingStream(party: party) ?? const Stream.empty();
});
