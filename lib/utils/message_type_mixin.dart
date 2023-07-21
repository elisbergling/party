import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/enum.dart';
import 'package:party/providers/state_provider.dart';

mixin MessageTypeState {
  MessageType get messageType {
    return ProviderContainer().read(messageTypeProvider);
  }
}
