import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/services/map_service.dart';

final mapProvider = Provider<MapService>((_) => MapService());

final mapDistanceBetweenProvider = FutureProvider.family<double, LatLng>(
    (ref, start) => ref.watch(mapProvider).distanceBetween(start));
