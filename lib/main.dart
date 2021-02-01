import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/pages/about.dart';
import 'package:tundr/pages/edit_profile.dart';
import 'package:tundr/pages/me.dart';
import 'package:tundr/pages/login.dart';
import 'package:tundr/pages/profile/about_me.dart';
import 'package:tundr/pages/profile/extra_media.dart';
import 'package:tundr/pages/profile/personal_info.dart';
import 'package:tundr/pages/register.dart';
import 'package:tundr/pages/search.dart';
import 'package:tundr/pages/settings/blocked_users.dart';
import 'package:tundr/pages/settings/change_password.dart';
import 'package:tundr/pages/settings/confirm_delete_account.dart';
import 'package:tundr/pages/settings/filters.dart';
import 'package:tundr/pages/settings/notifications.dart';
import 'package:tundr/pages/settings/main.dart';
import 'package:tundr/store/registration_info.dart';
import 'package:tundr/store/theme_manager.dart';
import 'package:tundr/pages/loading.dart';
import 'package:tundr/pages/home.dart';
import 'package:tundr/pages/setup/theme.dart';
import 'package:tundr/pages/profile/main.dart';
import 'package:tundr/pages/welcome.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/store/user.dart';
import 'package:tundr/services/auth_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/widgets/handlers/app_state_handler.dart';
import 'package:tundr/widgets/handlers/notification_handler.dart';
import 'package:tundr/widgets/rebuilder.dart';

void main() {
  runApp(Rebuilder(
    child: MultiProvider(
      providers: [
        Provider<User>(create: (context) => User()),
        Provider<RegistrationInfo>(create: (context) => RegistrationInfo()),
        ChangeNotifierProvider<ThemeManager>(
            create: (context) => ThemeManager()),
      ],
      child: TundrApp(),
    ),
  ));
}

class TundrApp extends StatefulWidget {
  @override
  _TundrAppState createState() => _TundrAppState();
}

class _TundrAppState extends State<TundrApp> {
  bool _isLoadingUser = true;
  String _loadingLabel;
  bool _setupTheme = false;

  Future<void> _loadUser() async {
    await Firebase.initializeApp();
    AuthService.currentUserStream().listen((firebaseUser) async {
      if (!mounted) return;
      setState(() => _isLoadingUser = true);
      if (firebaseUser == null) {
        setState(() => _isLoadingUser = false);
        return;
      }
      if (Provider.of<RegistrationInfo>(context, listen: false)
          .isCreatingAccount) {
        setState(() => _loadingLabel = 'Creating account');
      } else {
        final user = await UsersService.getUserRepo(firebaseUser.uid);
        Provider.of<User>(context, listen: false).profile = user.profile;
        Provider.of<User>(context, listen: false).privateInfo =
            user.privateInfo;
        Provider.of<User>(context, listen: false).algorithmData =
            user.algorithmData;
        if (user.privateInfo.theme == null) {
          setState(() => _setupTheme = true);
        } else {
          Provider.of<ThemeManager>(context, listen: false).theme =
              user.privateInfo.theme;
        }
        setState(() => _isLoadingUser = false);
      }
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

        if (_isLoadingUser) {
          home = LoadingPage(label: _loadingLabel);
        } else if (!user.loggedIn) {
          home = WelcomePage();
        } else if (_setupTheme) {
          home = SetupThemePage();
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
                  '/welcome': (context) => WelcomePage(),
                  '/login': (context) => LoginPage(),
                  '/register': (context) => RegisterPage(),
                  '/home': (context) => HomePage(),
                  '/me': (context) => MePage(),
                  '/search': (context) => SearchPage(),
                  '/edit_profile': (context) => EditProfilePage(),
                  '/profile': (context) => MainProfilePage(),
                  '/profile/about_me': (context) => AboutMeProfilePage(),
                  '/profile/extra_media': (context) => ExtraMediaProfilePage(),
                  '/profile/personal_info': (context) =>
                      PersonalInfoProfilePage(),
                  '/settings': (context) => MainSettingsPage(),
                  '/settings/filters': (context) => FiltersSettingsPage(),
                  '/settings/notifications': (context) =>
                      NotificationsSettingsPage(),
                  '/settings/change_password': (context) =>
                      ChangePasswordPage(),
                  '/settings/blocked_users': (context) => BlockedUsersPage(),
                  '/settings/confirm_delete_account': (context) =>
                      ConfirmDeleteAccountPage(),
                  '/about': (context) => AboutPage(),
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
    fontFamily: 'Liberation Sans',
    cursorColor: MyPalette.white,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: MyPalette.white,
    ),
    iconTheme: IconThemeData(
      color: MyPalette.white,
    ),
    dialogTheme: DialogTheme(
      contentTextStyle: TextStyle(color: MyPalette.white),
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
    fontFamily: 'Liberation Sans',
    cursorColor: MyPalette.black,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: MyPalette.black,
    ),
    iconTheme: IconThemeData(
      color: MyPalette.black,
    ),
    dialogTheme: DialogTheme(
      contentTextStyle: TextStyle(color: MyPalette.black),
    ),
  );
}
