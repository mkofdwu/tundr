import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/store/registration_info.dart';
import 'package:tundr/store/theme_manager.dart';
import 'package:tundr/constants/personal_info_fields.dart';
import 'package:tundr/pages/personal_info/widgets/personal_info_field_button.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';

class SetupPersonalInfoPage extends StatefulWidget {
  @override
  _SetupPersonalInfoPageState createState() => _SetupPersonalInfoPageState();
}

class _SetupPersonalInfoPageState extends State<SetupPersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    final personalInfo =
        Provider.of<RegistrationInfo>(context, listen: false).personalInfo;
    Provider.of<ThemeManager>(context).theme = ThemeMode.dark;
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TileIconButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Personal info',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
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
    );
  }
}
