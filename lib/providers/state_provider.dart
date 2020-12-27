import 'package:hooks_riverpod/all.dart';
import 'package:party/models/friend.dart';

final isLoginProvider = StateProvider<bool>((_) => false);

final pageIndexProvider = StateProvider<int>((_) => 0);

final partyDataProvider = StateProvider<String>((_) => null);

final messageDataProvider =
    StateProvider<Friend>((_) => Friend(name: 'Mr Bean'));
