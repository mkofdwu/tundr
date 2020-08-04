import 'package:flutter/widgets.dart';
import 'package:tundr/utils/constants/colors.dart';

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..lineTo(0.0, size.height)
        ..lineTo(size.width, size.height / 2)
        ..lineTo(0.0, 0.0),
      Paint()..color = color,
    );
  }

  @override
  shouldRepaint(TrianglePainter oldTriangle) => false;
}

class Triangle extends StatelessWidget {
  final double size;

  Triangle({Key key, this.size = 30.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TrianglePainter(color: AppColors.white),
      child: Container(
        width: size,
        height: size,
      ),
    );
  }
}
