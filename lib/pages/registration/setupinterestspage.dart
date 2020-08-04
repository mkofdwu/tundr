import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/registrationinfo.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/widgets/interests/interestsbrowser.dart';
import 'package:tundr/widgets/buttons/tileiconbutton.dart';

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
    return SafeArea(
      child: Material(
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TileIconButton(
              icon: Icons.arrow_back,
              iconColor: AppColors.black,
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(height: 30.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Interests",
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 40.0,
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Expanded(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(accentColor: AppColors.black),
                        child: InterestsBrowser(
                          interests:
                              Provider.of<RegistrationInfo>(context).interests,
                          customInterests:
                              Provider.of<RegistrationInfo>(context)
                                  .customInterests,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
