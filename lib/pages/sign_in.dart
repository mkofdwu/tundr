import 'package:flutter/material.dart';
import 'package:tundr/services/auth_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';
import 'package:tundr/widgets/textfields/tile.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _incorrect = false;

  void _signIn() async {
    final success = await AuthService.signIn(
      username: _usernameController.text,
      password: _passwordController.text,
    );
    if (success) {
      Navigator.pop(context);
    } else {
      setState(() => _incorrect = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StackScrollPage(
      color: MyPalette.white,
      builder: (context, width, height) => <Widget>[
        Positioned(
          left: width * 43 / 375,
          top: 0.0,
          bottom: 0.0,
          child: Container(
            width: width * 71 / 375,
            color: MyPalette.gold,
          ),
        ),
        Positioned(
          left: width * 144 / 375,
          top: 0.0,
          bottom: 0.0,
          child: Container(
            width: width * 52 / 375,
            color: MyPalette.gold,
          ),
        ),
        Positioned(
          left: width * 204 / 375,
          top: 0.0,
          bottom: 0.0,
          child: Container(
            width: width * 11 / 375,
            color: MyPalette.gold,
          ),
        ),
        Positioned(
          left: width * 67 / 375,
          top: height * 91 / 812,
          child: Text(
            'Sign in',
            style: TextStyle(
              color: MyPalette.black,
              fontSize: 60.0,
              fontFamily: 'Helvetica Neue',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (_incorrect)
          Positioned(
            left: width * 70 / 375,
            top: height * 210 / 812,
            child: Container(
              width: 200.0,
              height: 100.0,
              padding: EdgeInsets.all(20.0),
              color: MyPalette.red,
              child: Text(
                'Incorrect username or password',
                style: TextStyle(
                  color: MyPalette.white,
                  fontSize: 16.0,
                ),
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
                hintText: 'Username',
                controller: _usernameController,
                autoFocus: true,
              ),
              SizedBox(height: 20.0),
              TileTextField(
                hintText: 'Password',
                controller: _passwordController,
                obscureText: true,
                moveFocus: false,
                onEditingComplete: _signIn,
              ),
            ],
          ),
        ),
        Positioned(
          right: width * 15 / 375,
          bottom: height * 122 / 812,
          child: GestureDetector(
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: MyPalette.black,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [MyPalette.secondaryShadow],
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: MyPalette.white,
                ),
              ),
            ),
            onTap: _signIn,
          ),
        ),
      ],
    );
  }
}
