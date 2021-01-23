import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/pages/setup/phone_number.dart';
import 'package:tundr/store/registration_info.dart';
import 'package:tundr/pages/interests/widgets/interests_browser.dart';
import 'package:tundr/utils/show_info_dialog.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class SetupInterestsPage extends StatefulWidget {
  @override
  _SetupInterestsPageState createState() => _SetupInterestsPageState();
}

class _SetupInterestsPageState extends State<SetupInterestsPage> {
  static const _minInterests = 10;
  static const _maxInterests = 40;

  @override
  Widget build(BuildContext context) {
    return ScrollDownPage(
      builder: (context, width, height) => Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 50),
            Text(
              'Interests',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: InterestsBrowser(
                interests: Provider.of<RegistrationInfo>(context, listen: false)
                    .interests,
                customInterests:
                    Provider.of<RegistrationInfo>(context, listen: false)
                        .customInterests,
                onInterestsChanged: () {},
                onCustomInterestsChanged: () {},
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ScrollDownArrow(
                onNextPage: _nextPage,
              ),
            ),
          ],
        ),
      ),
      onScrollDown: _nextPage,
    );
  }

  void _nextPage() {
    final numInterests =
        Provider.of<RegistrationInfo>(context, listen: false).interests.length;
    if (numInterests < _minInterests) {
      showInfoDialog(
        context: context,
        title: 'Insufficient interests',
        content:
            'Please select at least $_minInterests interests. This will be crucial when people are suggested to you.',
      );
    } else if (numInterests > _maxInterests) {
      showInfoDialog(
        context: context,
        title: 'Too many interests selected',
        content:
            "Unfortunately, you can't select more than $_maxInterests interests.",
      );
    } else {
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
  }
}
