import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tundr/constants/personal_info_fields.dart';
import 'package:tundr/pages/personal_info/widgets/personal_info_field_button.dart';

class PersonalInfoList extends StatelessWidget {
  final Map<String, dynamic> personalInfo;
  final Function(String, dynamic) onChanged;

  const PersonalInfoList(
      {Key key, @required this.personalInfo, @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.from(
        personalInfoFields.keys.map(
          (fieldName) => PersonalInfoFieldButton(
            fieldName: fieldName,
            value: personalInfo.containsKey(fieldName)
                ? personalInfo[fieldName]
                : null,
            onChanged: (newValue) => onChanged(fieldName, newValue),
          ),
        ),
      ),
    );
  }
}
