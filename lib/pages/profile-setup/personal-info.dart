import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration-info.dart';
import 'package:tundr/repositories/theme-notifier.dart';
import 'package:tundr/enums/apptheme.dart';
import 'package:tundr/constants/personal-info-fields.dart';
import 'package:tundr/pages/personal-info/widgets/personal-info-field-button.dart';
import 'package:tundr/widgets/buttons/tile-icon.dart';

class SetupPersonalInfoPage extends StatefulWidget {
  @override
  _SetupPersonalInfoPageState createState() => _SetupPersonalInfoPageState();
}

class _SetupPersonalInfoPageState extends State<SetupPersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> personalInfo =
        Provider.of<RegistrationInfo>(context).personalInfo;
    Provider.of<ThemeNotifier>(context).theme = AppTheme.dark;
    return SafeArea(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TileIconButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Personal info",
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: List<Widget>.from(personalInfoFields.keys.map(
                  (fieldName) => PersonalInfoFieldButton(
                    fieldName: fieldName,
                    value: personalInfo.containsKey(fieldName)
                        ? personalInfo[fieldName]
                        : null,
                    onChanged: (newValue) =>
                        setState(() => personalInfo[fieldName] = newValue),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}