import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/repositories/theme_manager.dart';
import 'package:tundr/pages/about.dart';
import 'package:tundr/pages/personal_info/text_field.dart';
import 'package:tundr/pages/settings/blocked_users.dart';
import 'package:tundr/pages/settings/change_password.dart';
import 'package:tundr/pages/settings/confirm_delete_account.dart';
import 'package:tundr/pages/settings/filter_settings.dart';
import 'package:tundr/pages/settings/notification_settings.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/gender.dart';
import 'package:tundr/services/notifications_service.dart';
import 'package:tundr/widgets/buttons/light_tile.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/checkboxes/simple.dart';
import 'package:tundr/widgets/radio_groups/round.dart';
import 'package:tundr/widgets/sliders/simple_range.dart';
import 'widgets/separate_page_setting_field.dart';
import 'widgets/setting_field.dart';
import 'widgets/switch_setting_field.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _changeUsername(String uid, String username) async {
    final newUsername = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TextFieldPage(
          field: PersonalInfoField(
            name: 'Username',
            prompt: 'Enter a new username',
          ),
          value: username,
        ),
      ),
    );
    await Provider.of<User>(context, listen: false)
        .updateProfile({'username': newUsername});
  }

  void _changePassword() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangePasswordPage()),
      );

  void _openFilterSettings() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FilterSettingsPage()),
      );

  void _openBlockedUsers() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BlockedUsersPage()),
      );

  void _openNotificationSettings() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationSettingsPage()),
      );

  void _openAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AboutPage()), // DESIGN: transitions
    );
  }

  void _confirmLogout() async {
    final signOut = await showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Are you sure you would like to logout?'),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context, true),
          ),
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
    if (signOut) {
      // unsubscribe from notifications for this user
      await NotificationsService.removeToken(
        Provider.of<User>(context, listen: false).profile.uid,
        Provider.of<User>(context, listen: false).fcmToken,
      );
      await FirebaseMessaging().deleteInstanceID();
      await auth.FirebaseAuth.instance.signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void _confirmDeleteAccount() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmDeleteAccountPage()),
      );

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<User>(context, listen: false).profile;
    final privateInfo = Provider.of<User>(context, listen: false).privateInfo;
    final settings = privateInfo.settings;
    final algorithmData =
        Provider.of<User>(context, listen: false).algorithmData;
    final uid = profile.uid;
    return Scaffold(
      appBar: AppBar(
        leading: TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              SettingField(
                title: 'Username',
                child: Text(
                  profile.username,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onEdit: () => _changeUsername(uid, profile.username),
              ),
              SizedBox(height: 20),
              SeparatePageSettingField(
                title: 'Change password',
                onNextPage: _changePassword,
              ),
              SizedBox(height: 20),
              SettingField(
                title: 'Phone number',
                child: Text(
                  privateInfo.phoneNumber,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SettingField(
                title: 'Gender',
                child: RoundRadioGroup(
                  options: ['Male', 'Female'],
                  selected: Gender.values.indexOf(profile.gender),
                  onChanged: (option) =>
                      Provider.of<User>(context, listen: false)
                          .updateProfile({'gender': option}),
                ),
              ),
              SizedBox(height: 20),
              SettingField(
                title: 'Show me',
                child: Column(
                  children: <Widget>[
                    SimpleCheckbox(
                      text: 'Boys',
                      value: algorithmData.showMeBoys,
                      onChanged: (bool value) =>
                          Provider.of<User>(context, listen: false)
                              .updateAlgorithmData({'showMeBoys': value}),
                    ),
                    SizedBox(height: 10),
                    SimpleCheckbox(
                      text: 'Girls',
                      value: algorithmData.showMeGirls,
                      onChanged: (bool value) =>
                          Provider.of<User>(context, listen: false)
                              .updateAlgorithmData({'showMeGirls': value}),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SettingField(
                title: 'Age range',
                child: SimpleRangeSlider(
                  min: 13,
                  max: 50,
                  defaultRange: RangeValues(
                    algorithmData.ageRangeMin.toDouble(),
                    algorithmData.ageRangeMax.toDouble(),
                  ),
                  onChanged: (newRangeValues) {
                    Provider.of<User>(context, listen: false)
                        .updateAlgorithmData({
                      'ageRangeMin': newRangeValues.start.toInt(),
                      'ageRangeMax': newRangeValues.end.toInt(),
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              SeparatePageSettingField(
                title: 'Filters',
                onNextPage: _openFilterSettings,
              ),
              SizedBox(height: 20),
              SeparatePageSettingField(
                title: 'Blocked users',
                onNextPage: _openBlockedUsers,
              ),
              SizedBox(height: 20),
              SwitchSettingField(
                title: 'Sleep',
                description:
                    "While sleeping, you won't appear in other users' card stacks or get new suggestions",
                selected: algorithmData.asleep,
                onChanged: (value) => Provider.of<User>(context, listen: false)
                    .updateAlgorithmData({'asleep': value}),
              ),
              SizedBox(height: 20),
              SwitchSettingField(
                title: 'Show in most popular',
                description:
                    'Turning this on allows you to be shown on the most popular board',
                selected: settings.showInMostPopular,
                onChanged: (value) {
                  settings.showInMostPopular = value;
                  Provider.of<User>(context, listen: false)
                      .writeField('settings', UserPrivateInfo);
                },
              ),
              SizedBox(height: 20),
              SwitchSettingField(
                title: 'Block unknown messages',
                description:
                    'Prevent users you were not matched with from sending you messages',
                selected: settings.blockUnknownMessages,
                onChanged: (value) {
                  settings.blockUnknownMessages = value;
                  Provider.of<User>(context, listen: false)
                      .writeField('settings', UserPrivateInfo);
                },
              ),
              SizedBox(height: 20),
              SeparatePageSettingField(
                title: 'Notifications',
                onNextPage: _openNotificationSettings,
              ),
              SizedBox(height: 20),
              SettingField(
                title: 'Theme',
                child: RoundRadioGroup(
                  options: ['Dark', 'Light'],
                  selected:
                      Provider.of<ThemeManager>(context).theme == ThemeMode.dark
                          ? 0
                          : 1,
                  onChanged: (option) {
                    Provider.of<ThemeManager>(context, listen: false).theme =
                        option == 0 ? ThemeMode.dark : ThemeMode.light;
                    setState(() {});
                    Provider.of<User>(context, listen: false)
                        .updatePrivateInfo({'theme': option});
                  },
                ),
              ),
              SizedBox(height: 20),
              SwitchSettingField(
                title: 'Read receipts',
                description:
                    "If turned off, you won't send or receive read receipts",
                selected: settings.readReceipts,
                onChanged: (value) {
                  settings.readReceipts = value;
                  Provider.of<User>(context, listen: false)
                      .writeField('settings', UserPrivateInfo);
                },
              ),
              SizedBox(height: 20),
              Provider.of<ThemeManager>(context).theme == ThemeMode.dark
                  ? GestureDetector(
                      // FUTURE: make this work for other themes, refractor to darktilebutton
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        padding: EdgeInsets.all(20),
                        color: MyPalette.gold,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'About tundr',
                              style: TextStyle(
                                color: MyPalette.black,
                                fontSize: 24,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: MyPalette.black, size: 24),
                          ],
                        ),
                      ),
                      onTap: _openAbout,
                    )
                  : LightTileButton(
                      color: MyPalette.gold,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'About tundr',
                            style: TextStyle(
                              color: MyPalette.white,
                              fontSize: 24,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: MyPalette.white,
                            size: 24,
                          ),
                        ],
                      ),
                      onTap: _openAbout,
                    ),
              SizedBox(height: 20),
              FlatButton(
                // FUTURE: replace with flatdarktilebutton
                key: ValueKey('logoutBtn'),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: MyPalette.red,
                          fontSize: 20,
                        ),
                      ),
                      Icon(Icons.power_settings_new, color: MyPalette.red),
                    ],
                  ),
                ),
                onPressed: _confirmLogout,
              ),
              FlatButton(
                key: ValueKey('deleteAccountBtn'),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Delete account',
                        style: TextStyle(
                          color: MyPalette.red,
                          fontSize: 20,
                        ),
                      ),
                      Icon(Icons.delete, color: MyPalette.red),
                    ],
                  ),
                ),
                onPressed: _confirmDeleteAccount,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
