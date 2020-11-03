import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/repositories/theme_notifier.dart';
import 'package:tundr/pages/loading.dart';
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/profile_setup/theme.dart';
import 'package:tundr/pages/user_profile/main.dart';
import 'package:tundr/pages/welcome.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/app_theme.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/widgets/handlers/app_state_handler.dart';
import 'package:tundr/widgets/handlers/notification_handler.dart';

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider<CurrentUser>(
              create: (context) => CurrentUser()),
          ChangeNotifierProvider<ThemeNotifier>(
              create: (context) => ThemeNotifier()),
          ChangeNotifierProvider<RegistrationInfo>(
              create: (context) => RegistrationInfo()),
        ],
        child: TundrApp(),
      ));
    },
    (error, stackTrace) {
      runApp(
        MaterialApp(
          title: 'error',
          home: Material(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(error),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class TundrApp extends StatefulWidget {
  @override
  _TundrAppState createState() => _TundrAppState();
}

class _TundrAppState extends State<TundrApp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        Widget home;

        if (snapshot.connectionState == ConnectionState.waiting) {
          home = LoadingPage();
        } else if (snapshot.data?.uid == null) {
          home = WelcomePage();
        } else {
          home = FutureBuilder<CurrentUser>(
            future: UsersService.getCurrentUser(snapshot.data.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingPage();
              }

              final currentUser = snapshot.data;
              Provider.of<CurrentUser>(context).profile = currentUser.profile;
              Provider.of<CurrentUser>(context).privateInfo =
                  currentUser.privateInfo;
              Provider.of<CurrentUser>(context).algorithmData =
                  currentUser.algorithmData;

              if (currentUser.privateInfo.theme == null) {
                return SetupThemePage();
              } else {
                Provider.of<ThemeNotifier>(context).theme =
                    currentUser.privateInfo.theme;
                return AppStateHandler(
                  onExit: () {
                    UsersService.setOnline(
                        Provider.of<CurrentUser>(context).profile.uid, false);
                  },
                  onStart: () {
                    UsersService.setOnline(
                        Provider.of<CurrentUser>(context).profile.uid, true);
                  },
                  child: NotificationHandler(
                    child: HomePage(),
                  ),
                );
              }
            },
          );
        }

        return Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) {
            return MaterialApp(
              title: 'tundr',
              theme: _getThemeData(themeNotifier.theme),
              debugShowCheckedModeBanner: false,
              home: home,
              routes: {
                // TODO: test if this is still necessary, or if it is possible to just set an id variable directly on the page
                'userprofile': (context) => UserProfileMainPage(),
              },
            );
          },
        );
      },
    );
  }

  ThemeData _getThemeData(AppTheme theme) {
    Color primaryColor;
    Color accentColor;
    Color dialogBackgroundColor;
    switch (theme) {
      case AppTheme.light:
        primaryColor = MyPalette.white;
        accentColor = MyPalette.black;
        dialogBackgroundColor = MyPalette.white;
        break;
      case AppTheme.dark:
        primaryColor = MyPalette.black;
        accentColor = MyPalette.white;
        dialogBackgroundColor = const Color.fromARGB(255, 30, 30, 30);
        break;
    }
    return ThemeData(
      canvasColor: primaryColor,
      primaryColor: primaryColor,
      dialogBackgroundColor: dialogBackgroundColor,
      accentColor: accentColor,
      textTheme: TextTheme(
        headline3: TextStyle(
          color: accentColor,
          fontSize: 40.0,
          fontFamily: 'Helvetica Neue',
          fontWeight: FontWeight.bold,
        ),
        headline6: TextStyle(
          color: accentColor,
          fontSize: 20.0,
        ),
        bodyText2: TextStyle(
          color: accentColor,
          fontSize: 14.0,
        ),
      ),
      fontFamily: '.AppleSystemUIFont',
      cursorColor: accentColor,
    );
  }
}
