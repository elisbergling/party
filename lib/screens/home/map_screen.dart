import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/providers/map_provider.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/screens/home/add_party_screen.dart';
import 'package:party/widgets/party_tile.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class MapScreen extends HookWidget {
  const MapScreen({Key key}) : super(key: key);

  static const routeName = '/map';

  @override
  Widget build(BuildContext context) {
    //GoogleMapController mapController;
    final partyPartiesStream = useProvider(partyPartiesStreamProvider);
    final map = useProvider(mapProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Parties'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPartyScreen.routeName),
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            myLocationEnabled: true,
            compassEnabled: true,
            trafficEnabled: true,
            initialCameraPosition:
                CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
            onMapCreated: context.read(mapProvider).onMapCreated,
            onTap: (position) => context
                .read(mapProvider)
                .createMarkers(position.latitude, position.longitude),
            markers: Set<Marker>.of(map.markers.values),
          ),
          Container(
            height: 160,
            child: partyPartiesStream.when(
              data: (parties) => ListView.builder(
                shrinkWrap: true,
                itemCount: parties.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => PartyTile(
                  party: parties[index],
                  isOnMap: true,
                ),
              ),
              loading: () => MyLoadingWidget(),
              error: (e, s) => MyErrorWidget(e: e, s: s),
            ),
          ),
        ],
      ),
    );
  }
}
