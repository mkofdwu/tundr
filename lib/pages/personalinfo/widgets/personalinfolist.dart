import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/providerdata.dart';
import 'package:tundr/utils/constants/personalinfofields.dart';
import 'package:tundr/pages/personalinfo/widgets/personalinfofieldbutton.dart';

class PersonalInfoList extends StatelessWidget {
  final Function(String, dynamic) onChanged;

  PersonalInfoList({Key key, @required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userPersonalInfo =
        Provider.of<ProviderData>(context).user.personalInfo;
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
