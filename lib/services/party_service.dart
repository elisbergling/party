import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:party/constants/strings.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/party.dart';
import 'package:uuid/uuid.dart';

class PartyService with ChangeNotifier {
  PartyService({@required this.uid})
      : assert(uid != null, 'Cannot create PartyService with null uid');
  final String uid;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = '';
  String get error => _error;

  final CollectionReference partyCollection =
      FirebaseFirestore.instance.collection(PARTIES);

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection(USERS);

  Stream<List<Party>> partiesStream() async* {
    try {
      DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
      Friend user = Friend.fromJson(documentSnapshot.data());
      yield* partyCollection
          .where(HOST_UID,
              whereIn: user.friendUids.isNotEmpty ? user.friendUids : [''])
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Party.fromJson(e.data())).toList());
    } catch (e) {
      print(e.toString());
      yield null;
    }
  }

  Stream<List<Party>> myPartiesStream() {
    try {
      return partyCollection.where(HOST_UID, isEqualTo: uid).snapshots().map(
          (event) => event.docs.map((e) => Party.fromJson(e.data())).toList());
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Stream<List<Friend>> comingStream({Party party}) {
    try {
      List<String> list =
          party.comingUids.isNotEmpty ? party?.comingUids : [''];
      return userCollection.where(UID, whereIn: list).snapshots().map(
          (event) => event.docs.map((e) => Friend.fromJson(e.data())).toList());
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Party> fetchParty({String id}) async {
    try {
      _isLoading = true;
      notifyListeners();
      DocumentSnapshot documentSnapshot = await partyCollection.doc(id).get();
      return Party.fromJson(documentSnapshot.data());
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

  Future<void> addParty({
    String name,
    String about,
    int price,
    String imgUrl,
    Timestamp time,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      if (name == null ||
          about == null ||
          price == null ||
          imgUrl == null ||
          time == null ||
          name.trim() == '' ||
          about.trim() == '' ||
          price.toString().trim() == '') {
        return;
      } else {
        Uuid uuid = Uuid();
        DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
        Party party = Party(
          id: uuid.v4(),
          time: time,
          about: about,
          imgUrl: imgUrl,
          name: name,
          price: price,
          comingUids: [],
          hostUid: uid,
          hostName: Friend.fromJson(documentSnapshot.data()).name,
        );
        await partyCollection.doc(party.id).set(party.toJson());
      }
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeParty({String id}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await partyCollection.doc(id).delete();
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> joinOrRegretParty({Party party}) async {
    try {
      _isLoading = true;
      notifyListeners();
      if (party.comingUids.contains(uid)) {
        await regretParty(id: party.id);
      } else {
        await joinParty(id: party.id);
      }
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> joinParty({String id}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await partyCollection.doc(id).update({
        COMING_UIDS: FieldValue.arrayUnion([uid])
      });
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> regretParty({String id}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await partyCollection.doc(id).update({
        COMING_UIDS: FieldValue.arrayRemove([uid])
      });
    } catch (e) {
      print(e.message);
      _error = e.message;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
