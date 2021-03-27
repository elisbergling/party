import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService with ChangeNotifier {
  GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;
  set mapContoller(mapController) => _mapController = mapController;

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> get markers => _markers;

  Position _position;
  Position get position => _position;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void getCurrentLocation() async {
    _position = await GeolocatorPlatform.instance.getCurrentPosition();
    notifyListeners();
  }

  void createMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      infoWindow: InfoWindow(snippet: 'baba'),
    );
    _markers[markerId] = _marker;
    notifyListeners();
  }
}
