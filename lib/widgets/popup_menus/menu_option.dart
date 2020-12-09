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
    return Material(
      child: InkWell(
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerRight,
          child: Text(text, style: TextStyle(fontSize: 18)),
        ),
        onTap: onPressed,
      ),
    );
  }
}
