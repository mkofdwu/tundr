import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:tundr/pages/verification/recaptchaverificationpage.dart';
import 'package:tundr/pages/registration/setupaboutmepage.dart';
import 'package:tundr/pages/registration/setupextramediapage.dart';
import 'package:tundr/pages/registration/setupinterestspage.dart';
import 'package:tundr/pages/registration/setuppersonalinfopage.dart';
import 'package:tundr/pages/registration/setupphonenumberpage.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/widgets/buttons/lighttilebutton.dart';
import 'package:tundr/widgets/nextpagearrow.dart';

class SetupExtraInfoPage extends StatefulWidget {
  @override
  _SetupExtraInfoPageState createState() => _SetupExtraInfoPageState();
}

class _SetupExtraInfoPageState extends State<SetupExtraInfoPage> {
  _setupAboutMe() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetupAboutMePage()),
        // PageRouteBuilder(
        //   pageBuilder: (context, animation1, animation2) => SetupInterestsPage(),
        //   transitionsBuilder: (context, animation1, animation2) {
        //
        //   }
        // ),
      );

  _setupExtraMedia() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetupExtraMediaPage()),
      );

  _setupPersonalInfo() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetupPersonalInfoPage()),
      );

  _setupInterests() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetupInterestsPage()),
      );

  _nextPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            kIsWeb ? RecaptchaVerificationPage() : SetupPhoneNumberPage(),
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
    return GestureDetector(
      child: SafeArea(
        child: Material(
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Setup extra\ninfo?",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 40.0,
                    fontFamily: "Helvetica Neue",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  "You can skip these steps, but they will probably\nincrease your chances of finding a match.",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 50.0),
                LightTileButton(
                  // FUTURE: change colour if setup done
                  child: Text(
                    "About me",
                    style: TextStyle(color: AppColors.black, fontSize: 20.0),
                  ),
                  onTap: _setupAboutMe,
                ),
                LightTileButton(
                  child: Text(
                    "Extra photos & videos",
                    style: TextStyle(color: AppColors.black, fontSize: 20.0),
                  ),
                  onTap: _setupExtraMedia,
                ),
                LightTileButton(
                  child: Text(
                    "Personal info",
                    style: TextStyle(color: AppColors.black, fontSize: 20.0),
                  ),
                  onTap: _setupPersonalInfo,
                ),
                LightTileButton(
                  child: Text(
                    "Interests",
                    style: TextStyle(color: AppColors.black, fontSize: 20.0),
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
        ),
      ),
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dy < -1.0)
          _nextPage();
        else if (details.delta.dy > 1.0) Navigator.pop(context);
      },
    );
  }
}
