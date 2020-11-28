import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/repositories/theme_manager.dart';
import 'package:tundr/pages/loading.dart';
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/setup/theme.dart';
import 'package:tundr/pages/other_profile/main.dart';
import 'package:tundr/pages/welcome.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/services/auth_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/widgets/handlers/app_state_handler.dart';
import 'package:tundr/widgets/handlers/notification_handler.dart';

void main() {
  // runZonedGuarded<Future<void>>(
  //   () async {
  runApp(MultiProvider(
    providers: [
      Provider<User>(create: (context) => User()),
      Provider<RegistrationInfo>(create: (context) => RegistrationInfo()),
      ChangeNotifierProvider<ThemeManager>(create: (context) => ThemeManager()),
    ],
    child: TundrApp(),
  ));
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
  bool _loadingUser = true;

  Future<void> _loadUser() async {
    await Firebase.initializeApp();
    AuthService.currentUserStream().listen((firebaseUser) async {
      setState(() => _loadingUser = true);
      if (firebaseUser == null) {
        setState(() => _loadingUser = false);
        return;
      }
      if (Provider.of<RegistrationInfo>(context, listen: false)
          .isCreatingAccount) {
        // still loading user
        return;
      }
      final user = await UsersService.getUserRepo(firebaseUser.uid);
      Provider.of<User>(context, listen: false).profile = user.profile;
      Provider.of<User>(context, listen: false).privateInfo = user.privateInfo;
      Provider.of<User>(context, listen: false).algorithmData =
          user.algorithmData;
      if (user.privateInfo.theme == null) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SetupThemePage()),
        );
      } else {
        Provider.of<ThemeManager>(context, listen: false).theme =
            user.privateInfo.theme;
      }
      setState(() => _loadingUser = false);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _loadUser());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        Widget home;

        if (_loadingUser) {
          home = LoadingPage();
        } else if (user.profile == null ||
            user.privateInfo == null ||
            user.algorithmData == null) {
          home = WelcomePage();
        } else {
          home = AppStateHandler(
            onExit: () {
              Provider.of<User>(context, listen: false).updateOnline(false);
            },
            onStart: () {
              Provider.of<User>(context, listen: false).updateOnline(true);
            },
            child: NotificationHandler(
              child: HomePage(),
            ),
          );
        }

        return Consumer<ThemeManager>(
          builder: (context, themeNotifier, child) {
            return FeatureDiscovery(
              child: MaterialApp(
                title: 'tundr',
                theme: _lightTheme,
                darkTheme: _darkTheme,
                themeMode: themeNotifier.theme,
                debugShowCheckedModeBanner: false,
                home: home,
                routes: {
                  '/user_profile': (context) => OtherProfileMainPage(),
                },
              ),
            );
          },
        );
      },
    );
  }

  final _darkTheme = ThemeData(
    canvasColor: MyPalette.black,
    primaryColor: MyPalette.black,
    colorScheme: ColorScheme(
      primary: MyPalette.black,
      primaryVariant: MyPalette.black,
      secondary: MyPalette.green,
      secondaryVariant: MyPalette.green,
      surface: MyPalette.black,
      background: MyPalette.black,
      error: MyPalette.red,
      onPrimary: MyPalette.white,
      onSecondary: MyPalette.white,
      onSurface: MyPalette.white,
      onBackground: MyPalette.white,
      onError: MyPalette.white,
      brightness: Brightness.dark,
    ),
    accentColor: MyPalette.gold,
    fontFamily: '.AppleSystemUIFont',
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: MyPalette.white,
    ),
    iconTheme: IconThemeData(
      color: MyPalette.white,
    ),
  );

  final _lightTheme = ThemeData(
    canvasColor: MyPalette.white,
    primaryColor: MyPalette.white,
    colorScheme: ColorScheme(
      primary: MyPalette.white,
      primaryVariant: MyPalette.white,
      secondary: MyPalette.green,
      secondaryVariant: MyPalette.green,
      surface: MyPalette.white,
      background: MyPalette.white,
      error: MyPalette.red,
      onPrimary: MyPalette.black,
      onSecondary: MyPalette.white,
      onSurface: MyPalette.black,
      onBackground: MyPalette.black,
      onError: MyPalette.white,
      brightness: Brightness.light,
    ),
    accentColor: MyPalette.gold,
    fontFamily: '.AppleSystemUIFont',
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: MyPalette.black,
    ),
    iconTheme: IconThemeData(
      color: MyPalette.black,
    ),
    accentIconTheme: IconThemeData(
      color: MyPalette.black,
    ),
    primaryIconTheme: IconThemeData(
      color: MyPalette.black,
    ),
  );

  // ThemeData _getThemeData(ThemeMode theme) {
  //   Color primaryColor;
  //   Color textColor;
  //   Color dialogBackgroundColor;
  //   switch (theme) {
  //     case ThemeMode.light:
  //       primaryColor = MyPalette.white;
  //       textColor = MyPalette.black;
  //       dialogBackgroundColor = MyPalette.white;
  //       break;
  //     case ThemeMode.dark:
  //       primaryColor = MyPalette.black;
  //       textColor = MyPalette.white;
  //       dialogBackgroundColor = const Color.fromARGB(255, 30, 30, 30);
  //       break;
  //     default:
  //       throw 'invalid theme: ' + theme.toString();
  //   }
  //   return ThemeData(
  //     canvasColor: primaryColor,
  //     primaryColor: primaryColor,
  //     colorScheme: ColorScheme(
  //       surface: primaryColor,
  //     ),
  //     dialogBackgroundColor: dialogBackgroundColor,
  //     accentColor: MyPalette.gold,
  //     dialogTheme: DialogTheme(
  //       contentTextStyle: TextStyle(color: textColor),
  //     ),
  //     textTheme: TextTheme(
  //       headline3: TextStyle(
  //         color: textColor,
  //         fontSize: 40.0,
  //         fontFamily: 'Helvetica Neue',
  //         fontWeight: FontWeight.bold,
  //       ),
  //       headline5: TextStyle(color: textColor),
  //       headline6: TextStyle(
  //         color: textColor,
  //         fontSize: 20.0,
  //       ),
  //       bodyText2: TextStyle(
  //         color: textColor,
  //         fontSize: 14.0,
  //       ),
  //       bodyText1: TextStyle(color: textColor),
  //       subtitle1: TextStyle(color: textColor),
  //       subtitle2: TextStyle(color: textColor),
  //       caption: TextStyle(color: textColor.withOpacity(0.7)),
  //     ),
  //     fontFamily: '.AppleSystemUIFont',
  //     textSelectionTheme: TextSelectionThemeData(
  //       cursorColor: textColor,
  //     ),
  //     cardColor: primaryColor,
  //   );
  // }
}
