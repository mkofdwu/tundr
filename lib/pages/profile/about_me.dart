import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/pages/profile/utils/find_next_route.dart';
import 'package:tundr/store/theme_manager.dart';

import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class AboutMeProfilePage extends StatelessWidget {
  void _nextPage(context, profile) {
    Navigator.pushNamed(
      context,
      findNextRoute('/profile/about_me', profile),
      arguments: profile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final otherProfile =
        ModalRoute.of(context).settings.arguments as UserProfile;
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
                      (route) => route.settings.name == '/profile',
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 100),
                child: Text(
                  otherProfile.aboutMe,
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ] +
            (findNextRoute('/profile/about_me', otherProfile) != null
                ? [
                    Spacer(),
                    Center(
                      child: ScrollDownArrow(
                        dark: Provider.of<ThemeManager>(context).theme ==
                            ThemeMode.dark,
                        onNextPage: () => _nextPage(context, otherProfile),
                      ),
                    ),
                    SizedBox(height: 20),
                  ]
                : []),
      ),
      onScrollDown: () => _nextPage(context, otherProfile),
    );
  }
}
