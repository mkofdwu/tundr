import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/enums/gender.dart';
import 'package:tundr/store/registration_info.dart';
import 'package:tundr/pages/setup/profile_pic.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';
import 'package:tundr/widgets/tile_radio_group.dart';

const Map<String, Gender> stringToGender = {
  'Male': Gender.male,
  'Female': Gender.female,
};
const Map<Gender, String> genderToString = {
  Gender.male: 'Male',
  Gender.female: 'Female',
};

class SetupGenderPage extends StatefulWidget {
  @override
  _SetupGenderPageState createState() => _SetupGenderPageState();
}

class _SetupGenderPageState extends State<SetupGenderPage> {
  void _nextPage() {
    if (Provider.of<RegistrationInfo>(context, listen: false).gender != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              SetupProfilePicPage(),
          transitionsBuilder: (context, animation1, animation2, child) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDownPage(
      color: MyPalette.black,
      builder: (context, width, height) => Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Gender',
                  style: TextStyle(
                    color: MyPalette.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: TileRadioGroup(
                theme: ThemeMode.dark,
                options: ['Male', 'Female'],
                selected: genderToString[
                    Provider.of<RegistrationInfo>(context, listen: false)
                        .gender],
                onChanged: (option) => setState(() =>
                    Provider.of<RegistrationInfo>(context, listen: false)
                        .gender = stringToGender[option]),
              ),
            ),
            SizedBox(height: 20),
            ScrollDownArrow(onNextPage: _nextPage),
            SizedBox(height: 20),
          ],
        ),
      ),
      onScrollDown: _nextPage,
    );
  }
}
