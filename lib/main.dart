import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: MyColors.black, // navigation bar color
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChanges = ref.watch(authStateChangesProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Party',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.transparent,
        //colorScheme: ColorScheme(
        //  brightness: brightness,
        //  primary: primary,
        //  onPrimary: onPrimary,
        //  secondary: MyColors.blue,
        //  onSecondary: onSecondary,
        //  error: error,
        //  onError: onError,
        //  background: background,
        //  onBackground: onBackground,
        //  surface: surface,
        //  onSurface: onSurface,
        //),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: MyColors.blue),
        iconTheme: const IconThemeData(color: MyColors.white),
        inputDecorationTheme: const InputDecorationTheme(
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
        UserScreen.routeName: (context) => const UserScreen(),
        MapScreen.routeName: (context) => const MapScreen(),
        MessageScreen.routeName: (context) => const MessageScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        FriendScreen.routeName: (context) => const FriendScreen(),
        AddFriendScreen.routeName: (context) => const AddFriendScreen(),
        AddGroupScreen.routeName: (context) => const AddGroupScreen(),
        AddPartyScreen.routeName: (context) => const AddPartyScreen(),
        PartyScreen.routeName: (context) => const PartyScreen(),
        MyHomePage.routeName: (context) => const MyHomePage(),
      },
      home: authStateChanges.when(
        data: (user) => user != null ? const MyHomePage() : const AuthScreen(),
        loading: () => const LoadingScreen(),
        error: (e, s) => ErrorScreen(e: e, s: s),
      ),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  static const routeName = '/my-home-page';

  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const List<Widget> pages = [
      ProfileScreen(),
      MessagesScreen(),
      MapScreen(),
      SettingsScreen(),
    ];
    final pageIndex = ref.watch(pageIndexProvider);
    return Scaffold(
      backgroundColor: MyColors.black,
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: BottomNavigationBar(
            onTap: (i) {
              ref.read(pageIndexProvider.notifier).state = i;
            },
            currentIndex: pageIndex,
            selectedItemColor: MyColors.blue,
            unselectedItemColor: MyColors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 28,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: const [
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
      ),
      body: Center(
        child: pages.elementAt(pageIndex),
      ),
    );
  }
}
