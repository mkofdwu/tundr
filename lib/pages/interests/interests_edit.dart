import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/user.dart';

import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/pages/interests/widgets/interests_browser.dart';

class InterestsEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                TileIconButton(
                  icon: Icons.arrow_back,
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 10.0),
                Text(
                  'Edit interests',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: InterestsBrowser(
                  interests: Provider.of<User>(context).profile.interests,
                  customInterests:
                      Provider.of<User>(context).profile.customInterests,
                  onInterestsChanged: (newInterests) {
                    Provider.of<User>(context)
                        .updateProfile({'interests': newInterests});
                  },
                  onCustomInterestsChanged: (newCustomInterests) {
                    Provider.of<User>(context)
                        .updateProfile({'customInterests': newCustomInterests});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
