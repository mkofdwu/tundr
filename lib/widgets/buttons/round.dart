import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class MyRoundButton extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final Color backgroundColor;
  final Function onTap;

  MyRoundButton({
    Key key,
    @required this.width,
    @required this.height,
    @required this.child,
    this.backgroundColor = MyPalette.black,
    @required this.onTap,
  }) : super(key: key);

  @override
  _MyRoundButtonState createState() => _MyRoundButtonState();
}

class _MyRoundButtonState extends State<MyRoundButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        height: widget.height,
        transform:
            _pressed ? Matrix4.translationValues(0, 4, 0) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius:
              BorderRadius.circular(min(widget.width, widget.height) / 2),
          boxShadow: [
            _pressed ? MyPalette.primaryShadow : MyPalette.secondaryShadow
          ],
        ),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}
