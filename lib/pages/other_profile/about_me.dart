import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/theme_manager.dart';

import 'package:tundr/pages/other_profile/extra_media.dart';
import 'package:tundr/pages/other_profile/personal_info.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class OtherProfileAboutMePage extends StatelessWidget {
  final UserProfile profile;

  OtherProfileAboutMePage({Key key, @required this.profile}) : super(key: key);

  bool _hasInfoLeft(UserProfile profile) =>
      profile.extraMedia.any((media) => media != null) ||
      profile.interests.isNotEmpty ||
      profile.personalInfo.isNotEmpty;

  void _nextPage(BuildContext context) {
    Widget page;
    if (profile.extraMedia.any((media) => media != null)) {
      page = OtherProfileExtraMediaPage(profile: profile);
    } else if (profile.interests.isNotEmpty ||
        profile.personalInfo.isNotEmpty) {
      page = OtherProfilePersonalInfoPage(profile: profile);
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
    return ScrollDownPage(
      builder: (context, width, height) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              SafeArea(
                child: TileIconButton(
                  icon: Icons.close,
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      (route) => route.settings.name == '/user_profile',
                    );
                    Navigator.pop(context);
                  },
                ),
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
                      child: ScrollDownArrow(
                        dark: Provider.of<ThemeManager>(context).theme ==
                            ThemeMode.dark,
                        onNextPage: () => _nextPage(context),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ]
                : []),
      ),
      onScrollDown: () => _nextPage(context),
    );
  }
}
