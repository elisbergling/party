import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/models/map_service_data.dart';
import 'package:party/services/map_service.dart';

final mapProvider =
    NotifierProvider<MapService, MapServiceData>(() => MapService());

final mapDistanceBetweenProvider = FutureProvider.family<double, LatLng>(
    (ref, start) async =>
        await ref.watch(mapProvider.notifier).distanceBetween(start));
