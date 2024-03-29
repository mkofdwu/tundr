import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/numbers.dart';
import 'package:tundr/store/registration_info.dart';
import 'package:tundr/pages/setup/gender.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/utils/show_error_dialog.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/textfields/digit.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';
import 'package:tundr/widgets/textfields/digit_controller.dart';

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
      final birthday =
          Provider.of<RegistrationInfo>(context, listen: false).birthday;

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

  void _nextPage() {
    if (_day1 == null ||
        _day2 == null ||
        _month1 == null ||
        _month2 == null ||
        _year1 == null ||
        _year2 == null ||
        _year3 == null ||
        _year4 == null) {
    } else {
      final birthday = DateTime(
        _year1 * 1000 + _year2 * 100 + _year3 * 10 + _year4,
        _month1 * 10 + _month2,
        _day1 * 10 + _day2,
      );
      if (birthday.isAfter(DateTime.now())) {
        showErrorDialog(
          context: context,
          title: 'Invalid birthday',
          content: 'Are you sure you entered your birthday correctly?',
        );
      } else if (DateTime.now().difference(birthday).inDays >
          365 * maxAllowedAge) {
        showErrorDialog(
          context: context,
          title: 'Too old',
          content: "You can't be above $maxAllowedAge years old",
        );
      } else {
        Provider.of<RegistrationInfo>(context, listen: false).birthday =
            birthday;
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => SetupGenderPage(),
            transitionsBuilder: (context, animation1, animation2, child) {
              final Animation curve =
                  CurvedAnimation(parent: animation1, curve: Curves.easeOut);
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 1),
                  end: Offset(0, 0),
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
      onScrollDown: _nextPage,
      builder: (context, width, height) => Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyPalette.gold,
                  MyPalette.black,
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
              color: MyPalette.black,
            ),
          ),
          Positioned(
            left: width * 49 / 375,
            top: height * 137 / 812,
            child: Container(
              width: width * 173 / 375,
              height: height * 117 / 812,
              color: MyPalette.white,
            ),
          ),
          Positioned(
            left: width * 98 / 375,
            top: height * 167 / 812,
            child: Text(
              'Birthday',
              style: TextStyle(
                color: MyPalette.black,
                fontSize: 40,
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
                  hintChar: 'D',
                  validDigits: [0, 1, 2, 3],
                  controller: _day1Controller,
                  onChanged: (digit) => setState(() => _day1 = digit),
                ),
                SizedBox(width: 2),
                DigitEntry(
                  hintChar: 'D',
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
                color: MyPalette.black,
              ),
            ),
          ),
          Positioned(
            left: width * 125 / 375,
            top: height * 414 / 812,
            child: Row(
              children: <Widget>[
                DigitEntry(
                  hintChar: 'M',
                  validDigits: [0, 1],
                  controller: _month1Controller,
                  onChanged: (digit) => setState(() => _month1 = digit),
                ),
                SizedBox(width: 2),
                DigitEntry(
                  hintChar: 'M',
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
                color: MyPalette.black,
              ),
            ),
          ),
          Positioned(
            left: width * 212 / 375,
            top: height * 471 / 812,
            child: Row(
              children: <Widget>[
                DigitEntry(
                  hintChar: 'Y',
                  controller: _year1Controller,
                  onChanged: (digit) => setState(() => _year1 = digit),
                ),
                SizedBox(width: 2),
                DigitEntry(
                  hintChar: 'Y',
                  controller: _year2Controller,
                  onChanged: (digit) => setState(() => _year2 = digit),
                ),
                SizedBox(width: 2),
                DigitEntry(
                  hintChar: 'Y',
                  controller: _year3Controller,
                  onChanged: (digit) => setState(() => _year3 = digit),
                ),
                SizedBox(width: 2),
                DigitEntry(
                  hintChar: 'Y',
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
            bottom: 20,
            child: ScrollDownArrow(onNextPage: _nextPage),
          ),
        ],
      ),
    );
  }
}
