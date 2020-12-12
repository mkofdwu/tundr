import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:tundr/constants/my_palette.dart';

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..lineTo(0, size.height)
        ..lineTo(size.height * pow(0.75, 0.5), size.height / 2)
        ..lineTo(0, 0),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(TrianglePainter oldTriangle) => false;
}

class Triangle extends StatelessWidget {
  final double size;

  Triangle({Key key, this.size = 40}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(color: MyPalette.white),
      child: Container(
        width: size * pow(0.75, 0.5),
        height: size,
      ),
    );
  }
}
