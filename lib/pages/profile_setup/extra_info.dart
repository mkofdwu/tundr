import 'package:flutter/material.dart';
import 'package:tundr/pages/profile_setup/about_me.dart';
import 'package:tundr/pages/profile_setup/extra_media.dart';
import 'package:tundr/pages/profile_setup/interests.dart';
import 'package:tundr/pages/profile_setup/personal_info.dart';
import 'package:tundr/pages/profile_setup/phone_number.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/light_tile.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class SetupExtraInfoPage extends StatefulWidget {
  @override
  _SetupExtraInfoPageState createState() => _SetupExtraInfoPageState();
}

class _SetupExtraInfoPageState extends State<SetupExtraInfoPage> {
  void _setupAboutMe() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetupAboutMePage()),
        // PageRouteBuilder(
        //   pageBuilder: (context, animation1, animation2) => SetupInterestsPage(),
        //   transitionsBuilder: (context, animation1, animation2) {
        //
        //   }
        // ),
      );

  void _setupExtraMedia() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetupExtraMediaPage()),
      );

  void _setupPersonalInfo() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetupPersonalInfoPage()),
      );

  void _setupInterests() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetupInterestsPage()),
      );

  void _nextPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            SetupPhoneNumberPage(),
        transitionsBuilder: (context, animation1, animation2, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.0, 1.0),
              end: Offset(0.0, 0.0),
            ).animate(animation1),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDownPage(
      color: MyPalette.white,
      builder: (context, width, height) => Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Setup extra\ninfo?',
              style: TextStyle(
                color: MyPalette.black,
                fontSize: 40.0,
                fontFamily: 'Helvetica Neue',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'You can skip these steps, but they will probably\nincrease your chances of finding a match.',
              style: TextStyle(
                color: MyPalette.black,
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 50.0),
            LightTileButton(
              // FUTURE: change colour if setup done
              child: Text(
                'About me',
                style: TextStyle(color: MyPalette.black, fontSize: 20.0),
              ),
              onTap: _setupAboutMe,
            ),
            LightTileButton(
              child: Text(
                'Extra photos & videos',
                style: TextStyle(color: MyPalette.black, fontSize: 20.0),
              ),
              onTap: _setupExtraMedia,
            ),
            LightTileButton(
              child: Text(
                'Personal info',
                style: TextStyle(color: MyPalette.black, fontSize: 20.0),
              ),
              onTap: _setupPersonalInfo,
            ),
            LightTileButton(
              child: Text(
                'Interests',
                style: TextStyle(color: MyPalette.black, fontSize: 20.0),
              ),
              onTap: _setupInterests,
            ),
            Spacer(),
            Align(
              alignment: Alignment.center,
              child: NextPageArrow(
                dark: false,
                onNextPage: _nextPage,
              ),
            ),
          ],
        ),
      ),
      onScrollDown: _nextPage,
    );
  }
}
