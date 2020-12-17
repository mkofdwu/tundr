import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _loginBtnPressed = false;
  bool _registerBtnPressed = false;

  List<Widget> _buildTitle(double height) => <Widget>[
        Positioned(
          left: 0,
          top: height * 63 / 736,
          child: Container(
            width: 200,
            height: 200,
            color: MyPalette.black,
          ),
        ),
        Positioned(
          left: 36,
          top: height * 44 / 736,
          child: Container(
            width: 254,
            height: 142,
            color: MyPalette.gold,
          ),
        ),
        Positioned(
          left: 36,
          top: height * 40 / 736,
          width: 230,
          child: Image.asset('assets/images/logo-light.png'),
        ),
        Positioned(
          left: 186,
          top: height * 44 / 736 + 110,
          child: Text(
            'By Jia Jie',
            style: TextStyle(
              color: MyPalette.black,
              fontSize: 20,
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Material(
      color: MyPalette.white,
      child: Stack(
        children: _buildTitle(height) +
            <Widget>[
              Positioned(
                top: height * 0.441,
                right: 0,
                child: Container(
                  width: width * 0.464,
                  height: height * 0.052,
                  color: MyPalette.gold,
                ),
              ),
              Positioned(
                top: height * 420 / 812,
                right: 0,
                child: Container(
                  width: width * 111 / 375,
                  height: height * 18 / 812,
                  color: MyPalette.gold,
                ),
              ),
              Positioned(
                top: height * 446 / 812,
                right: 0,
                child: Container(
                  width: width * 263 / 375,
                  height: height * 20 / 812,
                  color: MyPalette.black,
                ),
              ),
              Positioned(
                top: height * 470 / 812,
                right: 0,
                child: Container(
                  width: width * 136 / 375,
                  height: height * 6 / 812,
                  color: MyPalette.gold,
                ),
              ),
              Positioned(
                top: height * 489 / 812,
                right: 0,
                child: Container(
                  width: width * 184 / 375,
                  height: height * 7 / 812,
                  color: MyPalette.black,
                ),
              ),
              Positioned(
                top: height * 523 / 812,
                right: 0,
                child: GestureDetector(
                  key: ValueKey('loginBtn'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: width * 184 / 375,
                    height: height * 63 / 812,
                    color: MyPalette.black,
                    padding: const EdgeInsets.only(
                      right: 21,
                      bottom: 10,
                    ),
                    alignment: Alignment.bottomRight,
                    transform: _loginBtnPressed
                        ? Matrix4.translationValues(10, 0, 0)
                        : Matrix4.identity(),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: MyPalette.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  onTapDown: (_) => setState(() => _loginBtnPressed = true),
                  onTapUp: (_) {
                    setState(() => _loginBtnPressed = false);
                    Navigator.pushNamed(context, '/login');
                  },
                  onTapCancel: () => setState(() => _loginBtnPressed = false),
                ),
              ),
              Positioned(
                top: height * 589 / 812,
                right: 0,
                child: Container(
                  width: width * 56 / 375,
                  height: height * 23 / 812,
                  color: MyPalette.black,
                ),
              ),
              Positioned(
                top: height * 630 / 812,
                right: 0,
                child: GestureDetector(
                  key: ValueKey('registerBtn'),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: width * 132 / 375,
                    height: height * 38 / 812,
                    color: MyPalette.gold,
                    padding: const EdgeInsets.only(bottom: 5, right: 10),
                    alignment: Alignment.bottomRight,
                    transform: _registerBtnPressed
                        ? Matrix4.translationValues(10, 0, 0)
                        : Matrix4.identity(),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: MyPalette.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  onTapDown: (_) => setState(() => _registerBtnPressed = true),
                  onTapUp: (_) {
                    setState(() => _registerBtnPressed = false);
                    Navigator.pushNamed(context, '/register');
                  },
                  onTapCancel: () =>
                      setState(() => _registerBtnPressed = false),
                ),
              ),
              Positioned(
                top: height * 677 / 812,
                right: 0,
                child: Container(
                  width: width * 81 / 375,
                  height: height * 16 / 812,
                  color: MyPalette.black,
                ),
              ),
              Positioned(
                top: height * 698 / 812,
                right: 0,
                child: Container(
                  width: width * 103 / 375,
                  height: height * 6 / 812,
                  color: MyPalette.black,
                ),
              ),
            ],
      ),
    );
  }
}
