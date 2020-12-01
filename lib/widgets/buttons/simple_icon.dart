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
    this.size = 30,
    @required this.onPressed,
  }) : super(key: key);

  @override
  _SimpleIconButtonState createState() => _SimpleIconButtonState();
}

class _SimpleIconButtonState extends State<SimpleIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
              Icon(
                widget.icon,
                size: widget.size,
                color: _pressed ? MyPalette.gold : widget.color,
              ),
            ] +
            (widget.label.isEmpty
                ? []
                : [
                    SizedBox(height: 10),
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: _pressed ? MyPalette.gold : widget.color,
                        fontSize: 16,
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
