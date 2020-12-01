import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class SeparatePageSettingField extends StatelessWidget {
  final String title;
  final Function onNextPage;

  SeparatePageSettingField({Key key, this.title, this.onNextPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: MyPalette.gold,
              fontSize: 20,
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: MyPalette.gold),
        ],
      ),
      onTap: onNextPage,
    );
  }
}
