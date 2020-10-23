import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/services/database_service.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/pages/interests/widgets/interests_browser.dart';

class InterestsEditPage extends StatelessWidget {
  void _return(BuildContext context) {
    DatabaseService.setUserField(
      Provider.of<CurrentUser>(context).user.uid,
      'interests',
      Provider.of<CurrentUser>(context).user.interests +
          Provider.of<CurrentUser>(context).user.customInterests,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _return(context);
        return Future(() => false);
      },
      child: SafeArea(
        child: Material(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  TileIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => _return(context),
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
                    interests: Provider.of<CurrentUser>(context).user.interests,
                    customInterests:
                        Provider.of<CurrentUser>(context).user.customInterests,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
