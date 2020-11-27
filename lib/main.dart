import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/pages/creating_account.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/repositories/theme_notifier.dart';
import 'package:tundr/pages/loading.dart';
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/profile_setup/theme.dart';
import 'package:tundr/pages/user_profile/main.dart';
import 'package:tundr/pages/welcome.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/app_theme.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/services/auth_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/widgets/handlers/app_state_handler.dart';
import 'package:tundr/widgets/handlers/notification_handler.dart';

void main() {
  // runZonedGuarded<Future<void>>(
  //   () async {
  runApp(TundrApp());
  // },
  // (error, stackTrace) {
  //   runApp(
  //     MaterialApp(
  //       title: 'error',
  //       home: Material(
  //         child: Center(
  //           child: Padding(
  //             padding: const EdgeInsets.all(20.0),
  //             child: Text(error),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // },
  // );
}

class TundrApp extends StatefulWidget {
  @override
  _TundrAppState createState() => _TundrAppState();
}

class _TundrAppState extends State<TundrApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (context) => User()),
        ChangeNotifierProvider<ThemeNotifier>(
            create: (context) => ThemeNotifier()),
        ChangeNotifierProvider<RegistrationInfo>(
            create: (context) => RegistrationInfo()),
      ],
      child: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingPage();
          }
          return StreamBuilder<auth.User>(
            stream: AuthService.currentUserStream(),
            builder: (context, snapshot) {
              Widget home;

              if (snapshot.connectionState == ConnectionState.waiting) {
                home = LoadingPage();
              } else if (snapshot.data?.uid == null) {
                home = WelcomePage();
              } else if (Provider.of<RegistrationInfo>(context)
                  .isCreatingAccount) {
                home = CreatingAccountPage();
              } else {
                home = FutureBuilder<User>(
                  future: UsersService.getUserRepo(snapshot.data.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingPage();
                    }

                    final currentUser = snapshot.data;
                    Provider.of<User>(context).profile = currentUser.profile;
                    Provider.of<User>(context).privateInfo =
                        currentUser.privateInfo;
                    Provider.of<User>(context).algorithmData =
                        currentUser.algorithmData;

                    if (currentUser.privateInfo.theme == null) {
                      return SetupThemePage();
                    } else {
                      Provider.of<ThemeNotifier>(context).theme =
                          currentUser.privateInfo.theme;
                      return AppStateHandler(
                        onExit: () {
                          Provider.of<User>(context).updateOnline(false);
                        },
                        onStart: () {
                          Provider.of<User>(context).updateOnline(true);
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
                      '/user_profile': (context) => UserProfileMainPage(),
                    },
                  );
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
      dialogTheme: DialogTheme(
        contentTextStyle: TextStyle(color: accentColor),
      ),
      accentColor: accentColor,
      textTheme: TextTheme(
        headline3: TextStyle(
          color: accentColor,
          fontSize: 40.0,
          fontFamily: 'Helvetica Neue',
          fontWeight: FontWeight.bold,
        ),
        headline5: TextStyle(color: accentColor),
        headline6: TextStyle(
          color: accentColor,
          fontSize: 20.0,
        ),
        bodyText2: TextStyle(
          color: accentColor,
          fontSize: 14.0,
        ),
        bodyText1: TextStyle(color: accentColor),
        subtitle1: TextStyle(color: accentColor),
        subtitle2: TextStyle(color: accentColor),
        caption: TextStyle(color: accentColor.withOpacity(0.7)),
      ),
      fontFamily: '.AppleSystemUIFont',
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accentColor,
      ),
      cardColor: primaryColor,
    );
  }
}
