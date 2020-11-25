import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tundr/widgets/pages/page.dart' as page;

class ScrollDownPage extends StatelessWidget {
  final Color color;
  final bool canScrollUp;
  final bool canScrollDown;
  final Widget Function(BuildContext, double, double) builder;
  final Function onScrollDown;

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
        if (details.delta.dy < -2.0 && canScrollDown) {
          onScrollDown();
        } else if (details.delta.dy > 2.0 && canScrollUp) {
          Navigator.pop(context);
        }
      },
    );
  }
}
