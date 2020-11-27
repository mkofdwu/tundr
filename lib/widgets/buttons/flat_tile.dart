import 'package:flutter/material.dart';
import 'package:tundr/utils/from_theme.dart';

class FlatTileButton extends StatefulWidget {
  final String text;
  final Color color;
  final Function onTap;

  FlatTileButton({
    Key key,
    @required this.text,
    @required this.color,
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
          borderRadius: fromTheme(context, light: BorderRadius.circular(8)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          widget.text,
          style: TextStyle(
            color: _pressed ? Theme.of(context).primaryColor : widget.color,
            fontSize: 18,
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
