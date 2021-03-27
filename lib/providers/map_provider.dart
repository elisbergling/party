import 'package:hooks_riverpod/all.dart';
import 'package:party/services/map_service.dart';

final mapProvider = Provider<MapService>((_) => MapService());
