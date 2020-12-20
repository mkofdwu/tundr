import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/features.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/repositories/theme_manager.dart';
import 'package:tundr/pages/settings/confirm_delete_account.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/gender.dart';
import 'package:tundr/services/notifications_service.dart';
import 'package:tundr/utils/find_username_error.dart';
import 'package:tundr/utils/show_error_dialog.dart';
import 'package:tundr/utils/show_question_dialog.dart';
import 'package:tundr/widgets/buttons/light_tile.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/simple_checkbox.dart';
import 'package:tundr/widgets/round_radio_group.dart';
import 'package:tundr/widgets/rebuilder.dart';
import 'package:tundr/widgets/simple_range_slider.dart';
import 'widgets/separate_page_setting_field.dart';
import 'widgets/setting_field.dart';
import 'widgets/switch_setting_field.dart';

class MainSettingsPage extends StatefulWidget {
  @override
  _MainSettingsPageState createState() => _MainSettingsPageState();
}

class _MainSettingsPageState extends State<MainSettingsPage> {
  final _usernameController = TextEditingController();
  bool _editingUsername = false;

  void _changeUsername() async {
    final error = await findUsernameError(_usernameController.text);
    if (error == null) {
      await auth.FirebaseAuth.instance.currentUser
          .updateEmail(_usernameController.text + '@example.com');
      await Provider.of<User>(context, listen: false)
          .updateProfile({'username': _usernameController.text});
      setState(() {}); // reflect change on ui
    } else {
      await showErrorDialog(
        context: context,
        title: 'Invalid username',
        content: error,
      );
    }
  }

  void _confirmLogout() async {
    final logout = await showQuestionDialog(
      context: context,
      title: 'Are you sure you would like to logout?',
    );
    if (logout) {
      // unsubscribe from notifications for this user
      await NotificationsService.removeToken(
        Provider.of<User>(context, listen: false).profile.uid,
        Provider.of<User>(context, listen: false).fcmToken,
      );
      await FirebaseMessaging().deleteInstanceID();
      await auth.FirebaseAuth.instance.signOut();
      Rebuilder.rebuild(context);
    }
  }

  void _confirmDeleteAccount() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmDeleteAccountPage()),
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _usernameController.text =
          Provider.of<User>(context, listen: false).profile.username;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<User>(context, listen: false).profile;
    final privateInfo = Provider.of<User>(context, listen: false).privateInfo;
    final settings = privateInfo.settings;
    final algorithmData =
        Provider.of<User>(context, listen: false).algorithmData;
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
                child: _editingUsername
                    ? TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 14),
                      )
                    : Text(profile.username, style: TextStyle(fontSize: 14)),
                onEditOrSubmit: () {
                  setState(() => _editingUsername = !_editingUsername);
                  if (!_editingUsername) _changeUsername();
                },
                isEditing: _editingUsername,
              ),
              SizedBox(height: 20),
              SeparatePageSettingField(
                title: 'Change password',
                onNextPage: () =>
                    Navigator.pushNamed(context, '/settings/change_password'),
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
                onNextPage: () =>
                    Navigator.pushNamed(context, '/settings/filters'),
              ),
              SizedBox(height: 20),
              SeparatePageSettingField(
                title: 'Blocked users',
                onNextPage: () =>
                    Navigator.pushNamed(context, '/settings/blocked_users'),
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
                onNextPage: () =>
                    Navigator.pushNamed(context, '/settings/notifications'),
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
              SeparatePageSettingField(
                title: 'Take a tour',
                onNextPage: () async {
                  await FeatureDiscovery.clearPreferences(context, features);
                  Rebuilder.rebuild(context);
                },
              ),
              SizedBox(height: 20),
              Provider.of<ThemeManager>(context).theme == ThemeMode.dark
                  ? GestureDetector(
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
                      onTap: () => Navigator.pushNamed(context, '/about'),
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
                      onTap: () => Navigator.pushNamed(context, '/about'),
                    ),
              SizedBox(height: 20),
              FlatButton(
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
