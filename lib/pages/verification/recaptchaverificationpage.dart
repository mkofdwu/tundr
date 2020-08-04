import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/registrationinfo.dart';
import 'package:tundr/services/databaseservice.dart';
import 'package:tundr/widgets/pages/scrolldownpage.dart';
import 'package:tundr/widgets/textfields/digitentry.dart';
import 'package:tundr/widgets/textfields/digitentrycontroller.dart';

class RecaptchaVerificationPage extends StatefulWidget {
  @override
  _RecaptchaVerificationPageState createState() =>
      _RecaptchaVerificationPageState();
}

class _RecaptchaVerificationPageState extends State<RecaptchaVerificationPage> {
  List<int> _verificationCode;
  List<int> _enteredVerificationCode = List<int>.filled(6,
      null); // FUTURE: FIXME: I was too lazy to remove this, but I should probably have come up with a better solution than the one below.
  // FUTURE: FIXME: come up with a better solution
  final DigitEntryController _digit1Controller = DigitEntryController();
  final DigitEntryController _digit2Controller = DigitEntryController();
  final DigitEntryController _digit3Controller = DigitEntryController();
  final DigitEntryController _digit4Controller = DigitEntryController();
  final DigitEntryController _digit5Controller = DigitEntryController();
  final DigitEntryController _digit6Controller = DigitEntryController();

  @override
  void initState() {
    super.initState();
    final rnd = Random();
    _verificationCode = List<int>.generate(6, (index) => rnd.nextInt(10));
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDownPage(
      builder: (context, width, height) {
        return Stack(
          children: <Widget>[
            Positioned(
              left: 55 * width / 375,
              top: 95 * height / 812,
              width: 250.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Temporary verification",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                      "phone authentication is not supported in flutter web yet, this is a temporary verification method."),
                  SizedBox(height: 10.0),
                  Text(
                    "Enter the digits: ${_verificationCode.join()}",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 425 * height / 812,
              right: 35 * width / 375,
              child: Row(
                children: <Widget>[
                  DigitEntry(
                    autoFocus: true,
                    controller: _digit1Controller,
                    onChanged: (digit) =>
                        setState(() => _enteredVerificationCode[0] = digit),
                  ),
                  SizedBox(width: 5.0),
                  DigitEntry(
                    controller: _digit2Controller,
                    onChanged: (digit) =>
                        setState(() => _enteredVerificationCode[1] = digit),
                  ),
                  SizedBox(width: 5.0),
                  DigitEntry(
                    controller: _digit3Controller,
                    onChanged: (digit) =>
                        setState(() => _enteredVerificationCode[2] = digit),
                  ),
                  SizedBox(width: 5.0),
                  DigitEntry(
                    controller: _digit4Controller,
                    onChanged: (digit) =>
                        setState(() => _enteredVerificationCode[3] = digit),
                  ),
                  SizedBox(width: 5.0),
                  DigitEntry(
                    controller: _digit5Controller,
                    onChanged: (digit) =>
                        setState(() => _enteredVerificationCode[4] = digit),
                  ),
                  SizedBox(width: 5.0),
                  DigitEntry(
                    controller: _digit6Controller,
                    moveFocus: false,
                    onChanged: (digit) {
                      setState(() => _enteredVerificationCode[5] = digit);
                      _verifyCode();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
      onNextPage: _verifyCode,
    );
  }

  Future<void> _verifyCode() async {
    if (listEquals(_enteredVerificationCode, _verificationCode)) {
      // create account
      try {
        final info = Provider.of<RegistrationInfo>(context);
        AuthResult result =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "${info.username}@example.com",
          password: info.password,
        );
        print("firebase auth created user");
        assert(result.user != null);
        info.uid = result.user.uid;
        // await DatabaseService.createAccount(info);
        // Navigator.push(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (context, animation1, animation2) =>
        //         SetupThemePage(),
        //     transitionsBuilder: (context, animation1, animation2, child) =>
        //         SlideTransition(
        //       position: Tween<Offset>(
        //         begin: Offset(0.0, 1.0),
        //         end: Offset(0.0, 0.0),
        //       ).animate(animation1),
        //       child: child,
        //     ),
        //   ),
        // );
      } catch (exception) {
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text(exception.runtimeType.toString()),
            content: Text(exception.message),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Verification Failed"),
          content: Text("Please enter the digits correctly"),
          actions: <Widget>[
            FlatButton(
              child: Text("Retry"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ).then((_) {
        setState(() {
          final rnd = Random();
          _verificationCode = List<int>.generate(6, (index) => rnd.nextInt(10));
          _enteredVerificationCode = List<int>.filled(6, null);
          _digit1Controller.clear();
          _digit2Controller.clear();
          _digit3Controller.clear();
          _digit4Controller.clear();
          _digit5Controller.clear();
          _digit6Controller.clear();
        });
      });
    }
  }
}
