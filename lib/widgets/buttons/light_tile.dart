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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        transform:
            _pressed ? Matrix4.translationValues(0, 4, 0) : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.color,
          boxShadow: [
            _pressed ? MyPalette.primaryShadow : MyPalette.secondaryShadow
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: widget.child,
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
