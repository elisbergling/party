import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:party/constants/colors.dart';
import 'package:party/providers/auth_provider.dart';
import 'package:party/providers/provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/screens/auth/auth_screen.dart';
import 'package:party/screens/home/map_screen.dart';
import 'package:party/screens/home/message_screen.dart';
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
      },
      home: initializeApp.when(
        data: (_) => authStateChanges.when(
          data: (user) => user != null ? MyHomePage() : AuthScreen(),
          loading: () => LoadingScreen(),
          error: (e, s) => ErrorScreen(
            e: e,
            s: s,
          ),
        ),
        loading: () => LoadingScreen(),
        error: (e, s) => ErrorScreen(
          e: e,
          s: s,
        ),
      ),
    );
  }
}

class MyHomePage extends HookWidget {
  void changePage(
    int i,
    BuildContext context,
    PageController pageController,
  ) {
    context.read(pageIndexProvider).state = 1;
    pageController.animateToPage(i,
        duration: Duration(milliseconds: 800), curve: Curves.easeIn);
  }

  Padding buildButton(
    BuildContext context,
    PageController pageController,
    int index,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
          icon: Icon(icon),
          onPressed: () => changePage(index, context, pageController)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageController = useProvider(pageControllerProvider);
    final auth = useProvider(authProvider);
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 100,
            color: Theme.of(context).primaryColorLight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildButton(context, pageController, 0, Icons.person),
                  buildButton(context, pageController, 1, Icons.message),
                  buildButton(context, pageController, 2, Icons.map),
                  buildButton(context, pageController, 3, Icons.settings),
                  Expanded(child: Container()),
                  auth.isLoading
                      ? CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.logout),
                            onPressed: () =>
                                context.read(authProvider).logOut(),
                          ),
                        ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: PageView(
                controller: pageController,
                children: [
                  UserScreen(),
                  MessageScreen(),
                  MapScreen(),
                  SettingsScreen(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
