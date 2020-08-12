import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/current-user.dart';
import 'package:tundr/services/auth-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/shadows.dart';
import 'package:tundr/utils/from-theme.dart';
import 'package:tundr/widgets/buttons/tile-icon.dart';
import 'package:tundr/widgets/pages/stack-scroll.dart';
import 'package:tundr/widgets/textfields/tile.dart';
import 'package:tundr/widgets/textfields/underline.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool _incorrect = false;
  bool _passwordLessThan6Chars = false;
  bool _passwordsDoNotMatch = false;

  _changePassword() async {
    if (_currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmNewPasswordController.text.isNotEmpty) {
      setState(() {
        _passwordLessThan6Chars = _newPasswordController.text.length < 6;
        _passwordsDoNotMatch =
            _newPasswordController.text != _confirmNewPasswordController.text;
      });
      if (_passwordLessThan6Chars || _passwordsDoNotMatch) return;
      final bool incorrect = !await AuthService.changePassword(
        userUid: Provider.of<CurrentUser>(context).user.uid,
        userUsername: Provider.of<CurrentUser>(context).user.username,
        oldPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      if (incorrect)
        setState(() => _incorrect = true);
      else {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Your password has been successfully updated."),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ).then((_) => Navigator.pop(context));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StackScrollPage(
      builder: (context, width, height) => <Widget>[
        TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context, null),
        ),
        Positioned(
          left: width * 37 / 375,
          top: height * 100 / 812,
          width: width * 200 / 375,
          child: Text(
            "Change password",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Positioned(
          top: height * 400 / 812,
          right: 20.0,
          width: width * 200 / 375,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: fromTheme(
              context,
              dark: <Widget>[
                UnderlineTextField(
                  controller: _currentPasswordController,
                  color: _passwordLessThan6Chars || _incorrect
                      ? AppColors.red
                      : AppColors.white,
                  hintText: "Current password",
                  obscureText: true,
                  autoFocus: true,
                ),
                SizedBox(height: 10.0),
                UnderlineTextField(
                  controller: _newPasswordController,
                  color: _passwordsDoNotMatch ? AppColors.red : AppColors.white,
                  hintText: "New password",
                  obscureText: true,
                ),
                SizedBox(height: 10.0),
                UnderlineTextField(
                  controller: _confirmNewPasswordController,
                  color: _passwordsDoNotMatch ? AppColors.red : AppColors.white,
                  hintText: "Confirm new password",
                  obscureText: true,
                  moveFocus: false,
                  onEditingComplete: _changePassword,
                ),
                SizedBox(height: 30.0),
                GestureDetector(
                  onTap: _changePassword,
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [Shadows.secondaryShadow],
                    ),
                    child:
                        Icon(Icons.arrow_forward_ios, color: AppColors.black),
                  ),
                ),
              ],
              light: <Widget>[
                TileTextField(
                  controller: _currentPasswordController,
                  color:
                      _passwordLessThan6Chars ? AppColors.red : AppColors.white,
                  hintText: "Current password",
                  obscureText: true,
                  autoFocus: true,
                ),
                SizedBox(height: 10.0),
                TileTextField(
                  controller: _newPasswordController,
                  color: _passwordsDoNotMatch ? AppColors.red : AppColors.white,
                  hintText: "New password",
                  obscureText: true,
                ),
                SizedBox(height: 10.0),
                TileTextField(
                  controller: _confirmNewPasswordController,
                  color: _passwordsDoNotMatch ? AppColors.red : AppColors.white,
                  hintText: "Confirm new password",
                  obscureText: true,
                  moveFocus: false,
                  onEditingComplete: _changePassword,
                ),
                SizedBox(height: 30.0),
                GestureDetector(
                  onTap: _changePassword,
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(25.0),
                      boxShadow: [Shadows.secondaryShadow],
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
