import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:tundr/models/providerdata.dart';
import 'package:tundr/models/registrationinfo.dart';
import 'package:tundr/models/themenotifier.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/pages/loadingpage.dart';
import 'package:tundr/pages/main/homepage.dart';
import 'package:tundr/pages/registration/setupthemepage.dart';
import 'package:tundr/pages/userprofile/userprofilemainpage.dart';
import 'package:tundr/pages/welcomepage.dart';
import 'package:tundr/services/databaseservice.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/utils/constants/enums/apptheme.dart';
import 'package:tundr/utils/updateconversationalscore.dart';
import 'package:tundr/widgets/handlers/appstatehandler.dart';
import 'package:tundr/widgets/handlers/notificationhandler.dart';

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
          ChangeNotifierProvider<ProviderData>(
              create: (context) => ProviderData()),
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
    return StreamBuilder<FirebaseUser>(
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

        print("authenticated with user $uid");

        return FutureBuilder<User>(
          future: _getOrCreateUser(uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              print("waiting for user");
              return loadingApp;
            }

            final user = snapshot.data;

            Provider.of<ProviderData>(context).user = user;
            Provider.of<ThemeNotifier>(context).theme =
                user.theme ?? AppTheme.dark;

            updateConversationalScore(user);

            return MaterialApp(
              title: "tundr",
              theme: _themeDataFromProvider(),
              home: user.theme == null
                  ? SetupThemePage()
                  : AppStateHandler(
                      child: NotificationHandler(
                        child: HomePage(),
                      ),
                      onExit: () {
                        print("went offline");
                        final User user =
                            Provider.of<ProviderData>(context).user;
                        DatabaseService.setUserFields(
                          Provider.of<ProviderData>(context).user.uid,
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
                          Provider.of<ProviderData>(context).user.uid,
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

  ThemeData _themeDataFromProvider() {
    return _getThemeData(Provider.of<ThemeNotifier>(context).theme);
  }

  Future<User> _getOrCreateUser(String uid) async {
    User user = await DatabaseService.getUser(uid, returnDeletedUser: false);
    if (user == null) {
      // FIXME: FUTURE: find a better solution
      // the user is supposed to have just created an account
      print("user doesn't exist, creating account");
      assert(uid ==
          Provider.of<RegistrationInfo>(context)
              .uid); // TODO: or don't need to save uid in provider, just get uid from here
      await DatabaseService.createAccount(
          Provider.of<RegistrationInfo>(context));
      user = await DatabaseService.getUser(uid, returnDeletedUser: false);
      print("created user theme: ${user.theme}");
      assert(user != null);
    }
    return user;
  }
}
