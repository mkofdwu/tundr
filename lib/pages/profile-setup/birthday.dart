import "dart:math";

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration-info.dart';
import 'package:tundr/pages/profile-setup/gender.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/widgets/pages/scroll-down.dart';
import 'package:tundr/widgets/textfields/digit.dart';
import 'package:tundr/widgets/scroll-down-arrow.dart';
import 'package:tundr/widgets/textfields/digit-controller.dart';

class SetupBirthdayPage extends StatefulWidget {
  @override
  _SetupBirthdayPageState createState() => _SetupBirthdayPageState();
}

class _SetupBirthdayPageState extends State<SetupBirthdayPage> {
  final _day1Controller = DigitEntryController();
  final _day2Controller = DigitEntryController();
  final _month1Controller = DigitEntryController();
  final _month2Controller = DigitEntryController();
  final _year1Controller = DigitEntryController();
  final _year2Controller = DigitEntryController();
  final _year3Controller = DigitEntryController();
  final _year4Controller = DigitEntryController();
  int _day1, _day2, _month1, _month2, _year1, _year2, _year3, _year4;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      final DateTime birthday = Provider.of<RegistrationInfo>(context).birthday;

      if (birthday != null) {
        setState(() {
          _day1 = birthday.day ~/ 10;
          _day2 = birthday.day % 10;
          _month1 = birthday.month ~/ 10;
          _month2 = birthday.month % 10;
          _year1 = birthday.year ~/ 1000;
          _year2 = birthday.year % 1000 ~/ 100;
          _year3 = birthday.year % 100 ~/ 10;
          _year4 = birthday.year % 10;
        });
        _day1Controller.setDigit(_day1);
        _day2Controller.setDigit(_day2);
        _month1Controller.setDigit(_month1);
        _month2Controller.setDigit(_month2);
        _year1Controller.setDigit(_year1);
        _year2Controller.setDigit(_year2);
        _year3Controller.setDigit(_year3);
        _year4Controller.setDigit(_year4);
      }
    });
  }

  _nextPage() {
    if (_day1 == null ||
        _day2 == null ||
        _month1 == null ||
        _month2 == null ||
        _year1 == null ||
        _year2 == null ||
        _year3 == null ||
        _year4 == null) {
    } else {
      final DateTime birthday = DateTime(
        _year1 * 1000 + _year2 * 100 + _year3 * 10 + _year4,
        _month1 * 10 + _month2,
        _day1 * 10 + _day2,
      );
      if (birthday.isAfter(DateTime.now()))
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              "Invalid birthday",
              style: TextStyle(color: AppColors.red),
            ),
            content: Text("Are you sure you entered your birthday correctly?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Retry"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      else if (DateTime.now().difference(birthday).inDays > 365 * 50)
        showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              "Too old",
              style: TextStyle(color: AppColors.red),
            ),
            content: Text("You can't be above 50 years old"),
            actions: <Widget>[
              FlatButton(
                child: Text("Retry"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      else {
        Provider.of<RegistrationInfo>(context).birthday = birthday;
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => SetupGenderPage(),
            transitionsBuilder: (context, animation1, animation2, child) {
              final Animation curve =
                  CurvedAnimation(parent: animation1, curve: Curves.easeOut);
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, 1.0),
                  end: Offset(0.0, 0.0),
                ).animate(curve),
                child: child,
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDownPage(
      onNextPage: _nextPage,
      builder: (context, width, height) => Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold,
                  AppColors.black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            left: width * 27 / 375,
            top: height * 76 / 812,
            child: Container(
              width: width * 153 / 375,
              height: height * 121 / 812,
              color: AppColors.black,
            ),
          ),
          Positioned(
            left: width * 49 / 375,
            top: height * 137 / 812,
            child: Container(
              width: width * 173 / 375,
              height: height * 117 / 812,
              color: AppColors.white,
            ),
          ),
          Positioned(
            left: width * 98 / 375,
            top: height * 167 / 812,
            child: Text(
              "Birthday",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 40.0,
                fontFamily: "Helvetica Neue",
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: width * 51 / 375,
            top: height * 355 / 812,
            child: Row(
              children: <Widget>[
                DigitEntry(
                  hintChar: "D",
                  validDigits: [0, 1, 2, 3],
                  autoFocus: true,
                  controller: _day1Controller,
                  onChanged: (digit) => setState(() => _day1 = digit),
                ),
                SizedBox(width: 2.0),
                DigitEntry(
                  hintChar: "D",
                  controller: _day2Controller,
                  onChanged: (digit) => setState(() => _day2 = digit),
                ),
              ],
            ),
          ),
          Positioned(
            left: width * 116 / 375,
            top: height * 274 / 812,
            child: Transform.rotate(
              angle: pi / 6,
              child: Container(
                width: 2,
                height: height * 312 / 812,
                color: AppColors.black,
              ),
            ),
          ),
          Positioned(
            left: width * 125 / 375,
            top: height * 414 / 812,
            child: Row(
              children: <Widget>[
                DigitEntry(
                  hintChar: "M",
                  validDigits: [0, 1, 2, 3],
                  controller: _month1Controller,
                  onChanged: (digit) => setState(() => _month1 = digit),
                ),
                SizedBox(width: 2.0),
                DigitEntry(
                  hintChar: "M",
                  controller: _month2Controller,
                  onChanged: (digit) => setState(() => _month2 = digit),
                ),
              ],
            ),
          ),
          Positioned(
            left: width * 197 / 375,
            top: height * 329 / 812,
            child: Transform.rotate(
              angle: pi / 6,
              child: Container(
                width: 2,
                height: height * 312 / 812,
                color: AppColors.black,
              ),
            ),
          ),
          Positioned(
            left: width * 212 / 375,
            top: height * 471 / 812,
            child: Row(
              children: <Widget>[
                DigitEntry(
                  hintChar: "Y",
                  controller: _year1Controller,
                  onChanged: (digit) => setState(() => _year1 = digit),
                ),
                SizedBox(width: 2.0),
                DigitEntry(
                  hintChar: "Y",
                  controller: _year2Controller,
                  onChanged: (digit) => setState(() => _year2 = digit),
                ),
                SizedBox(width: 2.0),
                DigitEntry(
                  hintChar: "Y",
                  controller: _year3Controller,
                  onChanged: (digit) => setState(() => _year3 = digit),
                ),
                SizedBox(width: 2.0),
                DigitEntry(
                  hintChar: "Y",
                  moveFocus: false,
                  controller: _year4Controller,
                  onChanged: (digit) {
                    setState(() => _year4 = digit);
                    FocusScope.of(context).unfocus();
                  },
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
    );
  }
}
