import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/colors.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/provider.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final initializeApp = useProvider(initializeAppProvider);
    final authStateChanges = useProvider(authStateChangesProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: green,
        primaryColor: pink,
        primaryColorDark: purple,
        primaryColorLight: yellow,
        scaffoldBackgroundColor: green,
        buttonColor: pink,
        appBarTheme: AppBarTheme(
          color: purple,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(cursorColor: green),
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
  @override
  Widget build(BuildContext context) {
    const List<Widget> pages = [
      ProfileScreen(),
      MessagesScreen(),
      MapScreen(),
      SettingsScreen(),
    ];
    final pageController = useProvider(pageControllerProvider);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          //context.read(pageIndexProvider).state = 1;
          pageController.animateToPage(i,
              duration: Duration(milliseconds: 800), curve: Curves.easeIn);
        },
        backgroundColor: Colors.red,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'parties',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          )
        ],
      ),
      body: PageView(
        controller: pageController,
        //onPageChanged: (i) => context.read(pageIndexProvider).state = i,
        children: pages,
      ),
    );
  }
}
