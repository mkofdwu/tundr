import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/widgets/buttons/back.dart';

import 'package:tundr/pages/interests/widgets/interests_browser.dart';

class EditInterestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackButton(),
        title: Text(
          'Edit interests',
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: InterestsBrowser(
          interests:
              Provider.of<User>(context, listen: false).profile.interests,
          customInterests:
              Provider.of<User>(context, listen: false).profile.customInterests,
          onInterestsChanged: () {
            Provider.of<User>(context, listen: false)
                .writeField('interests', UserProfile);
          },
          onCustomInterestsChanged: () {
            Provider.of<User>(context, listen: false)
                .writeField('customInterests', UserProfile);
          },
        ),
      ),
    );
  }
}
