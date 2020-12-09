import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/pages/loading.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/pages/setup/phone_verification.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/services/auth_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/show_error_dialog.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class SetupPhoneNumberPage extends StatefulWidget {
  @override
  _SetupPhoneNumberPageState createState() => _SetupPhoneNumberPageState();
}

class _SetupPhoneNumberPageState extends State<SetupPhoneNumberPage> {
  bool _loading = false;

  void _nextPage() async {
    setState(() => _loading = true);
    final phoneNumber =
        Provider.of<RegistrationInfo>(context, listen: false).phoneNumber;
    if (phoneNumber.length != 11) {
      await showErrorDialog(context: context, title: 'Invalid phone number');
      setState(() => _loading = false);
      return;
    }

    if (await UsersService.phoneNumberExists(phoneNumber)) {
      await showErrorDialog(
        context: context,
        title: 'Invalid phone number',
        content: 'This phone number already has an account associated with it',
      );
      setState(() => _loading = false);
      return;
    }

    await AuthService.sendSMS(
        Provider.of<RegistrationInfo>(context, listen: false));
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            PhoneVerificationPage(),
        transitionsBuilder: (context, animation1, animation2, child) {
          // ANIMATION: curved animation with set duration
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, 1),
              end: Offset(0, 0),
            ).animate(animation1),
            child: child,
          );
        },
      ),
    );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? LoadingPage()
        : ScrollDownPage(
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
                      fontSize: 40,
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
                      fontSize: 16,
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
                        height: 60,
                        width: 90,
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 5),
                            Icon(Icons.add, color: MyPalette.black, size: 30),
                            Text(
                              '65',
                              style: TextStyle(
                                color: MyPalette.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            color: MyPalette.white,
                            fontSize: 40,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: EdgeInsets.only(bottom: 5),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: MyPalette.white,
                                width: 2,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: MyPalette.white,
                                width: 5,
                              ),
                            ),
                          ),
                          cursorColor: MyPalette.white,
                          maxLength: 8,
                          keyboardType: TextInputType.number,
                          controller: TextEditingController()
                            ..text = Provider.of<RegistrationInfo>(context,
                                    listen: false)
                                .phoneNumber
                                .substring(3),
                          onChanged: (value) {
                            Provider.of<RegistrationInfo>(context,
                                    listen: false)
                                .phoneNumber = '+65' + value;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: width * 179 / 375,
                  bottom: 20,
                  child: ScrollDownArrow(onNextPage: _nextPage),
                ),
              ],
            ),
            onScrollDown: _nextPage,
          );
  }
}
