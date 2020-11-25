import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/pages/profile_setup/phone_verification.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class SetupPhoneNumberPage extends StatefulWidget {
  @override
  _SetupPhoneNumberPageState createState() => _SetupPhoneNumberPageState();
}

class _SetupPhoneNumberPageState extends State<SetupPhoneNumberPage> {
  final TextEditingController _phoneNumberController = TextEditingController();

  void _nextPage() async {
    if (_phoneNumberController.text.length != 8) {
      await showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Invalid phone number'),
          actions: <Widget>[
            FlatButton(
              child: Text('Retry'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }
    if (await UsersService.phoneNumberExists(_phoneNumberController.text)) {
      await showDialog(
        context: context,
        child: AlertDialog(
          title: Text('Invalid phone number'),
          content: Text(
              'This phone number already has an account associated with it'),
          actions: <Widget>[
            FlatButton(
              child: Text('Retry'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    Provider.of<RegistrationInfo>(context).phoneNumber =
        '+65' + _phoneNumberController.text;
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            PhoneVerificationPage(),
        transitionsBuilder: (context, animation1, animation2, child) {
          // ANIMATION: curved animation with set duration
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.0, 1.0),
              end: Offset(0.0, 0.0),
            ).animate(animation1),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _phoneNumberController.text = Provider.of<RegistrationInfo>(context)
        .phoneNumber
        .substring(3); // FUTURE: change this when more country codes are added
    return ScrollDownPage(
      builder: (context, width, height) => Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Image.asset(
              'assets/images/setup-phone-number-background.png',
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: width * 47 / 375,
            top: height * 180 / 812,
            child: Text(
              'Phone number',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontFamily: 'Helvetica Neue',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: width * 93 / 375,
            top: height * 240 / 812,
            child: Text(
              'A verification code will be sent\nto you via SMS.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: height * 339 / 812,
            width: width - 60,
            child: Row(
              children: <Widget>[
                Container(
                  color: MyPalette.white,
                  height: 60.0,
                  width: 90.0,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 5.0),
                      Icon(Icons.add, color: MyPalette.black, size: 30.0),
                      Text(
                        '65',
                        style: TextStyle(
                          color: MyPalette.black,
                          fontSize: 40.0,
                          fontFamily: 'Helvetica Neue',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      color: MyPalette.white,
                      fontSize: 40.0,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.only(bottom: 5.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: MyPalette.white,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: MyPalette.white,
                          width: 5.0,
                        ),
                      ),
                    ),
                    cursorColor: MyPalette.white,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    controller: _phoneNumberController,
                    onEditingComplete: _nextPage,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: width * 179 / 375,
            bottom: 20.0,
            child: NextPageArrow(onNextPage: _nextPage),
          ),
        ],
      ),
      onScrollDown: _nextPage,
    );
  }
}
