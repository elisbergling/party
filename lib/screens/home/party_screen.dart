import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:party/constants/colors.dart';
import 'package:party/constants/global.dart';
import 'package:party/models/party.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/services/party_service.dart';
import 'package:party/widgets/add_friend_tile.dart';
import 'package:party/widgets/background_gradient.dart';
import 'package:party/widgets/border_gradient.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:party/widgets/custom_back_button.dart';
import 'package:party/widgets/custom_button.dart';
import 'package:party/widgets/map_dialog.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class PartyScreen extends HookConsumerWidget {
  const PartyScreen({super.key});

  static const routeName = '/party';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(authProvider).auth.currentUser.uid;
    final party = ref.watch(partyProvider);
    final partyData = ref.watch(partyDataProvider);
    LatLng coords;
    partyData == null
        ? coords = const LatLng(24.150, -110.32)
        : coords = LatLng(partyData.latitude, partyData.longitude);
    final partyComingStream = ref.watch(partyComingStreamProvider(partyData));
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          leading: const CustomBackButton(
            shouldNotJustPop: true,
          ),
          title: Text(
            partyData.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: MyColors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: BorderGradient(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      color: MyColors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 35),
                        CachedImage(
                          partyData.imgUrl,
                          name: partyData.name,
                          height: 250,
                          width: 250,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formatTimestamp(
                                  timestamp: partyData.time,
                                ),
                                style: const TextStyle(
                                  color: MyColors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '   ${partyData.price.toString()} kr',
                                style: const TextStyle(
                                  color: MyColors.purple,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            partyData.about,
                            style: const TextStyle(
                              color: MyColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(
                            color: MyColors.grey,
                            height: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                partyData.address == null
                                    ? 'adress'
                                    : partyData.address.split(',')[0],
                                style: const TextStyle(color: grey),
                              ),
                              CustomButton(
                                text: 'View on Map',
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => MapDialog(
                                    shouldAdd: false,
                                    adress: partyData.address ?? 'adress',
                                    coords: coords,
                                  ),
                                ),
                              ),
                              /*
                              mapDistanceBetween.when(
                                data: (distanceBetween) => Text(
                                    '${distanceBetween.toString()} meters from you'),
                                loading: () => MyLoadingWidget(),
                                error: (e, s) => MyErrorWidget(
                                  e: e.toString(),
                                  s: s,
                                ),
                              )*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              partyComingStream.when(
                data: (coming) {
                  if (coming.length == 0) {
                    return Column(children: [
                      const Text(
                        'No one is coming yet',
                        style: TextStyle(color: MyColors.white),
                      ),
                      const SizedBox(height: 10),
                      !party.isLoading
                          ? buildCustomButton(context, partyData, party)
                          : const MyLoadingWidget(),
                    ]);
                  } else {
                    return Column(
                      children: [
                        const Text(
                          'Coming:',
                          style: TextStyle(
                            color: MyColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          height: 80,
                          child: ListView.builder(
                            cacheExtent: 10000,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: coming.length,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(
                                bottom: 10,
                                right: index == coming.length - 1 ? 10 : 0,
                              ),
                              child: AddFriendTile(
                                friend: coming[index],
                                isLeft: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        !coming.any((element) => element.uid == uid)
                            ? buildCustomButton(context, partyData, party)
                            : party.isLoading
                                ? const MyLoadingWidget()
                                : Container(),
                      ],
                    );
                  }
                },
                loading: () => const MyLoadingWidget(),
                error: (e, s) => MyErrorWidget(e: e, s: s),
              ),

              //const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  CustomButton buildCustomButton(BuildContext context,
      StateController<Party> partyData, PartyService party) {
    return CustomButton(
      onTap: () async {
        await context
            .read(partyProvider)
            .joinOrUnjoinParty(party: partyData.state);
        showActionDialog(
          ctx: context,
          service: party,
          message: party.error,
          title: party.error == ''
              ? 'Joined Party Sucessfully'
              : 'Something went wrong',
        );
        Navigator.of(context).pop();
      },
      text: 'join party',
    );
  }
}
