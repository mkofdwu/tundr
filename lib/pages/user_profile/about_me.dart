import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/theme_notifier.dart';

import 'package:tundr/pages/user_profile/extra_media.dart';
import 'package:tundr/pages/user_profile/personal_info.dart';
import 'package:tundr/enums/app_theme.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class UserProfileAboutMePage extends StatelessWidget {
  final UserProfile profile;

  UserProfileAboutMePage({Key key, @required this.profile}) : super(key: key);

  bool _hasInfoLeft(UserProfile profile) =>
      profile.extraMedia.any((media) => media != null) ||
      profile.interests.isNotEmpty ||
      profile.personalInfo.isNotEmpty;

  void _nextPage(BuildContext context) {
    Widget page;
    if (profile.extraMedia.any((media) => media != null)) {
      page = UserProfileExtraMediaPage(profile: profile);
    } else if (profile.interests.isNotEmpty ||
        profile.personalInfo.isNotEmpty) {
      page = UserProfilePersonalInfoPage(profile: profile);
    } else {
      throw Exception('No more pages left');
    }

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
                        (route) => route.settings.name == '/user_profile',
                      );
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 100.0),
                    child: Text(
                      profile.aboutMe,
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                ] +
                (_hasInfoLeft(profile)
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
        if (details.delta.dy < -1.0 && _hasInfoLeft(profile)) {
          _nextPage(context);
        } else if (details.delta.dy > 1.0) Navigator.pop(context);
      },
    );
  }
}
