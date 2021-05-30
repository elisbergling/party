import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart' as geoCo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:party/models/location_info.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapService with ChangeNotifier {
  GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;

  set mapController(mapController) => _mapController = mapController;

  Marker _marker;
  Marker get marker => _marker;

  Position _position;
  Position get position => _position;

  Future onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    final mapStyle = await rootBundle.loadString('assets/map_style.json');
    await _mapController.setMapStyle(mapStyle);
    await getCurrentLocation();
    notifyListeners();
  }

  Future getCurrentLocation() async {
    _position = await GeolocatorPlatform.instance.getCurrentPosition();
    notifyListeners();
  }

  Future<LocationInfo> getLocationInfo(LatLng pos) async {
    final coords = geoCo.Coordinates(pos.latitude, pos.longitude);
    final adress =
        await geoCo.Geocoder.local.findAddressesFromCoordinates(coords);
    final info = adress.first;
    return LocationInfo(
      address: info.addressLine,
      country: info.countryName,
      postalCode: info.postalCode,
      latitude: pos.latitude,
      longitude: pos.longitude,
    );
  }

  Future<double> distanceBetween(LatLng start) async {
    final end = await getCurrentLocation();
    return GeolocatorPlatform.instance.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  void addMarker(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
    );
    this._marker = _marker;
    notifyListeners();
  }
}
