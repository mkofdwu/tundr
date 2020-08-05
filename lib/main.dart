import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:tundr/repositories/current-user.dart';
import 'package:tundr/repositories/registration-info.dart';
import 'package:tundr/repositories/theme-notifier.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/pages/loading.dart';
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/profile-setup/theme.dart';
import 'package:tundr/pages/user-profile/main.dart';
import 'package:tundr/pages/welcome.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/enums/apptheme.dart';
import 'package:tundr/widgets/handlers/app-state-handler.dart';
import 'package:tundr/widgets/handlers/notification-handler.dart';

final Widget loadingApp = MaterialApp(
  theme: ThemeData(
    canvasColor: AppColors.black,
    accentColor: AppColors.white,
  ),
  home: LoadingPage(),
);

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
        child: App(),
      ));
    },
    (error, stackTrace) {
      print(error.runtimeType);
      runApp(
        MaterialApp(
          title: "error",
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

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentUser>(create: (context) => CurrentUser()),
        ChangeNotifierProvider<ThemeNotifier>(
            create: (context) => ThemeNotifier()),
        ChangeNotifierProvider<RegistrationInfo>(
            create: (context) => RegistrationInfo()),
      ],
      child: StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting for auth");
            return loadingApp;
          }

          final String uid = snapshot.data?.uid;
          if (uid == null)
            return MaterialApp(
              title: "tundr",
              theme: _getThemeData(AppTheme.dark),
              home: WelcomePage(),
            );

          return FutureBuilder<User>(
            future: DatabaseService.getUser(uid, returnDeletedUser: false),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                print("waiting for user");
                return loadingApp;
              }

              final user = snapshot.data;

              Provider.of<CurrentUser>(context).user = user;
              Provider.of<ThemeNotifier>(context).theme =
                  user.theme ?? AppTheme.dark;

              return MaterialApp(
                title: "tundr",
                theme: _getThemeData(Provider.of<ThemeNotifier>(context).theme),
                home: user.theme == null
                    ? SetupThemePage()
                    : AppStateHandler(
                        child: NotificationHandler(
                          child: HomePage(),
                        ),
                        onExit: () {
                          print("went offline");
                          final User user =
                              Provider.of<CurrentUser>(context).user;
                          DatabaseService.setUserFields(
                            Provider.of<CurrentUser>(context).user.uid,
                            {
                              "online": false,
                              "lastSeen": Timestamp.now(),
                              "totalWordsSent": user.totalWordsSent,
                            },
                          );
                        },
                        onStart: () {
                          print("back online");
                          DatabaseService.setUserField(
                            Provider.of<CurrentUser>(context).user.uid,
                            "online",
                            true,
                          );
                        },
                      ),
                routes: {
                  "userprofile": (context) => UserProfileMainPage(),
                },
              );
            },
          );
        },
      ),
    );
  }

  ThemeData _getThemeData(AppTheme theme) {
    Color primaryColor;
    Color accentColor;
    Color dialogBackgroundColor;
    switch (theme) {
      case AppTheme.light:
        primaryColor = AppColors.white;
        accentColor = AppColors.black;
        dialogBackgroundColor = AppColors.white;
        break;
      case AppTheme.dark:
        primaryColor = AppColors.black;
        accentColor = AppColors.white;
        dialogBackgroundColor = Color.fromARGB(255, 30, 30, 30);
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
          fontFamily: "Helvetica Neue",
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
      fontFamily: ".AppleSystemUIFont",
      cursorColor: accentColor,
    );
  }
}
