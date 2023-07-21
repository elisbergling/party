import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
class MapServiceData {
  final GoogleMapController? controller;
  final Marker? marker;
  final Position? position;

  const MapServiceData({
    required this.controller,
    required this.marker,
    required this.position,
  });

  MapServiceData copyWith({
    GoogleMapController? controller,
    Marker? marker,
    Position? position,
  }) {
    return MapServiceData(
      controller: controller ?? this.controller,
      marker: marker ?? this.marker,
      position: position ?? this.position,
    );
  }
}
