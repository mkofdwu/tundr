import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration-info.dart';
import 'package:tundr/pages/phone-verification.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/widgets/scroll-down-arrow.dart';

class SetupPhoneNumberPage extends StatefulWidget {
  @override
  _SetupPhoneNumberPageState createState() => _SetupPhoneNumberPageState();
}

class _SetupPhoneNumberPageState extends State<SetupPhoneNumberPage> {
  final TextEditingController _phoneNumberController = TextEditingController();

  _nextPage() async {
    if (_phoneNumberController.text.length != 8) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Invalid phone number"),
          actions: <Widget>[
            FlatButton(
              child: Text("Retry"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }
    if (await DatabaseService.phoneNumberExists(_phoneNumberController.text)) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Invalid phone number"),
          content: Text(
              "This phone number already has an account associated with it"),
          actions: <Widget>[
            FlatButton(
              child: Text("Retry"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    Provider.of<RegistrationInfo>(context).phoneNumber =
        "+65" + _phoneNumberController.text;
    Navigator.push(
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      child: SafeArea(
        child: Material(
          child: Stack(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: Image.asset(
                  "assets/images/setup-phone-number-background.png",
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: width * 47 / 375,
                top: height * 180 / 812,
                child: Text(
                  "Phone number",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontFamily: "Helvetica Neue",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                left: width * 93 / 375,
                top: height * 230 / 812,
                child: Text(
                  "A verification code will be sent\nto you via SMS.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Positioned(
                left: width * 31 / 375,
                top: height * 339 / 812,
                child: Row(
                  children: <Widget>[
                    Container(
                      // FUTURE: select country code
                      color: AppColors.white,
                      height: 60.0,
                      width: 90.0,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 5.0),
                          Icon(Icons.add, color: AppColors.black, size: 30.0),
                          Text(
                            "65",
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 40.0,
                              fontFamily: "Helvetica Neue",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.0),
                    SizedBox(
                      width: width - 165.0,
                      child: TextField(
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 40.0,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.only(bottom: 5.0),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.white,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.white,
                              width: 5.0,
                            ),
                          ),
                        ),
                        cursorColor: AppColors.white,
                        maxLength: 8,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        controller: _phoneNumberController,
                        onEditingComplete: _nextPage,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                // ANIMATION: idle animation bob up and down
                left: width * 179 / 375,
                bottom: 20.0,
                child: NextPageArrow(onNextPage: _nextPage),
              ),
            ],
          ),
        ),
      ),
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dy < -1.0)
          _nextPage();
        else if (details.delta.dy > 1.0) Navigator.pop(context);
      },
    );
  }
}
