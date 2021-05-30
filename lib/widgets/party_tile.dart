import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/constants/global.dart';
import 'package:party/models/party.dart';
import 'package:party/providers/map_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/screens/home/party_screen.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:party/widgets/info_box.dart';

import 'border_gradient.dart';

class PartyTile extends HookWidget {
  const PartyTile({
    Key key,
    this.party,
    this.isOnMap = false,
  }) : super(key: key);

  final Party party;
  final bool isOnMap;

  void navigate(BuildContext context) {
    context.read(partyDataProvider).state = party;
    Navigator.of(context).pushReplacementNamed(PartyScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final controller =
        useAnimationController(duration: Duration(milliseconds: 15));
    final map = useProvider(mapProvider);
    return GestureDetector(
      onTapDown: (_) => !isOnMap ? controller.forward() : null,
      onTapUp: (_) => !isOnMap ? controller.reverse() : null,
      onTap: !isOnMap
          ? () => navigate(context)
          : () async {
              await map.mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: party.latitude != null
                        ? LatLng(party.latitude, party.longitude)
                        : LatLng(24.150, -110.32),
                    zoom: 16,
                  ),
                ),
              );
            },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        child: AnimatedPartyTile(
            controller: controller, isOnMap: isOnMap, party: party),
      ),
    );
  }
}

class AnimatedPartyTile extends AnimatedWidget {
  const AnimatedPartyTile({
    AnimationController controller,
    @required this.isOnMap,
    @required this.party,
  }) : super(listenable: controller);

  final bool isOnMap;
  final Party party;
  AnimationController get controller => listenable;

  void navigate(BuildContext context) {
    context.read(partyDataProvider).state = party;
    Navigator.of(context).pushReplacementNamed(PartyScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 1.0, end: 0.0).animate(controller);
    return BorderGradient(
      child: Material(
        elevation: animation.value,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: isOnMap ? 250 : null,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImage(
                party.imgUrl,
                height: 80,
                width: 80,
                name: party.name,
              ),
              const SizedBox(width: 20),
              Container(
                width: isOnMap ? 110 : MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      party.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: white,
                      ),
                    ),
                    Container(
                      width: isOnMap
                          ? 110
                          : MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        party.about,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: grey,
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          party.price.toString() + ' kr',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: purple,
                          ),
                        ),
                        !isOnMap
                            ? InfoBox(text: timeAGo(timestamp: party.time))
                            : Container(
                                height: 25,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => navigate(context),
                                    child: Text(
                                      'more',
                                      style: TextStyle(
                                        color: blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
