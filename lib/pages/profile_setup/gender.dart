import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/enums/gender.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/pages/profile_setup/profile_pic.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/enums/app_theme.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';
import 'package:tundr/widgets/radio_groups/tile.dart';

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
    if (Provider.of<RegistrationInfo>(context).gender != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              SetupProfilePicPage(),
          transitionsBuilder: (context, animation1, animation2, child) {
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
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SafeArea(
        child: Material(
          color: AppColors.black,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gender',
                    style: TextStyle(color: AppColors.white, fontSize: 40.0),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: TileRadioGroup(
                    theme: AppTheme.dark,
                    options: ['Male', 'Female'],
                    selected: genderToString[
                        Provider.of<RegistrationInfo>(context).gender],
                    onChanged: (option) => setState(() =>
                        Provider.of<RegistrationInfo>(context).gender =
                            stringToGender[option]),
                  ),
                ),
                SizedBox(height: 20.0),
                NextPageArrow(onNextPage: _nextPage),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dy < -1.0) {
          _nextPage();
        } else if (details.delta.dy > 1.0) Navigator.pop(context);
      },
    );
  }
}
