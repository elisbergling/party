import 'package:flutter/material.dart';
import 'package:party/models/party.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/screens/home/party_screen.dart';
import 'package:party/widgets/cached_image.dart';
import 'package:flutter_riverpod/all.dart';

class PartyTile extends StatelessWidget {
  const PartyTile({
    Key key,
    this.party,
    this.isOnMap = false,
  }) : super(key: key);

  final Party party;
  final bool isOnMap;

  void navigate(BuildContext context) {
    context.read(partyDataProvider).state = party;
    Navigator.of(context).pushNamed(PartyScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: !isOnMap ? () => navigate(context) : () {},
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            width: 206,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColorDark,
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
                const SizedBox(width: 6),
                Container(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        party.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 80,
                        child: Text(
                          party.about,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 9,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Row(
                        children: [
                          Text(
                            party.price.toString() + ' kr',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.black54,
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
        if (isOnMap)
          Positioned(
            bottom: 12,
            right: 12,
            child: Center(
              child: Container(
                height: 25,
                width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () => navigate(context),
                    child: Text('more'),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
