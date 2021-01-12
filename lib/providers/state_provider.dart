import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/enum.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/party.dart';

final isLoginProvider = StateProvider<bool>((_) => false);

final pageIndexProvider = StateProvider<int>((_) => 0);

final partyDataProvider = StateProvider<Party>((_) => null);

final isRequestProvider = StateProvider<bool>((_) => false);

final invitedUidsProvider = StateProvider<List<String>>((_) => []);

final groupMembersUidsProvider = StateProvider<List<String>>((_) => []);

final messageTypeProvider =
    StateProvider<MessageType>((_) => MessageType.Friends);

final messageDataProvider = StateProvider<dynamic>(
    (_) => Friend(name: 'Start texting with your friends'));
