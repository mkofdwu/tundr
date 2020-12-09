import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class MyTextButton extends StatefulWidget {
  final String text;
  final Function onTap;

  MyTextButton({@required this.text, @required this.onTap});

  @override
  _MyTextButtonState createState() => _MyTextButtonState();
}

class _MyTextButtonState extends State<MyTextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: 20,
          color: _pressed
              ? MyPalette.gold
              : Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
    );
  }
}
