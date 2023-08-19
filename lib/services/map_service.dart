import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/api_keys.dart';
import 'package:party/models/location_info.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:party/models/map_service_data.dart';

class MapService extends Notifier<MapServiceData> {
  @override
  MapServiceData build() {
    return const MapServiceData(
      controller: null,
      marker: null,
      position: null,
    );
  }

  Future onMapCreated(GoogleMapController controller) async {
    state = state.copyWith(controller: controller);
    final mapStyle = await rootBundle.loadString('assets/map_style.json');
    await state.controller!.setMapStyle(mapStyle);
    await getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    final position = await GeolocatorPlatform.instance.getCurrentPosition();
    state = state.copyWith(position: position);
  }

  Future<LocationInfo> getLocationInfo(LatLng pos) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${pos.latitude},${pos.longitude}&key=$googleAPIKey';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    final info =
        data['results'][0]['address_components'][0]; //this is probablly wrong
    return LocationInfo(
      address: info.addressLine ?? 'No Adress Found',
      country: info.countryName ?? 'No Country Found',
      postalCode: info.postalCode ?? 'No Postal Code Found',
      latitude: pos.latitude,
      longitude: pos.longitude,
    );
  }

  Future<double> distanceBetween(LatLng start) async {
    await getCurrentLocation();
    return GeolocatorPlatform.instance.distanceBetween(
      start.latitude,
      start.longitude,
      state.position!.latitude,
      state.position!.longitude,
    );
  }

  void addMarker(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    );
    state = state.copyWith(marker: marker);
  }
}
