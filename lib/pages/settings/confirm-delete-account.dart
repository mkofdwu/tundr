import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/provider-data.dart';
import 'package:tundr/services/auth-service.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/widgets/buttons/flat-tile.dart';
import 'package:tundr/widgets/buttons/tile-icon.dart';
import 'package:tundr/widgets/pages/stack-scroll.dart';
import 'package:tundr/widgets/textfields/tile.dart';

class ConfirmDeleteAccountPage extends StatelessWidget {
  // FUTURE: fix this design
  final TextEditingController _passwordController = TextEditingController();

  _deleteAccount(BuildContext context) async {
    if (await AuthService.signIn(
      username: Provider.of<ProviderData>(context).user.username,
      password: _passwordController.text,
    )) {
      DatabaseService.deleteAccount(
          Provider.of<ProviderData>(context).user.uid);
      AuthService.deleteAccount();
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Invalid password"),
          content: Text("Failed to delete your account"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
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
            "Confirm your password to delete your account",
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
            text: "Delete account",
            color: AppColors.red,
            onTap: () => _deleteAccount(context),
          ),
        ),
      ],
    );
  }
}
