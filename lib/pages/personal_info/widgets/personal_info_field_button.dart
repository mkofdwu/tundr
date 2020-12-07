import 'package:flutter/material.dart';
import 'package:tundr/models/personal_info_field.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/personal_info_type.dart';
import 'package:tundr/pages/personal_info/number_field.dart';
import 'package:tundr/pages/personal_info/radio_group_field.dart';
import 'package:tundr/pages/personal_info/slider_field.dart';
import 'package:tundr/pages/personal_info/text_field.dart';
import 'package:tundr/pages/personal_info/text_list_field.dart';
import 'package:tundr/constants/personal_info_fields.dart';
import 'package:tundr/utils/from_theme.dart';

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

  void _editPersonalInfo(BuildContext context) async {
    final field =
        PersonalInfoField.fromMap(fieldName, personalInfoFields[fieldName]);
    onChanged(await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
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
            throw Exception('Invalid personal info type: ${field.type}');
        }
      }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            fieldName,
            style: TextStyle(fontSize: 16),
          ),
          GestureDetector(
            child: Row(
              children: <Widget>[
                if (value != null)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Text(
                      value is List ? value.join(', ') : value.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                Icon(
                  Icons.arrow_forward_ios, // DESIGN: replace icon?
                  size: 20,
                  color: fromTheme(
                    context,
                    dark: MyPalette.white,
                    light: MyPalette.black,
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
