import 'package:flutter/widgets.dart';
import 'package:tundr/constants/my_palette.dart';

class DarkTileButton extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final Color color;
  final Function onTap;

  DarkTileButton({
    Key key,
    this.width,
    this.height = 60.0,
    @required this.child,
    this.color = MyPalette.gold,
    @required this.onTap,
  }) : super(key: key);

  @override
  _DarkTileButtonState createState() => _DarkTileButtonState();
}

class _DarkTileButtonState extends State<DarkTileButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(20.0),
        color: _pressed ? widget.color : widget.color.withOpacity(0.8),
        child: widget.child,
      ),
      onTapDown: (details) => setState(() => _pressed = true),
      onTapUp: (details) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
    );
  }
}
