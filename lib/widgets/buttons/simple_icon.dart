import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class SimpleIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double size;
  final Function onPressed;

  SimpleIconButton({
    Key key,
    @required this.icon,
    this.label = '',
    this.color,
    this.size = 40.0,
    @required this.onPressed,
  }) : super(key: key);

  @override
  _SimpleIconButtonState createState() => _SimpleIconButtonState();
}

class _SimpleIconButtonState extends State<SimpleIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    // ANIMATION: wrap in animatedcontainer?
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
              Icon(
                widget.icon,
                size: widget.size,
                color: _pressed
                    ? MyPalette.gold
                    : widget.color ?? Theme.of(context).accentColor,
              ),
            ] +
            (widget.label.isEmpty
                ? []
                : [
                    SizedBox(height: 10.0),
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: _pressed
                            ? MyPalette.gold
                            : widget.color ?? Theme.of(context).accentColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ]),
      ),
      onTapDown: (TapDownDetails details) => setState(() => _pressed = true),
      onTapUp: (TapUpDetails details) {
        widget.onPressed();
        setState(() => _pressed = false);
      },
      onTapCancel: () => setState(() => _pressed = false),
    );
  }
}
