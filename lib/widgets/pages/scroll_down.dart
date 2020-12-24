import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tundr/widgets/pages/page.dart' as page;

// ignore: must_be_immutable
class ScrollDownPage extends StatelessWidget {
  final Color color;
  final bool canScrollUp;
  final bool canScrollDown;
  final Widget Function(BuildContext, double, double) builder;
  final Function onScrollDown;
  bool _dragTriggeredFunctionOnce = false;

  ScrollDownPage({
    Key key,
    this.color,
    this.canScrollUp = true,
    this.canScrollDown = true,
    @required this.builder,
    @required this.onScrollDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: page.Page(
        color: color,
        builder: builder,
      ),
      onVerticalDragUpdate: (details) {
        if (_dragTriggeredFunctionOnce) return;
        if (details.delta.dy < -5 && canScrollDown) {
          onScrollDown();
          _dragTriggeredFunctionOnce = true;
        } else if (details.delta.dy > 5 && canScrollUp) {
          Navigator.pop(context);
          _dragTriggeredFunctionOnce = true;
        }
      },
      onVerticalDragStart: (details) {
        _dragTriggeredFunctionOnce = false; // reset when first dragging
      },
    );
  }
}
