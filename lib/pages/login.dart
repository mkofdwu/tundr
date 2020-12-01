import 'package:flutter/material.dart';
import 'package:tundr/services/auth_service.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/pages/stack_scroll.dart';
import 'package:tundr/widgets/textfields/tile.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    final error = await AuthService.signIn(
      username: _usernameController.text,
      password: _passwordController.text,
    );
    if (error == null) {
      Navigator.pop(context);
    } else {
      await showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Error'),
          content: Text(error),
          actions: [
            FlatButton(
              child: Text('Close'),
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
                'Login',
                style: TextStyle(
                  color: MyPalette.black,
                  fontSize: 60,
                  fontFamily: 'Helvetica Neue',
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
              SizedBox(height: 20),
              TileTextField(
                key: ValueKey('passwordField'),
                hintText: 'Password',
                controller: _passwordController,
                obscureText: true,
                moveFocus: false,
                onEditingComplete: () => FocusScope.of(context).unfocus(),
              ),
            ],
          ),
        ),
        Positioned(
          right: 50,
          bottom: 100,
          child: GestureDetector(
            key: ValueKey('loginSubmitBtn'),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: MyPalette.black,
                borderRadius: BorderRadius.circular(30),
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
