import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/store/registration_info.dart';
import 'package:tundr/pages/loading.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/pages/setup/name.dart';
import 'package:tundr/utils/find_username_error.dart';
import 'package:tundr/widgets/buttons/round.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';
import 'package:tundr/widgets/textfields/tile.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _usernameError;
  bool _passwordLessThan6Chars = false;
  bool _passwordsDoNotMatch = false;

  bool _loading = false;

  void _validateAndSetup() async {
    setState(() => _loading = true);

    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final usernameError = await findUsernameError(username);

    setState(() {
      _usernameError = usernameError;
      _passwordLessThan6Chars = password.length < 6;
      _passwordsDoNotMatch = password != confirmPassword;
    });

    if (_usernameError == null &&
        !_passwordLessThan6Chars &&
        !_passwordsDoNotMatch) {
      Provider.of<RegistrationInfo>(context, listen: false).username = username;
      Provider.of<RegistrationInfo>(context, listen: false).password = password;
      Provider.of<RegistrationInfo>(context, listen: false).confirmPassword =
          confirmPassword;
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => SetupNamePage(),
          transitionsBuilder: (context, animation1, animation2, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 1),
                end: Offset(0, 0),
              ).animate(animation1),
              child: child,
            );
          },
        ),
      ).then((value) => setState(() => _loading = false));
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _usernameController.text =
        Provider.of<RegistrationInfo>(context, listen: false).username;
    _passwordController.text =
        Provider.of<RegistrationInfo>(context, listen: false).password;
    _confirmPasswordController.text =
        Provider.of<RegistrationInfo>(context, listen: false).confirmPassword;
    return _loading
        ? LoadingPage()
        : StackScrollPage(
            color: MyPalette.white,
            builder: (context, width, height) => <Widget>[
              Positioned(
                left: width * 33 / 375,
                top: 0,
                bottom: 0,
                child: Container(
                  width: width * 78 / 375,
                  color: MyPalette.gold,
                ),
              ),
              Positioned(
                left: width * 134 / 375,
                top: 0,
                bottom: 0,
                child: Container(
                  width: width * 52 / 375,
                  color: MyPalette.gold,
                ),
              ),
              Positioned(
                left: width * 194 / 375,
                top: 0,
                bottom: 0,
                child: Container(
                  width: width * 11 / 375,
                  color: MyPalette.gold,
                ),
              ),
              Positioned(
                left: 50,
                top: 100,
                width: width - 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Register',
                      style: TextStyle(
                        color: MyPalette.black,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Enter a username and password',
                      style: TextStyle(
                        color: MyPalette.black,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 100),
                    TileTextField(
                      key: ValueKey('usernameField'),
                      hintText: 'Username',
                      controller: _usernameController,
                    ),
                    if (_usernameError != null)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: MyPalette.red,
                          boxShadow: [MyPalette.primaryShadow],
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          _usernameError,
                          style: TextStyle(
                            color: MyPalette.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    SizedBox(height: 20),
                    TileTextField(
                      key: ValueKey('passwordField'),
                      hintText: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    _passwordLessThan6Chars
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: MyPalette.red,
                              boxShadow: [MyPalette.primaryShadow],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Your password must be at least 6 characters long',
                              style: TextStyle(
                                color: MyPalette.white,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 20),
                    TileTextField(
                      key: ValueKey('confirmPasswordField'),
                      hintText: 'Confirm password',
                      controller: _confirmPasswordController,
                      obscureText: true,
                      moveFocus: false,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                    ),
                    _passwordsDoNotMatch
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: MyPalette.red,
                              boxShadow: [MyPalette.primaryShadow],
                            ),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'The passwords do not match',
                              style: TextStyle(
                                color: MyPalette.white,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              Positioned(
                right: 50,
                bottom: 100,
                child: MyRoundButton(
                  width: 100,
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Setup',
                        style: TextStyle(
                          color: MyPalette.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: MyPalette.white,
                        size: 16,
                      ),
                    ],
                  ),
                  onTap: _validateAndSetup,
                ),
              ),
            ],
          );
  }
}
