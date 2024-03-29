import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/enum.dart';
import 'package:party/models/friend.dart';
import 'package:party/models/location_info.dart';
import 'package:party/models/party.dart';

final isLoginProvider = StateProvider<bool>((_) => false);

final pageIndexProvider = StateProvider<int>((_) => 0);

final partyDataProvider = StateProvider<Party?>((_) => null);

final isRequestProvider = StateProvider<bool>((_) => false);

final invitedUidsProvider = StateProvider<List<String>>((_) => []);

final groupMembersUidsProvider = StateProvider<List<String>>((_) => []);

final friendsSearchProvider = StateProvider<String>((_) => '');

final partyDateProvider = StateProvider<DateTime?>((_) => null);

final partyTimeOfDayProvider = StateProvider<TimeOfDay?>((_) => null);

final messageTypeProvider =
    StateProvider<MessageType>((_) => MessageType.friends);

final profileStreamTypeProvider =
    StateProvider<ProfileStreamType>((_) => ProfileStreamType.friends);

final messageDataProvider = StateProvider<dynamic>(
    (_) => Friend.empty(name: 'Start texting with your friends'));

final locationInfoProvider = StateProvider<LocationInfo?>((_) => null);
