import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/pages/profile/utils/find_next_route.dart';
import 'package:tundr/store/theme_manager.dart';

import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class HomeworkProfilePage extends StatelessWidget {
  void _nextPage(context, profile) {
    Navigator.pushNamed(
      context,
      findNextRoute('/profile/homework', profile),
      arguments: profile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ModalRoute.of(context).settings.arguments as UserProfile;
    return ScrollDownPage(
      builder: (context, width, height) => Padding(
        padding: const EdgeInsets.only(left: 30, top: 40, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Transform.translate(
                  offset: Offset(-15, 0),
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
                SizedBox(height: 40),
                Text(
                  profile.name + "'s",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.6),
                  ),
                ),
                Text(
                  'Homework',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 30),
                Text(
                  profile.homework.join('\n'),
                  style: TextStyle(fontSize: 16, height: 1.6),
                ),
              ] +
              (findNextRoute('/profile/homework', profile) != null
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
      ),
      onScrollDown: () => _nextPage(context, profile),
    );
  }
}
