import "package:flutter/material.dart";
import 'package:tundr/models/personalinfofield.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/utils/constants/enums/personalinfotype.dart';
import 'package:tundr/pages/personalinfo/numberfieldpage.dart';
import 'package:tundr/pages/personalinfo/radiogroupfieldpage.dart';
import 'package:tundr/pages/personalinfo/sliderfieldpage.dart';
import 'package:tundr/pages/personalinfo/textfieldpage.dart';
import 'package:tundr/pages/personalinfo/textlistfieldpage.dart';
import 'package:tundr/utils/constants/personalinfofields.dart';
import 'package:tundr/utils/fromtheme.dart';

class PersonalInfoFieldButton extends StatelessWidget {
  final String fieldName;
  final dynamic value;
  final Function(dynamic) onChanged;

  PersonalInfoFieldButton({
    Key key,
    @required this.fieldName,
    this.value,
    @required this.onChanged,
  }) : super(key: key);

  _editPersonalInfo(BuildContext context) async {
    PersonalInfoField field =
        PersonalInfoField.fromMap(fieldName, personalInfoFields[fieldName]);
    onChanged(await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) {
          print(value);
          switch (field.type) {
            case PersonalInfoType.numInput:
              return NumberFieldPage(field: field, value: value);
            case PersonalInfoType.textInput:
              return TextFieldPage(field: field, value: value);
            case PersonalInfoType.slider:
              return SliderFieldPage(field: field, value: value);
            case PersonalInfoType.radioGroup:
              return RadioGroupFieldPage(field: field, value: value);
            case PersonalInfoType.textList:
              return TextListFieldPage(
                field: field,
                value: value == null ? null : List<String>.from(value),
              );
            default:
              throw Exception("Invalid personal info type: ${field.type}");
          }
        },
        transitionsBuilder: (context, animation1, animation2, child) {
          return FadeTransition(
              opacity: animation1, child: child); // DESIGN: transition
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            fieldName,
            style: TextStyle(fontSize: 16.0),
          ),
          GestureDetector(
            child: Row(
              children: <Widget>[
                if (value != null)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 100.0),
                    child: Text(
                      value is List ? value.join(", ") : value.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                Icon(
                  Icons.arrow_forward_ios, // DESIGN: replace icon?
                  size: 20.0,
                  color: fromTheme(
                    context,
                    dark: AppColors.white,
                    light: AppColors.black,
                  ),
                ),
              ],
            ),
            onTap: () => _editPersonalInfo(context),
          ),
        ],
      ),
    );
  }
}
