import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:party/screens/home/add_friend_screen.dart';
import 'package:party/screens/home/add_party_screen.dart';
import 'package:party/screens/home/profile_screen.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key key}) : super(key: key);

  static const routeName = '/user';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 400,
            child: ProfileScreen(),
          ),
          Expanded(
            child: Container(
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Historery'),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          buildTimeContainer('Mount', context),
                          buildTimeContainer('Week', context),
                          buildTimeContainer('Day', context),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).primaryColorDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 400,
            child: AddFriendScreen(),
          ),
          Container(
            width: 400,
            child: AddPartyScreen(),
          ),
        ],
      ),
    );
  }

  Container buildTimeContainer(String text, BuildContext context) {
    return Container(
      height: 40,
      width: 80,
      child: Center(child: Text(text)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }
}
