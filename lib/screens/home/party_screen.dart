import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/global.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:party/widgets/friend_tile.dart';
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
    final partyComingStream =
        useProvider(partyComingStreamProvider(partyData.state));
    return Scaffold(
      appBar: AppBar(
        title: Text('check this party out'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
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
                  partyData.state.name +
                      '  ' +
                      partyData.state.price.toString() +
                      ' kr',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(partyData.state.about),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('3 stareet baba'),
                Text('3 km from you'),
              ],
            ),
          ),
          Text('coming:'),
          Container(
            height: 160,
            child: partyComingStream.when(
              data: (coming) => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: coming.length,
                itemBuilder: (context, index) => FriendTile(
                  friend: coming[index],
                ),
              ),
              loading: () => MyLoadingWidget(),
              error: (e, s) {
                print('error: ' + e);
                print('stackTrace: ' + s.toString());
                return MyErrorWidget(e: e, s: s);
              },
            ),
          ),
          !party.isLoading
              ? RaisedButton(
                  onPressed: () async {
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
                  child: Text('join party'),
                )
              : MyLoadingWidget(),
        ],
      ),
    );
  }
}
