import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class SettingField extends StatelessWidget {
  final String title;
  final Widget child;
  final Function onEditOrSubmit;
  final bool isEditing;

  SettingField({
    Key key,
    @required this.title,
    @required this.child,
    this.onEditOrSubmit,
    this.isEditing,
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
            onEditOrSubmit == null
                ? SizedBox.shrink()
                : GestureDetector(
                    child: Icon(
                      isEditing ? Icons.done : Icons.edit,
                      color: MyPalette.gold,
                    ),
                    onTap: onEditOrSubmit,
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
