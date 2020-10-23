import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/constants/personal_info_fields.dart';
import 'package:tundr/pages/personal_info/widgets/personal_info_field_button.dart';

class PersonalInfoList extends StatelessWidget {
  final Function(String, dynamic) onChanged;

  PersonalInfoList({Key key, @required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userPersonalInfo =
        Provider.of<CurrentUser>(context).user.personalInfo;
    return Column(
      children: List<Widget>.from(
        personalInfoFields.keys.map(
          (fieldName) => PersonalInfoFieldButton(
            fieldName: fieldName,
            value: userPersonalInfo.containsKey(fieldName)
                ? userPersonalInfo[fieldName]
                : null,
            onChanged: (newValue) => onChanged(fieldName, newValue),
          ),
        ),
      ),
    );
  }
}
