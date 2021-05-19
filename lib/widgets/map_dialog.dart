import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:party/constants/colors.dart';
import 'package:party/models/location_info.dart';
import 'package:party/providers/map_provider.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/providers/state_provider.dart';
import 'package:search_map_place_v2/search_map_place_v2.dart';

class MapDialog extends HookWidget {
  const MapDialog({
    Key key,
    this.shouldAdd,
    this.adress,
    this.coords,
  }) : super(key: key);

  final bool shouldAdd;
  final String adress;
  final LatLng coords;

  @override
  Widget build(BuildContext context) {
    final marker = useState<Marker>();
    final locationInfo = useProvider(locationInfoProvider);
    final map = useProvider(mapProvider);
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(20),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: babyWhite,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: height - MediaQuery.of(context).padding.top - 150,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        compassEnabled: true,
                        trafficEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: shouldAdd ? LatLng(24.150, -110.32) : coords,
                          zoom: shouldAdd ? 1 : 16,
                        ),
                        onMapCreated: (controller) async => await context
                            .read(mapProvider)
                            .onMapCreated(controller),
                        onTap: shouldAdd
                            ? (pos) async {
                                MarkerId markerId = MarkerId(
                                    pos.latitude.toString() +
                                        pos.longitude.toString());
                                marker.value = Marker(
                                  markerId: markerId,
                                  position: pos,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueCyan),
                                );
                                LocationInfo locationInfo = await context
                                    .read(mapProvider)
                                    .getLocationInfo(pos);
                                context.read(locationInfoProvider).state =
                                    locationInfo;
                              }
                            : (pos) {},
                        markers: shouldAdd
                            ? {if (marker.value != null) marker.value}
                            : {
                                Marker(
                                  markerId: MarkerId(
                                    coords.latitude.toString() +
                                        coords.longitude.toString(),
                                  ),
                                  position: coords,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueCyan,
                                  ),
                                )
                              },
                      ),
                    ),
                  ),
                  if (shouldAdd)
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: SearchMapPlaceWidget(
                        iconColor: blue,
                        icon: CupertinoIcons.search,
                        apiKey: 'AIzaSyDLgg21XWrxLNqEFusgUwU9VHc4vwyufSY',
                        placeType: PlaceType.address,
                        placeholder: 'Enter a location',
                        hasClearButton: true,
                        language: 'en',
                        onSelected: (Place place) async {
                          Geolocation geolocation = await place.geolocation;
                          map.mapController.animateCamera(
                              CameraUpdate.newLatLng(geolocation.coordinates));
                          map.mapController.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                  geolocation.bounds, 0));
                        },
                      ),
                    )
                ],
              ),
              const SizedBox(height: 20),
              Text(
                shouldAdd
                    ? locationInfo.state != null
                        ? locationInfo.state.address
                        : 'Click on Map to choose location'
                    : adress,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: dark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}