import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/pages/profile_setup/phone_number.dart';
import 'package:tundr/repositories/registration_info.dart';
import 'package:tundr/pages/interests/widgets/interests_browser.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class SetupInterestsPage extends StatefulWidget {
  @override
  _SetupInterestsPageState createState() => _SetupInterestsPageState();
}

class _SetupInterestsPageState extends State<SetupInterestsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SafeArea(
        child: Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 50.0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Interests',
                        style: TextStyle(
                          fontSize: 40.0,
                          fontFamily: 'Helvetica Neue',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Expanded(
                        child: InterestsBrowser(
                          interests:
                              Provider.of<RegistrationInfo>(context).interests,
                          customInterests:
                              Provider.of<RegistrationInfo>(context)
                                  .customInterests,
                          onInterestsChanged: () {},
                          onCustomInterestsChanged: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: NextPageArrow(
                  onNextPage: _nextPage,
                ),
              ),
              SizedBox(height: 30),
            ],
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

  void _nextPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            SetupPhoneNumberPage(),
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
