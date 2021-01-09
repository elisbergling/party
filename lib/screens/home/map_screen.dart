import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/models/party.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:party/widgets/friend_tile.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class MapScreen extends HookWidget {
  const MapScreen({Key key}) : super(key: key);

  static const routeName = '/map';

  @override
  Widget build(BuildContext context) {
    final party = useProvider(partyProvider);
    final partyData = useProvider(partyDataProvider);
    final partyPartiesStream = useProvider(partyPartiesStreamProvider);
    final partyComingStream =
        useProvider(partyComingStreamProvider(partyData.state));
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Stack(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  height: 120,
                  child: partyPartiesStream.when(
                    data: (parties) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: parties.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Container(
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).primaryColorDark,
                        ),
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(width: 15),
                                CachedImage(
                                  parties[index].imgUrl,
                                  name: parties[index].name,
                                  height: 50,
                                  width: 50,
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 50,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        parties[index].name,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                      Text(
                                        parties[index].price.toString(),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9,
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.more_horiz),
                                  iconSize: 20,
                                  onPressed: () => context
                                      .read(partyDataProvider)
                                      .state = parties[index],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    loading: () => MyLoadingWidget(),
                    error: (e, s) => MyErrorWidget(e: e, s: s),
                  ),
                ),
              ],
            ),
          ),
        ),
        partyData.state == null
            ? Container()
            : Container(
                width: 400,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('check this party out'),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () =>
                              context.read(partyDataProvider).state = null)
                    ],
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
                              onPressed: () async => await context
                                  .read(partyProvider)
                                  .joinParty(id: partyData.state.id),
                              child: Text('join party'),
                            )
                          : MyLoadingWidget(),
                      const SizedBox(height: 50),
                      RaisedButton(
                        onPressed: () async {
                          Party fetchedParty = await context
                              .read(partyProvider)
                              .fetchParty(id: partyData.state.id);
                          context.read(partyDataProvider).state = fetchedParty;
                        },
                        child: Text('refresh'),
                      )
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
