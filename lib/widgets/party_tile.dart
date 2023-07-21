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
import 'package:party/widgets/info_box.dart';
import 'package:party/widgets/border_gradient.dart';

class PartyTile extends HookConsumerWidget {
  const PartyTile({
    super.key,
    required this.party,
    this.isOnMap = false,
  });

  final Party party;
  final bool isOnMap;

  void navigate(BuildContext context, WidgetRef ref) {
    ref.read(partyDataProvider.notifier).state = party;
    Navigator.of(context).pushReplacementNamed(PartyScreen.routeName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 15));
    final map = ref.watch(mapProvider);
    return GestureDetector(
      onTapDown: (_) => !isOnMap ? controller.forward() : null,
      onTapUp: (_) => !isOnMap ? controller.reverse() : null,
      onTap: !isOnMap
          ? () => navigate(context, ref)
          : () async {
              await map.controller!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: party.latitude != null
                        ? LatLng(party.latitude!, party.longitude!)
                        : const LatLng(24.150, -110.32),
                    zoom: 16,
                  ),
                ),
              );
            },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
        child: AnimatedPartyTile(
          animation: Tween<double>(begin: 1.0, end: 0.0).animate(controller),
          isOnMap: isOnMap,
          party: party,
        ),
      ),
    );
  }
}

class AnimatedPartyTile extends AnimatedWidget {
  const AnimatedPartyTile({
    super.key,
    required Animation<double> animation,
    required this.isOnMap,
    required this.party,
  }) : super(listenable: animation);

  final bool isOnMap;
  final Party party;

  void navigate(BuildContext context, WidgetRef ref) {
    ref.read(partyDataProvider.notifier).state = party;
    Navigator.of(context).pushReplacementNamed(PartyScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
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
            color: MyColors.black,
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
              SizedBox(
                width: isOnMap ? 110 : MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      party.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: MyColors.white,
                      ),
                    ),
                    SizedBox(
                      width: isOnMap
                          ? 110
                          : MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        party.about,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: MyColors.grey,
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${party.price} kr',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: MyColors.purple,
                          ),
                        ),
                        !isOnMap
                            ? InfoBox(text: timeAGo(timestamp: party.time))
                            : Container(
                                height: 25,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: MyColors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Consumer(
                                    child: const Text(
                                      'more',
                                      style: TextStyle(
                                        color: MyColors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    builder: (context, ref, child) =>
                                        GestureDetector(
                                      onTap: () => navigate(context, ref),
                                      child: child,
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
