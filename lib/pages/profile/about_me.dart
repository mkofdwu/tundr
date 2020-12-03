import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/theme_manager.dart';

import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class AboutMeProfilePage extends StatelessWidget {
  bool _hasInfoLeft(profile) =>
      profile.extraMedia.any((media) => media != null) ||
      profile.interests.isNotEmpty ||
      profile.personalInfo.isNotEmpty;

  void _nextPage(context, profile) {
    String route;
    if (profile.extraMedia.any((media) => media != null)) {
      route = '/profile/extra_media';
    } else if (profile.interests.isNotEmpty ||
        profile.personalInfo.isNotEmpty) {
      route = '/profile/personal_info';
    } else {
      throw Exception('No more pages left');
    }

    Navigator.pushNamed(context, route, arguments: profile);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ModalRoute.of(context).settings.arguments as UserProfile;
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
                  profile.aboutMe,
                  style: TextStyle(fontSize: 30),
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
                        onNextPage: () => _nextPage(context, profile),
                      ),
                    ),
                    SizedBox(height: 20),
                  ]
                : []),
      ),
      onScrollDown: () => _nextPage(context, profile),
    );
  }
}
