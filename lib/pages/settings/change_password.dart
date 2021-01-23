import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/store/user.dart';
import 'package:tundr/services/auth_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/utils/show_info_dialog.dart';
import 'package:tundr/widgets/buttons/back.dart';
import 'package:tundr/widgets/buttons/round.dart';
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
        await showInfoDialog(
          context: context,
          title: 'Your password has been successfully updated.',
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
            style: TextStyle(fontSize: 40),
          ),
        ),
        Positioned(
          top: height * 380 / 812,
          right: 50,
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
              UnderlineTextField(
                controller: _newPasswordController,
                color: _passwordsDoNotMatch ? MyPalette.red : null,
                hintText: 'New password',
                obscureText: true,
              ),
              UnderlineTextField(
                controller: _confirmNewPasswordController,
                color: _passwordsDoNotMatch ? MyPalette.red : null,
                hintText: 'Confirm new password',
                obscureText: true,
                moveFocus: false,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
              ),
              SizedBox(height: 50),
              MyRoundButton(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).primaryColor,
                ),
                backgroundColor: MyPalette.gold,
                onTap: _changePassword,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
