import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/services/database_service.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'widgets/switch_setting_field.dart';

class NotificationSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context).user;
    return Scaffold(
      // FUTURE: DESIGN: make this nicer
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification settings',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            SwitchSettingField(
              title: 'New matches',
              description: "Be notified when you're matched with someone",
              selected: user.newMatchNotification,
              onChanged: (value) {
                DatabaseService.setUserField(
                  user.uid,
                  'newMatchNotification',
                  value,
                );
              },
            ),
            SizedBox(height: 10.0),
            SwitchSettingField(
              title: 'Messages',
              description: 'Be notified when someone sends you a message',
              selected: user.messageNotification,
              onChanged: (value) {
                DatabaseService.setUserField(
                  user.uid,
                  'messageNotification',
                  value,
                );
                Provider.of<CurrentUser>(context).user.newMatchNotification =
                    value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
