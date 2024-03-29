import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/pages/loading.dart';
import 'package:tundr/store/registration_info.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/services/auth_service.dart';
import 'package:tundr/utils/show_error_dialog.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/rebuilder.dart';
import 'package:tundr/widgets/textfields/digit.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class PhoneVerificationPage extends StatefulWidget {
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final List<int> _verificationCode = List<int>.filled(6, null);

  void _onSubmit() async {
    final info = Provider.of<RegistrationInfo>(context, listen: false);
    if (!info.isCreatingAccount) {
      info.isCreatingAccount = true;
      final success = await AuthService.verifyCodeAndCreateAccount(
        info,
        _verificationCode,
      );
      info.isCreatingAccount = false;
      if (success) {
        Rebuilder.rebuild(context);
      } else {
        await showErrorDialog(
          context: context,
          title: 'User could not be created',
        );
      }
    }
  }

  void _sendSMS() => AuthService.sendSMS(
        info: Provider.of<RegistrationInfo>(context, listen: false),
        onVerificationCompleted: (credential) async {
          final info = Provider.of<RegistrationInfo>(context, listen: false);
          info.isCreatingAccount = true;
          final success = await AuthService.createAccount(
              info: info, phoneCredential: credential);
          info.isCreatingAccount = false;
          if (success) {
            Rebuilder.rebuild(context);
          } else {
            await showErrorDialog(
              context: context,
              title: 'User could not be created',
            );
          }
        },
        onVerificationFailed: (exception) {
          showErrorDialog(
            context: context,
            title: 'Failed to create account',
            content: exception.message,
          );
        },
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _sendSMS();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<RegistrationInfo>(context).isCreatingAccount
        ? LoadingPage()
        : ScrollDownPage(
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
                  top: 100,
                  child: Text(
                    'Enter\nverification\ncode',
                    style: TextStyle(
                      color: MyPalette.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  top: height * 330 / 812,
                  right: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style:
                              TextStyle(color: MyPalette.white, fontSize: 16),
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
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Text(
                            "Didn't receive the code?",
                            style:
                                TextStyle(color: MyPalette.white, fontSize: 14),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            child: Text(
                              'Resend SMS',
                              style: TextStyle(
                                  color: MyPalette.gold, fontSize: 14),
                            ),
                            onTap: _sendSMS,
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        child: Row(
                          children: <Widget>[
                            DigitEntry(
                              onChanged: (digit) =>
                                  setState(() => _verificationCode[0] = digit),
                            ),
                            SizedBox(width: 5),
                            DigitEntry(
                              onChanged: (digit) =>
                                  setState(() => _verificationCode[1] = digit),
                            ),
                            SizedBox(width: 5),
                            DigitEntry(
                              onChanged: (digit) =>
                                  setState(() => _verificationCode[2] = digit),
                            ),
                            SizedBox(width: 5),
                            DigitEntry(
                              onChanged: (digit) =>
                                  setState(() => _verificationCode[3] = digit),
                            ),
                            SizedBox(width: 5),
                            DigitEntry(
                              onChanged: (digit) =>
                                  setState(() => _verificationCode[4] = digit),
                            ),
                            SizedBox(width: 5),
                            DigitEntry(
                              moveFocus: false,
                              onChanged: (digit) {
                                setState(() => _verificationCode[5] = digit);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: width * 179 / 375,
                  bottom: 20,
                  child: ScrollDownArrow(onNextPage: _onSubmit),
                ),
              ],
            ),
            canScrollDown: !_verificationCode.contains(null),
            onScrollDown: _onSubmit,
          );
  }
}
