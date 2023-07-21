import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/location_info.dart';
import 'package:party/models/party.dart';
import 'package:party/services/service_notifier.dart';
import 'package:party/utils/auth_state_mixin.dart';
import 'package:uuid/uuid.dart';

class PartyService extends ServiceNotifier with AuthState {
  final CollectionReference partyCollection =
      FirebaseFirestore.instance.collection(MyStrings.parties);

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection(MyStrings.users);

  Stream<List<Party>>? partiesStream() {
    try {
      return partyCollection
          .where(MyStrings.invitedUids, arrayContains: uid)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Party.fromJson(e.data())).toList());
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Stream<List<Party>>? myPartiesStream() {
    try {
      return partyCollection
          .where(MyStrings.hostUid, isEqualTo: uid)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Party.fromJson(e.data())).toList());
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Stream<List<Party>>? upcomingPartiesStream() {
    try {
      return partyCollection
          .where(MyStrings.comingUids, arrayContains: uid)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Party.fromJson(e.data())).toList());
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Stream<List<Friend>>? comingStream({required Party party}) {
    try {
      List<String> list = party.comingUids.isNotEmpty ? party.comingUids : [''];
      return userCollection.where(MyStrings.uid, whereIn: list).snapshots().map(
          (event) => event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      setError(e);
      return null;
    }
  }

  Future<Party?> fetchParty({required String id}) async {
    try {
      toggleLoading();
      DocumentSnapshot documentSnapshot = await partyCollection.doc(id).get();
      return Party.fromJson(documentSnapshot.data());
    } catch (e) {
      setError(e);
      return null;
    } finally {
      toggleLoading();
    }
  }

  Future<void> addParty({
    required String? name,
    required String? about,
    required int? price,
    required String? imgUrl,
    required Timestamp? time,
    required List<String>? invitedUids,
    required LocationInfo? locationInfo,
  }) async {
    try {
      toggleLoading();
      if (name == null ||
          about == null ||
          price == null ||
          imgUrl == null ||
          time == null ||
          locationInfo == null ||
          name.trim() == '' ||
          about.trim() == '' ||
          price.toString().trim() == '') {
        setError('No Field can be empty');
      } else {
        Uuid uuid = const Uuid();
        DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
        Party party = Party(
          id: uuid.v4(),
          time: time,
          about: about,
          imgUrl: imgUrl,
          name: name,
          price: price,
          comingUids: [],
          invitedUids: invitedUids ?? [],
          hostUid: uid,
          hostName: Friend.fromJson(documentSnapshot.data()).name,
          address: locationInfo.address,
          country: locationInfo.country,
          latitude: locationInfo.latitude,
          longitude: locationInfo.longitude,
          postalCode: locationInfo.postalCode,
        );
        await partyCollection.doc(party.id).set(party.toJson());
      }
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Future<void> removeParty({required String id}) async {
    try {
      toggleLoading();
      await partyCollection.doc(id).delete();
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Future<void> joinOrUnjoinParty({required Party party}) async {
    try {
      toggleLoading();
      if (party.comingUids.contains(uid)) {
        //await unjoinParty(id: party.id);
        setError('You Have alredy joined this party');
      } else {
        await joinParty(id: party.id);
      }
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Future<void> joinParty({required String id}) async {
    try {
      toggleLoading();
      await partyCollection.doc(id).update({
        MyStrings.comingUids: FieldValue.arrayUnion([uid])
      });
    } catch (e) {
      toggleLoading();
      setError(e);
    } finally {
      toggleLoading();
    }
  }

  Future<void> unjoinParty({required String id}) async {
    try {
      toggleLoading();
      await partyCollection.doc(id).update({
        MyStrings.comingUids: FieldValue.arrayRemove([uid])
      });
    } catch (e) {
      setError(e);
    } finally {
      toggleLoading();
    }
  }
}
