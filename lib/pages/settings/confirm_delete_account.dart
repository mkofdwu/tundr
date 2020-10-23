import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/services/auth_service.dart';
import 'package:tundr/services/database_service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/widgets/buttons/flat_tile.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';
import 'package:tundr/widgets/textfields/tile.dart';

class ConfirmDeleteAccountPage extends StatelessWidget {
  // FUTURE: fix this design
  final TextEditingController _passwordController = TextEditingController();

  void _deleteAccount(BuildContext context) async {
    if (await AuthService.signIn(
      username: Provider.of<CurrentUser>(context).user.username,
      password: _passwordController.text,
    )) {
      await DatabaseService.deleteAccount(
          Provider.of<CurrentUser>(context).user.uid);
      await AuthService.deleteAccount();
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
        TileIconButton(
          icon: Icons.arrow_back,
          onPressed: () => Navigator.pop(context),
        ),
        Positioned(
          left: width * 37 / 375,
          top: height * 100 / 812,
          width: width - 100,
          child: Text(
            'Confirm your password to delete your account',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Positioned(
          top: height * 500 / 812,
          right: 40.0,
          width: width * 170 / 375,
          child: TileTextField(
            controller: _passwordController,
            obscureText: true,
            autoFocus: true,
            moveFocus: false,
            onEditingComplete: () => _deleteAccount(context),
          ),
        ),
        Positioned(
          right: 20.0,
          bottom: 100.0,
          child: FlatTileButton(
            text: 'Delete account',
            color: AppColors.red,
            onTap: () => _deleteAccount(context),
          ),
        ),
      ],
    );
  }
}
