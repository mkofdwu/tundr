import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/pages/loading.dart';
import 'package:tundr/store/user.dart';
import 'package:tundr/services/auth_service.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/utils/show_error_dialog.dart';
import 'package:tundr/widgets/buttons/back.dart';
import 'package:tundr/widgets/buttons/flat_tile.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';
import 'package:tundr/widgets/rebuilder.dart';
import 'package:tundr/widgets/textfields/underline.dart';

class ConfirmDeleteAccountPage extends StatefulWidget {
  @override
  _ConfirmDeleteAccountPageState createState() =>
      _ConfirmDeleteAccountPageState();
}

class _ConfirmDeleteAccountPageState extends State<ConfirmDeleteAccountPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  void _deleteAccount() async {
    setState(() => _loading = true);
    if (await AuthService.signIn(
          username: Provider.of<User>(context, listen: false).profile.username,
          password: _passwordController.text,
        ) ==
        null) {
      await AuthService.deleteAccount(
          Provider.of<User>(context, listen: false).profile.uid);
      Rebuilder.rebuild(context);
    } else {
      setState(() => _loading = false);
      await showErrorDialog(
        context: context,
        title: 'Invalid password',
        content: 'Failed to delete your account',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? LoadingPage()
        : StackScrollPage(
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
                top: height * 420 / 812,
                right: 40,
                width: width * 170 / 375,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    UnderlineTextField(
                      key: ValueKey('confirmPasswordField'),
                      controller: _passwordController,
                      obscureText: true,
                      moveFocus: false,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                    ),
                    SizedBox(height: 100),
                    FlatTileButton(
                      key: ValueKey('confirmDeleteAccountBtn'),
                      text: 'Delete account',
                      color: MyPalette.red,
                      onTap: _deleteAccount,
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
