import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/providers/map_provider.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/screens/home/add_party_screen.dart';
import 'package:party/widgets/glass_app_bar.dart';
import 'package:party/widgets/party_tile.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class MapScreen extends HookConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyPartiesStream = ref.watch(partyPartiesStreamProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        child: AppBar(
          backgroundColor: Colors.black.withOpacity(0.2),
          title: const Text(
            'Parties',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: MyColors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.add, color: MyColors.white),
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AddPartyScreen(),
                ),
              ),
            ),
          ],
          elevation: 0.0,
        ),
      ),
      body: partyPartiesStream.when(
        data: (parties) => parties != null && parties.isNotEmpty
            ? ClipRRect(
                child: Stack(
                  children: [
                    GoogleMap(
                      mapToolbarEnabled: false,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      compassEnabled: false,
                      trafficEnabled: false,
                      initialCameraPosition: CameraPosition(
                          target: parties[0].latitude != null
                              ? LatLng(
                                  parties[0].latitude!,
                                  parties[0].longitude!,
                                )
                              : const LatLng(24.150, -110.32),
                          zoom: 10),
                      onMapCreated: (controller) async => await ref
                          .read(mapProvider.notifier)
                          .onMapCreated(controller),
                      markers: parties
                          .map(
                            (party) => Marker(
                              markerId: MarkerId(party.id),
                              position: party.latitude != null
                                  ? LatLng(party.latitude!, party.longitude!)
                                  : const LatLng(24.150, -110.32),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueCyan,
                              ),
                              infoWindow: InfoWindow(
                                snippet: party.price.toString(),
                                title: party.name,
                              ),
                            ),
                          )
                          .toSet(),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top +
                          AppBar().preferredSize.height +
                          10,
                      right: 0,
                      left: 0,
                      child: SizedBox(
                        height: 140,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: parties.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => PartyTile(
                            party: parties[index],
                            isOnMap: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: Text(
                  'Where\'s the party at',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: MyColors.white,
                  ),
                ),
              ),
        loading: () => const MyLoadingWidget(),
        error: (e, s) => MyErrorWidget(e: e, s: s),
      ),
    );
  }
}
