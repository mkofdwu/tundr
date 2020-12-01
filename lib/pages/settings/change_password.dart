import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/services/auth_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/back.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';
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

  void _changePassword() async {
    if (_currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmNewPasswordController.text.isNotEmpty) {
      setState(() {
        _passwordLessThan6Chars = _newPasswordController.text.length < 6;
        _passwordsDoNotMatch =
            _newPasswordController.text != _confirmNewPasswordController.text;
      });
      if (_passwordLessThan6Chars || _passwordsDoNotMatch) return;
      final incorrect = !await AuthService.changePassword(
        userUid: Provider.of<User>(context, listen: false).profile.uid,
        userUsername:
            Provider.of<User>(context, listen: false).profile.username,
        oldPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      if (incorrect) {
        setState(() => _incorrect = true);
      } else {
        await showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Your password has been successfully updated.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
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
        MyBackButton(),
        Positioned(
          left: width * 37 / 375,
          top: height * 100 / 812,
          width: width * 200 / 375,
          child: Text(
            'Change password',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Positioned(
          top: height * 400 / 812,
          right: 20,
          width: width * 200 / 375,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              UnderlineTextField(
                controller: _currentPasswordController,
                color: _passwordLessThan6Chars || _incorrect
                    ? MyPalette.red
                    : null,
                hintText: 'Current password',
                obscureText: true,
              ),
              SizedBox(height: 10),
              UnderlineTextField(
                controller: _newPasswordController,
                color: _passwordsDoNotMatch ? MyPalette.red : null,
                hintText: 'New password',
                obscureText: true,
              ),
              SizedBox(height: 10),
              UnderlineTextField(
                controller: _confirmNewPasswordController,
                color: _passwordsDoNotMatch ? MyPalette.red : null,
                hintText: 'Confirm new password',
                obscureText: true,
                moveFocus: false,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: _changePassword,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: MyPalette.gold,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [MyPalette.secondaryShadow],
                  ),
                  child: Icon(Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
