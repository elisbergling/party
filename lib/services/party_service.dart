import 'package:flutter/foundation.dart';

class PartyService with ChangeNotifier {
  PartyService({@required this.uid})
      : assert(uid != null, 'Cannot create PartyService with null uid');
  final String uid;
}
