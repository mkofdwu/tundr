import "package:flutter/material.dart";
import 'package:tundr/utils/from-theme.dart';

class FlatTileButton extends StatefulWidget {
  final String text;
  final Color color;
  final double padding;
  final Function onTap;

  FlatTileButton({
    Key key,
    @required this.text,
    @required this.color,
    this.padding = 20.0,
    @required this.onTap,
  }) : super(key: key);

  @override
  _FlatTileButtonState createState() => _FlatTileButtonState();
}

class _FlatTileButtonState extends State<FlatTileButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: _pressed ? widget.color : null,
          borderRadius: fromTheme(context, light: BorderRadius.circular(10.0)),
        ),
        padding: EdgeInsets.all(widget.padding),
        child: Text(
          widget.text,
          style: TextStyle(
            color: _pressed ? Theme.of(context).primaryColor : widget.color,
            fontSize: 20.0,
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
      onTapCancel: () => setState(() => _pressed = false),
    );
  }
}
