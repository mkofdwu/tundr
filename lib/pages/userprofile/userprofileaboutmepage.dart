import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/themenotifier.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/pages/userprofile/userprofileextramediapage.dart';
import 'package:tundr/pages/userprofile/userprofilepersonalinfo.dart';
import 'package:tundr/utils/constants/enums/apptheme.dart';
import 'package:tundr/widgets/buttons/tileiconbutton.dart';
import 'package:tundr/widgets/nextpagearrow.dart';

class UserProfileAboutMePage extends StatelessWidget {
  final User user;

  UserProfileAboutMePage({Key key, @required this.user}) : super(key: key);

  bool _hasInfoLeft(User user) =>
      user.extraMedia.any((media) => media != null) ||
      user.interests.isNotEmpty ||
      user.personalInfo.isNotEmpty;

  _nextPage(BuildContext context) {
    Widget page;
    if (user.extraMedia.any((media) => media != null))
      page = UserProfileExtraMediaPage(user: user);
    else if (user.interests.isNotEmpty || user.personalInfo.isNotEmpty)
      page = UserProfilePersonalInfoPage(user: user);
    else
      throw Exception("No more pages left");

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionsBuilder: (context, animation1, animation2, child) {
          return SlideTransition(
            position:
                Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                    .animate(animation1),
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
          color: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  TileIconButton(
                    icon: Icons.close,
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        (route) => route.settings.name == "userprofile",
                      );
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 100.0),
                    child: Text(
                      user.aboutMe,
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                ] +
                (_hasInfoLeft(user)
                    ? [
                        Spacer(),
                        Center(
                          child: NextPageArrow(
                            dark: Provider.of<ThemeNotifier>(context).theme ==
                                AppTheme.dark,
                            onNextPage: () => _nextPage(context),
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ]
                    : []),
          ),
        ),
      ),
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dy < -1.0 && _hasInfoLeft(user))
          _nextPage(context);
        else if (details.delta.dy > 1.0) Navigator.pop(context);
      },
    );
  }
}
