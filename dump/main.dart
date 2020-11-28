// @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<User>(create: (context) => User()),
//         Provider<RegistrationInfo>(create: (context) => RegistrationInfo()),
//         Provider<ThemeNotifier>(create: (context) => ThemeNotifier()),
//       ],
//       child: FutureBuilder(
//         future: Firebase.initializeApp(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return LoadingPage();
//           }
//           return StreamBuilder<auth.User>(
//             stream: AuthService.currentUserStream(),
//             builder: (context, snapshot) {
//               Widget home;

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 home = LoadingPage();
//               } else if (snapshot.data?.uid == null) {
//                 home = WelcomePage();
//               } else if (Provider.of<RegistrationInfo>(context)
//                   .isCreatingAccount) {
//                 home = LoadingPage(label: 'Setting up your account...');
//               } else {
//                 home = FutureBuilder<User>(
//                   future: UsersService.getUserRepo(snapshot.data.uid),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return LoadingPage();
//                     }

//                     final currentUser = snapshot.data;
//                     Provider.of<User>(context, listen: false).profile = currentUser.profile;
//                     Provider.of<User>(context, listen: false).privateInfo =
//                         currentUser.privateInfo;
//                     Provider.of<User>(context, listen: false).algorithmData =
//                         currentUser.algorithmData;

//                     if (currentUser.privateInfo.theme == null) {
//                       return SetupThemePage();
//                     } else {
//                       Provider.of<ThemeNotifier>(context, listen: false).theme =
//                           currentUser.privateInfo.theme;
//                       return AppStateHandler(
//                         onExit: () {
//                           Provider.of<User>(context, listen: false).updateOnline(false);
//                         },
//                         onStart: () {
//                           Provider.of<User>(context, listen: false).updateOnline(true);
//                         },
//                         child: NotificationHandler(
//                           child: HomePage(),
//                         ),
//                       );
//                     }
//                   },
//                 );
//               }

//               return Consumer<ThemeNotifier>(
//                 builder: (context, themeNotifier, child) {
//                   return MaterialApp(
//                     title: 'tundr',
//                     theme: _getLightTheme(),
//                     darkTheme: _getDarkTheme(),
//                     themeMode: themeNotifier.theme == ThemeMode.dark
//                         ? ThemeMode.dark
//                         : ThemeMode.light,
//                     debugShowCheckedModeBanner: false,
//                     home: home,
//                     routes: {
//                       '/user_profile': (context) => OtherProfileMainPage(),
//                     },
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
