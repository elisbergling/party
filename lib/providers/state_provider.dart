import 'package:hooks_riverpod/all.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/party.dart';

final isLoginProvider = StateProvider<bool>((_) => false);

final pageIndexProvider = StateProvider<int>((_) => 0);

final partyDataProvider = StateProvider<Party>((_) => null);

final isRequestProvider = StateProvider<bool>((_) => false);

final messageDataProvider =
    StateProvider<Friend>((_) => Friend(name: 'Mr Bean'));
