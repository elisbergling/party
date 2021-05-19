import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/colors.dart';
import 'package:party/constants/global.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/add_friend_tile.dart';
import 'package:party/widgets/background_gradient.dart';
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
    final party = useProvider(partyProvider);
    final partyData = useProvider(partyDataProvider);
    LatLng coords;
    partyData.state.latitude == null
        ? coords = LatLng(24.150, -110.32)
        : coords = LatLng(partyData.state.latitude, partyData.state.longitude);
    final partyComingStream =
        useProvider(partyComingStreamProvider(partyData.state));
    final someOneComing = useState<bool>(true);
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
              color: dark,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 0,
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      color: babyWhite,
                      borderRadius: BorderRadius.circular(30),
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
                                        timestamp: partyData.state.time) +
                                    '   ' +
                                    partyData.state.price.toString() +
                                    ' kr',
                                style: TextStyle(
                                  color: dark,
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
                              color: dark,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
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
              Text(
                someOneComing.value ? 'coming:' : 'No one is coming yet',
                style: TextStyle(
                  color: dark,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                height: someOneComing.value ? 90 : 0,
                child: partyComingStream.when(
                  data: (coming) {
                    if (coming.length == 0) {
                      someOneComing.value = false;
                      return Text('No one is coming yet');
                    } else {
                      someOneComing.value = true;
                      return ListView.builder(
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
              ),
              const SizedBox(height: 5),
              !party.isLoading
                  ? CustomButton(
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
                    )
                  : MyLoadingWidget(),
              //const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
