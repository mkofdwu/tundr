import 'package:flutter/material.dart';

class ReplyGesture extends StatefulWidget {
  final Widget child;
  final Function onReply;
  final bool accountForWidth;

  ReplyGesture({
    @required this.child,
    @required this.onReply,
    @required this.accountForWidth, // equal to !message.fromMe
  });

  @override
  _ReplyGestureState createState() => _ReplyGestureState();
}

class _ReplyGestureState extends State<ReplyGesture> {
  static const double _climax = 100;
  double _horizontalDragStart;
  double _horizontalDragDist = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        _horizontalDragStart = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _horizontalDragDist =
              details.globalPosition.dx - _horizontalDragStart;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_horizontalDragDist > _climax) widget.onReply();
        setState(() {
          _horizontalDragDist = 0;
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_horizontalDragDist > _climax) Icon(Icons.reply, size: 30),
            Expanded(
              child: Transform.translate(
                offset: Offset(
                  _horizontalDragDist > _climax && widget.accountForWidth
                      ? _horizontalDragDist - 30
                      : _horizontalDragDist,
                  0,
                ),
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
