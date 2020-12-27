import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/models/friend.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/friend_tile.dart';

class MapScreen extends HookWidget {
  const MapScreen({Key key}) : super(key: key);

  static const routeName = '/map';

  @override
  Widget build(BuildContext context) {
    final partyData = useProvider(partyDataProvider);
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 20,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => Container(
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
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.yellow,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'name',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color:
                                            Theme.of(context).primaryColorLight,
                                      ),
                                    ),
                                    Text(
                                      'price',
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
                                      .state = 'name' + i.toString())
                            ],
                          ),
                        ],
                      ),
                    ),
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
                      Container(
                        width: 250,
                        height: 250,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.yellow,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(partyData.state),
                            Text('  price'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                            'about party, dfbfbgsdfgbsdfjghsdfjghsdfjgsdfjkgsdfghdsifgsduigsdfgdsgsdfgsdfugsdfugysduygsdfugsdfugsdfugysdfgsuydfghsuyfgsdufgsdug'),
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
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 20,
                          itemBuilder: (context, index) => FriendTile(
                            friend: Friend(
                              name: 'baba',
                              username: 'babis',
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        child: Text('join party'),
                      )
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
