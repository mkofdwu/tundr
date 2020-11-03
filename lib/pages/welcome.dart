import 'package:flutter/material.dart';
import 'package:tundr/pages/register.dart';
import 'package:tundr/pages/sign_in.dart';
import 'package:tundr/constants/my_palette.dart';

class WelcomePage extends StatelessWidget {
  void _signInPage(BuildContext context) => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => SignInPage(),
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(
                opacity: animation1, child: child); // FUTURE: animations
          },
        ),
      );

  void _registerPage(BuildContext context) => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => RegisterPage(),
          transitionsBuilder: (context, animation1, animation2, child) {
            return FadeTransition(
                opacity: animation1, child: child); // ANIMATIONS: animations
          },
        ),
      );

  List<Widget> _titleWidgets() => <Widget>[
        Positioned(
          left: 0.0,
          top: 63.0,
          child: Container(
            width: 223.0,
            height: 204.0,
            color: MyPalette.black,
          ),
        ),
        Positioned(
          left: 29.0,
          top: 35.0,
          child: Container(
            width: 254.0,
            height: 142.0,
            color: MyPalette.gold,
          ),
        ),
        Positioned(
          left: 25.0,
          top: 30.0,
          width: 230.0,
          child: Image.asset('assets/images/logo-light.png'),
        ),
        Positioned(
          left: 191.0,
          top: 134.0,
          child: Text(
            'By Jia Jie',
            style: TextStyle(
              color: MyPalette.black,
              fontSize: 20.0,
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Material(
        color: MyPalette.white,
        child: Stack(
          children: _titleWidgets() +
              <Widget>[
                Positioned(
                  top: height * 0.441,
                  right: 0.0,
                  child: Container(
                    width: width * 0.464,
                    height: height * 0.052,
                    color: MyPalette.gold,
                  ),
                ),
                Positioned(
                  top: height * 420 / 812,
                  right: 0.0,
                  child: Container(
                    width: width * 111 / 375,
                    height: height * 18 / 812,
                    color: MyPalette.gold,
                  ),
                ),
                Positioned(
                  top: height * 446 / 812,
                  right: 0.0,
                  child: Container(
                    width: width * 263 / 375,
                    height: height * 20 / 812,
                    color: MyPalette.black,
                  ),
                ),
                Positioned(
                  top: height * 470 / 812,
                  right: 0.0,
                  child: Container(
                    width: width * 136 / 375,
                    height: height * 6 / 812,
                    color: MyPalette.gold,
                  ),
                ),
                Positioned(
                  top: height * 489 / 812,
                  right: 0.0,
                  child: Container(
                    width: width * 184 / 375,
                    height: height * 7 / 812,
                    color: MyPalette.black,
                  ),
                ),
                Positioned(
                  top: height * 523 / 812,
                  right: 0.0,
                  child: GestureDetector(
                    child: Container(
                      width: width * 184 / 375,
                      height: height * 63 / 812,
                      color: MyPalette.black,
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 21.0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            color: MyPalette.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    onTap: () => _signInPage(context),
                  ),
                ),
                Positioned(
                  top: height * 589 / 812,
                  right: 0.0,
                  child: Container(
                    width: width * 56 / 375,
                    height: height * 23 / 812,
                    color: MyPalette.black,
                  ),
                ),
                Positioned(
                  top: height * 630 / 812,
                  right: 0.0,
                  child: GestureDetector(
                    child: Container(
                      width: width * 132 / 375,
                      height: height * 38 / 812,
                      color: MyPalette.gold,
                      child: Stack(
                        // is there a better way?
                        children: <Widget>[
                          Positioned(
                            right: 2.0,
                            bottom: 10.0,
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: MyPalette.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => _registerPage(context),
                  ),
                ),
                Positioned(
                  top: height * 677 / 812,
                  right: 0.0,
                  child: Container(
                    width: width * 81 / 375,
                    height: height * 16 / 812,
                    color: MyPalette.black,
                  ),
                ),
                Positioned(
                  top: height * 698 / 812,
                  right: 0.0,
                  child: Container(
                    width: width * 103 / 375,
                    height: height * 6 / 812,
                    color: MyPalette.black,
                  ),
                ),
              ],
        ),
      ),
    );
  }
}
