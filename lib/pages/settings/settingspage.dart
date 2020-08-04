import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/personalinfofield.dart';
import 'package:tundr/models/providerdata.dart';
import 'package:tundr/models/themenotifier.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/pages/aboutpage.dart';
import 'package:tundr/pages/personalinfo/textfieldpage.dart';
import 'package:tundr/pages/settings/blockeduserspage.dart';
import 'package:tundr/pages/settings/changepasswordpage.dart';
import 'package:tundr/pages/settings/confirmdeleteaccountpage.dart';
import 'package:tundr/pages/settings/filtersettingspage.dart';
import 'package:tundr/pages/settings/notificationsettingspage.dart';
import 'package:tundr/services/databaseservice.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/utils/constants/enums/apptheme.dart';
import 'package:tundr/utils/constants/enums/gender.dart';
import 'package:tundr/widgets/buttons/lighttilebutton.dart';
import 'package:tundr/widgets/buttons/tileiconbutton.dart';
import 'package:tundr/widgets/checkboxes/simplecheckbox.dart';
import 'package:tundr/widgets/radiogroups/roundradiogroup.dart';
import 'package:tundr/widgets/settings/separatepagesettingfield.dart';
import 'package:tundr/widgets/settings/settingfield.dart';
import 'package:tundr/widgets/settings/switchsettingfield.dart';
import 'package:tundr/widgets/sliders/simplerangeslider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _changeUsername(String uid, String username) async {
    String newUsername = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TextFieldPage(
          field: PersonalInfoField(
            name: "Username",
            prompt: "Enter a new username",
          ),
          value: username,
        ),
      ),
    );
    DatabaseService.setUserField(uid, "username", newUsername);
  }

  _changePassword() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangePasswordPage()),
      );

  _openFilterSettings() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FilterSettingsPage()),
      );

  _openBlockedUsers() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BlockedUsersPage()),
      );

  _openNotificationSettings() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationSettingsPage()),
      );

  _openAbout() => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AboutPage()), // DESIGN: transitions
      );

  _confirmSignOut() async {
    bool signOut = await showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Are you sure you would like to sign out?"),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context, true),
          ),
          FlatButton(
            child: Text("CANCEL"),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
    if (signOut) {
      // unsubscribe from notifications for this user
      DatabaseService.removeToken(
        Provider.of<ProviderData>(context).user.uid,
        Provider.of<ProviderData>(context).fcmToken,
      );
      FirebaseMessaging().deleteInstanceID();

      FirebaseAuth.instance.signOut();

      // Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  _confirmDeleteAccount() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConfirmDeleteAccountPage()),
      );

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<ProviderData>(context).user;
    final String uid = user.uid;
    return Scaffold(
      appBar: AppBar(
        leading: TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Settings",
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
                title: "Username",
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
                title: "Change password",
                onNextPage: _changePassword,
              ),
              SizedBox(height: 20.0),
              SettingField(
                title: "Phone number",
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
                title: "Gender",
                child: RoundRadioGroup(
                  options: ["Male", "Female"],
                  selected: Gender.values.indexOf(user.gender),
                  onChanged: (option) => DatabaseService.setUserField(
                    uid,
                    "gender",
                    option,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              SettingField(
                title: "Show me",
                child: Column(
                  children: <Widget>[
                    SimpleCheckbox(
                      text: "Boys",
                      value: user.showMeBoys,
                      onChanged: (bool value) => DatabaseService.setUserField(
                          uid, "showMeBoys", value),
                    ),
                    SimpleCheckbox(
                      text: "Girls",
                      value: user.showMeGirls,
                      onChanged: (bool value) => DatabaseService.setUserField(
                          uid, "showMeGirls", value),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              SettingField(
                  title: "Age range",
                  child: SimpleRangeSlider(
                    min: 13.0,
                    max: 50.0,
                    defaultRange: RangeValues(
                      user.ageRangeMin.toDouble(),
                      user.ageRangeMax.toDouble(),
                    ),
                    onChanged: (newRangeValues) =>
                        DatabaseService.setUserFields(uid, {
                      "ageRangeMin": newRangeValues.start.toInt(),
                      "ageRangeMax": newRangeValues.end.toInt(),
                    }),
                  )),
              SizedBox(height: 20.0),
              SeparatePageSettingField(
                title: "Filters",
                onNextPage: _openFilterSettings,
              ),
              SizedBox(height: 20.0),
              SeparatePageSettingField(
                title: "Blocked users",
                onNextPage: _openBlockedUsers,
              ),
              SizedBox(height: 20.0),
              SwitchSettingField(
                title: "Sleep",
                description:
                    "You won't appear in other users' card stacks while sleeping",
                selected: user.asleep,
                onChanged: (value) =>
                    DatabaseService.setUserField(uid, "asleep", value),
              ),
              SizedBox(height: 20.0),
              SwitchSettingField(
                title: "Show in most popular",
                description:
                    "Turning this on allows you to be shown on the most popular board",
                selected: user.showInMostPopular,
                onChanged: (value) {
                  DatabaseService.setUserField(uid, "showInMostPopular", value);
                  Provider.of<ProviderData>(context).user.showInMostPopular =
                      value;
                },
              ),
              SizedBox(height: 20.0),
              SwitchSettingField(
                title: "Block unknown messages",
                description:
                    "Prevent users you were not matched with from sending you messages",
                selected: user.blockUnknownMessages,
                onChanged: (value) {
                  DatabaseService.setUserField(
                      uid, "blockUnknownMessages", value);
                  Provider.of<ProviderData>(context).user.blockUnknownMessages =
                      value;
                },
              ),
              SizedBox(height: 20.0),
              SeparatePageSettingField(
                title: "Notifications",
                onNextPage: _openNotificationSettings,
              ),
              SizedBox(height: 20.0),
              SettingField(
                title: "Theme",
                child: RoundRadioGroup(
                  options: ["Dark", "Light"],
                  selected: AppTheme.values
                      .indexOf(Provider.of<ThemeNotifier>(context).theme),
                  onChanged: (option) {
                    Provider.of<ThemeNotifier>(context)
                        .setTheme(AppTheme.values[option]);
                    DatabaseService.setUserField(uid, "theme", option);
                  },
                ),
              ),
              SizedBox(height: 20.0),
              SwitchSettingField(
                title: "Read receipts",
                description:
                    "If turned off, you won't send or receive read receipts",
                selected: user.readReceipts,
                onChanged: (value) {
                  DatabaseService.setUserField(uid, "readReceipts", value);
                  Provider.of<ProviderData>(context).user.readReceipts = value;
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
                              "About tundr",
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
                            "About tundr",
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
                        "Sign out",
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
                        "Delete account",
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
