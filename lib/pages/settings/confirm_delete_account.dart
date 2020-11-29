import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/services/auth_service.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/back.dart';
import 'package:tundr/widgets/buttons/flat_tile.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';
import 'package:tundr/widgets/textfields/underline.dart';

class ConfirmDeleteAccountPage extends StatelessWidget {
  // FUTURE: fix this design
  final TextEditingController _passwordController = TextEditingController();

  void _deleteAccount(BuildContext context) async {
    if (await AuthService.signIn(
          username: Provider.of<User>(context, listen: false).profile.username,
          password: _passwordController.text,
        ) ==
        null) {
      await AuthService.deleteAccount(
          Provider.of<User>(context, listen: false).profile.uid);
      Navigator.popUntil(context, (route) => route.isFirst);
      await showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Success'),
          content: Text('Your account has been deleted'),
        ),
      );
    } else {
      await showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Invalid password'),
          content: Text('Failed to delete your account'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
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
          width: width - 100,
          child: Text(
            'Confirm your password to delete your account',
            style: TextStyle(fontSize: 40),
          ),
        ),
        Positioned(
          top: height * 500 / 812,
          right: 40.0,
          width: width * 170 / 375,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              UnderlineTextField(
                key: ValueKey('confirmPasswordField'),
                controller: _passwordController,
                obscureText: true,
                moveFocus: false,
              ),
              SizedBox(height: 20),
              FlatTileButton(
                key: ValueKey('confirmDeleteAccountBtn'),
                text: 'Delete account',
                color: MyPalette.red,
                onTap: () => _deleteAccount(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
