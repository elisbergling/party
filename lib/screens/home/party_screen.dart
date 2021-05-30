import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

class PartyScreen extends HookWidget {
  const PartyScreen({
    Key key,
  }) : super(key: key);

  static const routeName = '/party';

  @override
  Widget build(BuildContext context) {
    final uid = useProvider(authProvider).auth.currentUser.uid;
    final party = useProvider(partyProvider);
    final partyData = useProvider(partyDataProvider);
    LatLng coords;
    partyData.state.latitude == null
        ? coords = LatLng(24.150, -110.32)
        : coords = LatLng(partyData.state.latitude, partyData.state.longitude);
    final partyComingStream =
        useProvider(partyComingStreamProvider(partyData.state));
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          leading: CustomBackButton(
            shouldNotJustPop: true,
          ),
          title: Text(
            partyData.state.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                      color: black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 35),
                        CachedImage(
                          partyData.state.imgUrl,
                          name: partyData.state.name,
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
                                    timestamp: partyData.state.time),
                                style: TextStyle(
                                  color: white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '   ${partyData.state.price.toString()} kr',
                                style: TextStyle(
                                  color: purple,
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
                            partyData.state.about,
                            style: TextStyle(
                              color: grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Divider(
                            color: grey,
                            height: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                partyData.state.address == null
                                    ? 'adress'
                                    : partyData.state.address.split(',')[0],
                                style: TextStyle(color: grey),
                              ),
                              CustomButton(
                                text: 'View on Map',
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => MapDialog(
                                    shouldAdd: false,
                                    adress: partyData.state.address ?? 'adress',
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
                      Text(
                        'No one is coming yet',
                        style: TextStyle(color: white),
                      ),
                      const SizedBox(height: 10),
                      !party.isLoading
                          ? buildCustomButton(context, partyData, party)
                          : MyLoadingWidget(),
                    ]);
                  } else {
                    return Column(
                      children: [
                        Text(
                          'Coming:',
                          style: TextStyle(
                            color: white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          height: 80,
                          child: ListView.builder(
                            cacheExtent: 10000,
                            physics: BouncingScrollPhysics(),
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
                                ? MyLoadingWidget()
                                : Container(),
                      ],
                    );
                  }
                },
                loading: () => MyLoadingWidget(),
                error: (e, s) {
                  print('error: ' + e);
                  print('stackTrace: ' + s.toString());
                  return MyErrorWidget(e: e, s: s);
                },
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
