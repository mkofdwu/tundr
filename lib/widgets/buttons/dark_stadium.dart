import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class DarkStadiumButton extends StatefulWidget {
  final Widget child;
  final Function onTap;

  const DarkStadiumButton({this.child, this.onTap});

  @override
  _DarkStadiumButtonState createState() => _DarkStadiumButtonState();
}

class _DarkStadiumButtonState extends State<DarkStadiumButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Transform.scale(
        scale: _pressed ? 0.95 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          decoration: BoxDecoration(
            color: MyPalette.black,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [MyPalette.secondaryShadow],
          ),
          child: Center(
            child: widget.child,
          ),
        ),
      ),
      onTapDown: (details) {
        setState(() => _pressed = true);
      },
      onTapUp: (details) {
        setState(() => _pressed = false);
        widget.onTap();
      },
    );
  }
}
