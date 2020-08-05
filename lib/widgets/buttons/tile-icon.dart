import "package:flutter/material.dart";
import 'package:tundr/constants/colors.dart';

class TileIconButton extends StatefulWidget {
  final double width;
  final double height;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Function onPressed;

  TileIconButton({
    Key key,
    this.width = 50.0,
    this.height = 50.0,
    @required this.icon,
    this.iconSize = 30.0,
    this.iconColor,
    this.iconBackgroundColor,
    @required this.onPressed,
  }) : super(key: key);

  @override
  _TileIconButtonState createState() => _TileIconButtonState();
}

class _TileIconButtonState extends State<TileIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: widget.width,
        height: widget.width,
        color: _pressed ? (widget.iconBackgroundColor ?? AppColors.gold) : null,
        child: Icon(
          widget.icon,
          size: widget.iconSize,
          color: _pressed
              ? AppColors.white
              : widget.iconColor ?? Theme.of(context).accentColor,
        ),
      ),
      onTapDown: (TapDownDetails details) => setState(
          () => _pressed = true), // FUTURE: animate fade / grow transition?
      onTapUp: (TapUpDetails details) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
    );
  }
}
