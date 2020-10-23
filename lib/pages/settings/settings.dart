import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/repositories/theme_notifier.dart';
import 'package:tundr/pages/about.dart';
import 'package:tundr/pages/personal_info/text_field.dart';
import 'package:tundr/pages/settings/blocked_users.dart';
import 'package:tundr/pages/settings/change_password.dart';
import 'package:tundr/pages/settings/confirm_delete_account.dart';
import 'package:tundr/pages/settings/filter_settings.dart';
import 'package:tundr/pages/settings/notification_settings.dart';
import 'package:tundr/services/database_service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/enums/app_theme.dart';
import 'package:tundr/enums/gender.dart';
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
    await DatabaseService.setUserField(uid, 'username', newUsername);
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

  void _openAbout() => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AboutPage()), // DESIGN: transitions
      );

  void _confirmSignOut() async {
    final signOut = await showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Are you sure you would like to sign out?'),
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
      await DatabaseService.removeToken(
        Provider.of<CurrentUser>(context).user.uid,
        Provider.of<CurrentUser>(context).fcmToken,
      );
      await FirebaseMessaging().deleteInstanceID();

      await FirebaseAuth.instance.signOut();

      // Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void _confirmDeleteAccount() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmDeleteAccountPage()),
      );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUser>(context).user;
    final uid = user.uid;
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
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SettingField(
                title: 'Username',
                child: Text(
                  user.username,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 14.0,
                  ),
                ),
                onEdit: () => _changeUsername(uid, user.username),
              ),
              SizedBox(height: 20.0),
              SeparatePageSettingField(
                title: 'Change password',
                onNextPage: _changePassword,
              ),
              SizedBox(height: 20.0),
              SettingField(
                title: 'Phone number',
                child: Text(
                  user.phoneNumber,
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 14.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              SettingField(
                title: 'Gender',
                child: RoundRadioGroup(
                  options: ['Male', 'Female'],
                  selected: Gender.values.indexOf(user.gender),
                  onChanged: (option) => DatabaseService.setUserField(
                    uid,
                    'gender',
                    option,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              SettingField(
                title: 'Show me',
                child: Column(
                  children: <Widget>[
                    SimpleCheckbox(
                      text: 'Boys',
                      value: user.showMeBoys,
                      onChanged: (bool value) => DatabaseService.setUserField(
                          uid, 'showMeBoys', value),
                    ),
                    SimpleCheckbox(
                      text: 'Girls',
                      value: user.showMeGirls,
                      onChanged: (bool value) => DatabaseService.setUserField(
                          uid, 'showMeGirls', value),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              SettingField(
                  title: 'Age range',
                  child: SimpleRangeSlider(
                    min: 13.0,
                    max: 50.0,
                    defaultRange: RangeValues(
                      user.ageRangeMin.toDouble(),
                      user.ageRangeMax.toDouble(),
                    ),
                    onChanged: (newRangeValues) =>
                        DatabaseService.setUserFields(uid, {
                      'ageRangeMin': newRangeValues.start.toInt(),
                      'ageRangeMax': newRangeValues.end.toInt(),
                    }),
                  )),
              SizedBox(height: 20.0),
              SeparatePageSettingField(
                title: 'Filters',
                onNextPage: _openFilterSettings,
              ),
              SizedBox(height: 20.0),
              SeparatePageSettingField(
                title: 'Blocked users',
                onNextPage: _openBlockedUsers,
              ),
              SizedBox(height: 20.0),
              SwitchSettingField(
                title: 'Sleep',
                description:
                    "While sleeping, you won't appear in other users' card stacks or get new suggestions",
                selected: user.asleep,
                onChanged: (value) =>
                    DatabaseService.setUserField(uid, 'asleep', value),
              ),
              SizedBox(height: 20.0),
              SwitchSettingField(
                title: 'Show in most popular',
                description:
                    'Turning this on allows you to be shown on the most popular board',
                selected: user.showInMostPopular,
                onChanged: (value) {
                  DatabaseService.setUserField(uid, 'showInMostPopular', value);
                  Provider.of<CurrentUser>(context).user.showInMostPopular =
                      value;
                },
              ),
              SizedBox(height: 20.0),
              SwitchSettingField(
                title: 'Block unknown messages',
                description:
                    'Prevent users you were not matched with from sending you messages',
                selected: user.blockUnknownMessages,
                onChanged: (value) {
                  DatabaseService.setUserField(
                      uid, 'blockUnknownMessages', value);
                  Provider.of<CurrentUser>(context).user.blockUnknownMessages =
                      value;
                },
              ),
              SizedBox(height: 20.0),
              SeparatePageSettingField(
                title: 'Notifications',
                onNextPage: _openNotificationSettings,
              ),
              SizedBox(height: 20.0),
              SettingField(
                title: 'Theme',
                child: RoundRadioGroup(
                  options: ['Dark', 'Light'],
                  selected: AppTheme.values
                      .indexOf(Provider.of<ThemeNotifier>(context).theme),
                  onChanged: (option) {
                    Provider.of<ThemeNotifier>(context).theme =
                        AppTheme.values[option];
                    DatabaseService.setUserField(uid, 'theme', option);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              SwitchSettingField(
                title: 'Read receipts',
                description:
                    "If turned off, you won't send or receive read receipts",
                selected: user.readReceipts,
                onChanged: (value) {
                  DatabaseService.setUserField(uid, 'readReceipts', value);
                  Provider.of<CurrentUser>(context).user.readReceipts = value;
                },
              ),
              SizedBox(height: 20.0),
              Provider.of<ThemeNotifier>(context).theme == AppTheme.dark
                  ? GestureDetector(
                      // FUTURE: make this work for other themes, refractor to darktilebutton
                      child: Container(
                        width: double.infinity,
                        height: 100.0,
                        padding: EdgeInsets.all(30.0),
                        color: AppColors.gold,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'About tundr',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 30.0,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: AppColors.black, size: 30.0),
                          ],
                        ),
                      ),
                      onTap: _openAbout,
                    )
                  : LightTileButton(
                      color: AppColors.gold,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'About tundr',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 30.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.white,
                            size: 30.0,
                          ),
                        ],
                      ),
                      onTap: _openAbout,
                    ),
              SizedBox(height: 20.0),
              GestureDetector(
                // FUTURE: replace with flatdarktilebutton
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Sign out',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 20.0,
                        ),
                      ),
                      Icon(Icons.power_settings_new, color: AppColors.red),
                    ],
                  ),
                ),
                onTap: _confirmSignOut,
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Delete account',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: 20.0,
                        ),
                      ),
                      Icon(Icons.delete, color: AppColors.red),
                    ],
                  ),
                ),
                onTap: _confirmDeleteAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
