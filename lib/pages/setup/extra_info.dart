import 'package:flutter/material.dart';
import 'package:tundr/pages/setup/about_me.dart';
import 'package:tundr/pages/setup/extra_media.dart';
import 'package:tundr/pages/setup/personal_info.dart';
import 'package:tundr/pages/setup/phone_number.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/widgets/buttons/light_tile.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class SetupExtraInfoPage extends StatefulWidget {
  @override
  _SetupExtraInfoPageState createState() => _SetupExtraInfoPageState();
}

class _SetupExtraInfoPageState extends State<SetupExtraInfoPage> {
  void _nextPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            SetupPhoneNumberPage(),
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

  @override
  Widget build(BuildContext context) {
    return ScrollDownPage(
      color: MyPalette.white,
      builder: (context, width, height) => Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
                Text(
                  'Setup extra\ninfo?',
                  style: TextStyle(
                    color: MyPalette.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'You can skip these steps, but they will probably\nincrease your chances of finding a match.',
                  style: TextStyle(
                    color: MyPalette.black,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 50),
              ] +
              [
                ['About me', SetupAboutMePage()],
                ['Extra photos & videos', SetupExtraMediaPage()],
                ['Personal info', SetupPersonalInfoPage()]
              ]
                  .map((labelAndPage) => LightTileButton(
                        child: Text(
                          labelAndPage[0],
                          style: TextStyle(
                            color: MyPalette.black,
                            fontSize: 20,
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => labelAndPage[1]),
                        ),
                      ))
                  .toList() +
              [
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: ScrollDownArrow(
                    dark: false,
                    onNextPage: _nextPage,
                  ),
                ),
              ],
        ),
      ),
      onScrollDown: _nextPage,
    );
  }
}
