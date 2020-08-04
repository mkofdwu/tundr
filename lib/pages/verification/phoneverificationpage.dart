import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/registrationinfo.dart';
import 'package:tundr/services/databaseservice.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/widgets/buttons/flattilebutton.dart';
import 'package:tundr/widgets/textfields/digitentry.dart';
import 'package:tundr/widgets/nextpagearrow.dart';
import 'package:tundr/widgets/pages/page.dart' as page;

class PhoneVerificationPage extends StatefulWidget {
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final List<int> _verificationCode = List<int>.filled(6, null);
  String _verificationId;
  bool _creatingAccount =
      false; // whether the account is currently being created

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _sendSMS());
  }

  void _createAccount(AuthCredential credential) async {
    print("CREATING ACCOUNT");
    if (!_creatingAccount) {
      setState(() => _creatingAccount = true);
      try {
        final info = Provider.of<RegistrationInfo>(context);
        final result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: "${info.username}@example.com", password: info.password);
        if (result.user == null) {
          setState(() => _creatingAccount = false);
        } else {
          // TODO: TEST if this still works
          info.uid = result.user.uid;
          await DatabaseService.createAccount(info);
          result.user.updatePhoneNumberCredential(credential);
        }

        // AuthResult result = await FirebaseAuth.instance.signInWithCredential(
        //     credential); // after signing in streambuilder rebuilds
        // if (result.user == null) {
        //   setState(() => _creatingAccount = false);
        // } else {
        //   print("context: $context");
        //   info.uid = result.user.uid;
        //   await DatabaseService.createAccount(info);

        //   // FirebaseAuth.instance.currentUser();

        //   // AuthService.createAccount(result.user, info);
        //   // result.user.updateEmail("${info.username}@example.com");
        //   // result.user.updatePassword(info.password);
        //   result.user.updatePhoneNumberCredential(credential);
        //   (await FirebaseAuth.instance.currentUser())
        //       .updateEmail("${info.username}@example.com");
        //   (await FirebaseAuth.instance.currentUser())
        //       .updatePassword(info.password)
        //       .then((_) => FirebaseAuth.instance.signInWithEmailAndPassword(
        //             email: "${info.username}@example.com",
        //             password: info.password,
        //           ));
        // }
      } on PlatformException catch (exception) {
        FirebaseAuth.instance.signOut(); // FUTURE: temporary fix
        setState(() {
          _creatingAccount = false;
        });
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text(exception.message),
            titleTextStyle: TextStyle(color: AppColors.red),
            actions: <Widget>[
              FlatTileButton(
                text: "Ok",
                color: AppColors.gold,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  _verifyCode() {
    print(_verificationCode);
    if (!_verificationCode.contains(null)) {
      AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId,
        smsCode: _verificationCode.join(),
      );
      if (credential != null) {
        print("manually verified code, creating account");
        _createAccount(credential);
      }
    }
  }

  _sendSMS() {
    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: Provider.of<RegistrationInfo>(context).phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (AuthCredential credential) {
        print("code auto retrieved, creating account");
        _createAccount(credential);
      },
      verificationFailed: (AuthException exception) =>
          print("verification failed: " + exception.message),
      codeSent: (String verificationId, [int]) {
        print("code sent: " + verificationId);
        setState(() => _verificationId = verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("code auto retrieval timeout");
        setState(() => _verificationId = verificationId);
      },
    );
  }

  // _nextPage() {
  //   Navigator.push(
  //     context,
  //     PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => SetupThemePage(),
  //       transitionsBuilder: (context, animation1, animation2, child) {
  //         return SlideTransition(
  //           position: Tween<Offset>(
  //             begin: Offset(0.0, 1.0),
  //             end: Offset(0.0, 0.0),
  //           ).animate(animation1),
  //           child: child,
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: page.Page(
        builder: (context, width, height) => Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(),
              child: Image.asset(
                "assets/images/setup-phone-number-background.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: width * 47 / 375,
              top: height * 105 / 812,
              child: Text(
                "Enter\nverification\ncode",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 40.0,
                  fontFamily: "Helvetica Neue",
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
                      style: TextStyle(color: AppColors.white, fontSize: 16.0),
                      children: [
                        TextSpan(
                          text: "A 6-digit verification code was\nsent to ",
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
                            TextStyle(color: AppColors.white, fontSize: 14.0),
                      ),
                      SizedBox(width: 5.0),
                      GestureDetector(
                        child: Text(
                          "Resend SMS",
                          style:
                              TextStyle(color: AppColors.gold, fontSize: 14.0),
                        ),
                        onTap: _sendSMS,
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
                      _verifyCode();
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              left: width * 179 / 375,
              bottom: 20.0,
              child: NextPageArrow(onNextPage: _verifyCode),
            ),
          ],
        ),
      ),
    );
  }
}
