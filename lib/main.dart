import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/colors.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/screens/auth/auth_screen.dart';
import 'package:party/screens/home/add_friend_screen.dart';
import 'package:party/screens/home/add_group_screen.dart';
import 'package:party/screens/home/add_party_screen.dart';
import 'package:party/screens/home/friend_screen.dart';
import 'package:party/screens/home/map_screen.dart';
import 'package:party/screens/home/message_screen.dart';
import 'package:party/screens/home/messages_screen.dart';
import 'package:party/screens/home/party_screen.dart';
import 'package:party/screens/home/profile_screen.dart';
import 'package:party/screens/home/settings_screen.dart';
import 'package:party/screens/home/user_screen.dart';
import 'package:party/screens/temp/error_screen.dart';
import 'package:party/screens/temp/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final initializeApp = useProvider(initializeAppProvider);
    final authStateChanges = useProvider(authStateChangesProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Party',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: blue,
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(cursorColor: blue),
        iconTheme: IconThemeData(color: dark),
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          labelStyle: TextStyle(color: Colors.black),
          helperStyle: TextStyle(color: Colors.black),
        ),
      ),
      routes: {
        UserScreen.routeName: (context) => UserScreen(),
        MapScreen.routeName: (context) => MapScreen(),
        MessageScreen.routeName: (context) => MessageScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        FriendScreen.routeName: (context) => FriendScreen(),
        AddFriendScreen.routeName: (context) => AddFriendScreen(),
        AddGroupScreen.routeName: (context) => AddGroupScreen(),
        AddPartyScreen.routeName: (context) => AddPartyScreen(),
        PartyScreen.routeName: (context) => PartyScreen(),
        MyHomePage.routeName: (context) => MyHomePage(),
      },
      home: initializeApp.when(
        data: (_) => authStateChanges.when(
          data: (user) => user != null ? MyHomePage() : AuthScreen(),
          loading: () => LoadingScreen(),
          error: (e, s) => ErrorScreen(e: e, s: s),
        ),
        loading: () => LoadingScreen(),
        error: (e, s) => ErrorScreen(e: e, s: s),
      ),
    );
  }
}

class MyHomePage extends HookWidget {
  static const routeName = '/my-home-page';
  @override
  Widget build(BuildContext context) {
    const List<Widget> pages = [
      ProfileScreen(),
      MessagesScreen(),
      MapScreen(),
      SettingsScreen(),
    ];
    final pageIndex = useProvider(pageIndexProvider);
    return Scaffold(
      backgroundColor: babyWhite,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: BottomNavigationBar(
          onTap: (i) {
            context.read(pageIndexProvider).state = i;
          },
          currentIndex: pageIndex.state,
          selectedItemColor: blue,
          unselectedItemColor: grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 28,
          backgroundColor: babyWhite,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bubble_left_bubble_right),
              label: 'messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.location),
              label: 'parties',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.gear),
              label: 'settings',
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: pages.elementAt(pageIndex.state),
          ),
          Positioned(
            bottom: 0,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Container(
                height: 10,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: babyWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
