import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/pages/profile_setup/birthday.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/textfields/tile.dart';

class SetupNamePage extends StatefulWidget {
  @override
  _SetupNamePageState createState() => _SetupNamePageState();
}

class _SetupNamePageState extends State<SetupNamePage> {
  final TextEditingController _nameController = TextEditingController();

  void _nextPage() {
    if (_nameController.text.isNotEmpty) {
      Provider.of<RegistrationInfo>(context).name = _nameController.text;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => SetupBirthdayPage(),
          transitionsBuilder: (context, animation1, animation2, child) {
            return SlideTransition(
              // FUTURE: curved animation (ease out)
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
    _nameController.text = Provider.of<RegistrationInfo>(context).name;
    return ScrollDownPage(
      onScrollDown: _nextPage,
      builder: (context, width, height) {
        return Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              child: RotatedBox(
                quarterTurns: width > height ? -1 : 0,
                child: Image.asset(
                  'assets/images/setup-name-background.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: width * 90 / 375,
              top: height * 400 / 812,
              width: width * 195 / 375,
              child: TileTextField(
                hintText: 'Name',
                controller: _nameController,
                moveFocus: false,
                onEditingComplete: _nextPage,
              ),
            ),
            Positioned(
              left: width * 179 / 375,
              bottom: 20.0,
              child: NextPageArrow(onNextPage: _nextPage),
            ),
          ],
        );
      },
    );
  }
}
