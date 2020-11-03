import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class MenuOption extends StatelessWidget {
  final String text;
  final Function onPressed;

  MenuOption({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        height: 40.0,
        child: FlatButton(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              text,
              style: TextStyle(
                color: MyPalette.black,
                fontSize: 20.0,
              ),
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
