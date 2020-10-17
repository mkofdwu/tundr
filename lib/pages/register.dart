import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration-info.dart';
import 'package:tundr/pages/loading.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/pages/profile-setup/name.dart';
import 'package:tundr/constants/shadows.dart';
import 'package:tundr/widgets/pages/stack-scroll.dart';
import 'package:tundr/widgets/textfields/tile.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // FUTURE: textformfield (just with decoration?) and validation

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _usernameContainsWhitespace = false;
  bool _usernameLessThan4Chars = false;
  bool _usernameAlreadyExists = false;
  bool _passwordLessThan6Chars = false;
  bool _passwordsDoNotMatch = false;

  bool _loading = false;

  _validateAndSetup() async {
    setState(() => _loading = true);

    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final bool usernameAlreadyExists =
        await DatabaseService.usernameAlreadyExists(username);

    setState(() {
      _usernameContainsWhitespace = username.contains(RegExp(r"\s"));
      _usernameLessThan4Chars = username.length < 4;
      _usernameAlreadyExists = usernameAlreadyExists;
      _passwordLessThan6Chars = password.length < 6;
      _passwordsDoNotMatch = password != _confirmPasswordController.text;

      _confirmPasswordController.text = ""; //
    });

    if (!_usernameContainsWhitespace &&
        !_usernameLessThan4Chars &&
        !_usernameAlreadyExists &&
        !_passwordLessThan6Chars &&
        !_passwordsDoNotMatch) {
      Provider.of<RegistrationInfo>(context).username = username;
      Provider.of<RegistrationInfo>(context).password = password;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => SetupNamePage(),
          transitionsBuilder: (context, animation1, animation2, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0.0, 1.0),
                end: Offset(0.0, 0.0),
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
    _usernameController.text = Provider.of<RegistrationInfo>(context).username;
    _passwordController.text = Provider.of<RegistrationInfo>(context).password;
    return _loading
        ? LoadingPage()
        : StackScrollPage(
            color: AppColors.white,
            builder: (context, width, height) => <Widget>[
              Positioned(
                left: width * 43 / 375,
                top: 0.0,
                bottom: 0.0,
                child: Container(
                  width: width * 71 / 375,
                  color: AppColors.gold,
                ),
              ),
              Positioned(
                left: width * 144 / 375,
                top: 0.0,
                bottom: 0.0,
                child: Container(
                  width: width * 52 / 375,
                  color: AppColors.gold,
                ),
              ),
              Positioned(
                left: width * 204 / 375,
                top: 0.0,
                bottom: 0.0,
                child: Container(
                  width: width * 11 / 375,
                  color: AppColors.gold,
                ),
              ),
              Positioned(
                left: width * 67 / 375,
                top: height * 91 / 812,
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 60.0,
                    fontFamily: "Helvetica Neue",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                left: width * 89 / 375,
                top: height * 180 / 812,
                child: Text(
                  "Enter a username and password",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Positioned(
                left: width / 10,
                top: height * 360 / 812,
                width: 300, // width - 75,
                child: Column(
                  children: <Widget>[
                    TileTextField(
                      hintText: "Username",
                      controller: _usernameController,
                      autoFocus: true,
                    ),
                    _usernameContainsWhitespace
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              boxShadow: [Shadows.primaryShadow],
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Your username cannot contain any spaces",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    _usernameLessThan4Chars
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              boxShadow: [Shadows.primaryShadow],
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Your username must be at least 4 characters long",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    _usernameAlreadyExists
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              boxShadow: [Shadows.primaryShadow],
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "This username is already taken",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 20.0),
                    TileTextField(
                      hintText: "Password",
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    _passwordLessThan6Chars
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              boxShadow: [Shadows.primaryShadow],
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Your password must be at least 6 characters long",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    _passwordsDoNotMatch
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              boxShadow: [Shadows.primaryShadow],
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "The passwords do not match",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 20.0),
                    TileTextField(
                      hintText: "Confirm password",
                      controller: _confirmPasswordController,
                      obscureText: true,
                      moveFocus: false,
                      onEditingComplete: _validateAndSetup,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: width * 15 / 375,
                bottom: height * 122 / 812,
                child: GestureDetector(
                  child: Container(
                    width: 120, // width * 100 / 375,
                    height: 60, // height * 60 / 812,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(
                          30), // BorderRadius.circular(height * 30 / 812),
                      boxShadow: [Shadows.secondaryShadow],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Setup",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: _validateAndSetup,
                ),
              ),
            ],
          );
  }
}