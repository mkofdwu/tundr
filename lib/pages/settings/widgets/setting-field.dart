import "package:flutter/material.dart";
import 'package:tundr/constants/colors.dart';

class SettingField extends StatelessWidget {
  final String title;
  final Widget child;
  final Function onEdit;

  SettingField({
    Key key,
    this.title,
    this.child,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 20.0,
              ),
            ),
            onEdit == null
                ? SizedBox.shrink()
                : GestureDetector(
                    child: Icon(
                      Icons.edit,
                      color: AppColors.gold,
                    ),
                    onTap: onEdit,
                  ),
          ],
        ),
        SizedBox(height: 5.0),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: child,
        ),
      ],
    );
  }
}
