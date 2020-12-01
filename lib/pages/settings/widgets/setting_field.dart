import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

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
                color: MyPalette.gold,
                fontSize: 20,
              ),
            ),
            onEdit == null
                ? SizedBox.shrink()
                : GestureDetector(
                    child: Icon(
                      Icons.edit,
                      color: MyPalette.gold,
                    ),
                    onTap: onEdit,
                  ),
          ],
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: child,
        ),
      ],
    );
  }
}
