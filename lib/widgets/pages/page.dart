import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  final Color color;
  final Widget Function(BuildContext context, double width, double height)
      builder;

  Page({Key key, this.color, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: LayoutBuilder(
        builder: (context, constraints) =>
            builder(context, constraints.maxWidth, constraints.maxHeight),
      ),
    );
  }
}
