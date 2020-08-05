import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/provider-data.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/widgets/buttons/tile-icon.dart';
import 'package:tundr/pages/interests/widgets/interests-browser.dart';

class InterestsEditPage extends StatelessWidget {
  _return(BuildContext context) {
    DatabaseService.setUserField(
      Provider.of<ProviderData>(context).user.uid,
      "interests",
      Provider.of<ProviderData>(context).user.interests +
          Provider.of<ProviderData>(context).user.customInterests,
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
                    "Edit interests",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: InterestsBrowser(
                    interests:
                        Provider.of<ProviderData>(context).user.interests,
                    customInterests:
                        Provider.of<ProviderData>(context).user.customInterests,
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
