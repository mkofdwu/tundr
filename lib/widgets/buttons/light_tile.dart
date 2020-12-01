import 'package:flutter/widgets.dart';
import 'package:tundr/constants/my_palette.dart';

class LightTileButton extends StatefulWidget {
  final Color color;
  final Widget child;
  final Function onTap;

  LightTileButton({
    Key key,
    this.color = MyPalette.white,
    @required this.child,
    @required this.onTap,
  }) : super(key: key);

  @override
  _LightTileButtonState createState() => _LightTileButtonState();
}

class _LightTileButtonState extends State<LightTileButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: widget.color,
          boxShadow: _pressed ? null : [MyPalette.primaryShadow],
          borderRadius: BorderRadius.circular(10),
        ),
        child: widget.child,
      ),
      onTapDown: (TapDownDetails details) => setState(() => _pressed = true),
      onTapUp: (TapUpDetails details) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
    );
  }
}
