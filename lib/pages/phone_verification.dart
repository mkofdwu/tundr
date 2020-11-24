import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration_info.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/services/auth_service.dart';
import 'package:tundr/widgets/buttons/flat_tile.dart';
import 'package:tundr/widgets/textfields/digit.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';
import 'package:tundr/widgets/pages/page.dart' as page;

class PhoneVerificationPage extends StatefulWidget {
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final List<int> _verificationCode = List<int>.filled(6, null);
  String _verificationId;
  bool _creatingAccount = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => AuthService.sendSMS(
              Provider.of<RegistrationInfo>(context),
              (verificationId) =>
                  setState(() => _verificationId = verificationId),
            ));
  }

  void _onSubmit() async {
    if (!_creatingAccount) {
      setState(() => _creatingAccount = true);
      final success = await AuthService.verifyCodeAndCreateAccount(
        Provider.of<RegistrationInfo>(context),
        _verificationCode,
        _verificationId,
      );

      if (!success) {
        setState(() => _creatingAccount = false);
        await showDialog(
          context: context,
          child: AlertDialog(
            title: Text('User could not be created: result.user is null'),
            titleTextStyle: TextStyle(color: MyPalette.red),
            actions: <Widget>[
              FlatTileButton(
                text: 'Ok',
                color: MyPalette.gold,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: page.Page(
        builder: (context, width, height) => Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(),
              child: Image.asset(
                'assets/images/setup-phone-number-background.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: width * 47 / 375,
              top: height * 105 / 812,
              child: Text(
                'Enter\nverification\ncode',
                style: TextStyle(
                  color: MyPalette.white,
                  fontSize: 40.0,
                  fontFamily: 'Helvetica Neue',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: height * 300 / 812,
              right: width * 40 / 375,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: MyPalette.white, fontSize: 16.0),
                      children: [
                        TextSpan(
                          text: 'A 6-digit verification code was\nsent to ',
                        ),
                        TextSpan(
                          text: Provider.of<RegistrationInfo>(context)
                              .phoneNumber,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text(
                        "Didn't receive the code?",
                        style:
                            TextStyle(color: MyPalette.white, fontSize: 14.0),
                      ),
                      SizedBox(width: 5.0),
                      GestureDetector(
                        child: Text(
                          'Resend SMS',
                          style:
                              TextStyle(color: MyPalette.gold, fontSize: 14.0),
                        ),
                        onTap: () {
                          AuthService.sendSMS(
                            Provider.of<RegistrationInfo>(context),
                            (verificationId) => setState(
                                () => _verificationId = verificationId),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: width * 35 / 375,
              top: height * 431 / 812,
              child: Row(
                children: <Widget>[
                  DigitEntry(
                    autoFocus: true,
                    onChanged: (digit) =>
                        setState(() => _verificationCode[0] = digit),
                  ),
                  SizedBox(width: 5.0),
                  DigitEntry(
                    onChanged: (digit) =>
                        setState(() => _verificationCode[1] = digit),
                  ),
                  SizedBox(width: 5.0),
                  DigitEntry(
                    onChanged: (digit) =>
                        setState(() => _verificationCode[2] = digit),
                  ),
                  SizedBox(width: 5.0),
                  DigitEntry(
                    onChanged: (digit) =>
                        setState(() => _verificationCode[3] = digit),
                  ),
                  SizedBox(width: 5.0),
                  DigitEntry(
                    onChanged: (digit) =>
                        setState(() => _verificationCode[4] = digit),
                  ),
                  SizedBox(width: 5.0),
                  DigitEntry(
                    moveFocus: false,
                    onChanged: (digit) {
                      setState(() => _verificationCode[5] = digit);
                      _onSubmit();
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              left: width * 179 / 375,
              bottom: 20.0,
              child: NextPageArrow(onNextPage: _onSubmit),
            ),
          ],
        ),
      ),
    );
  }
}
