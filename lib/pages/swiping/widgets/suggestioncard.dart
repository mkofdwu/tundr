import "package:flutter/material.dart";
import "dart:math";

import 'package:tundr/models/user.dart';
import 'package:tundr/widgets/profiletile.dart';

class SuggestionCard extends StatefulWidget {
  final double width;
  final double height;
  final User user;
  final double similarityScore;
  final Function onLike;
  final Function onNope;

  const SuggestionCard({
    Key key,
    this.width,
    this.height,
    @required this.user,
    this.similarityScore,
    @required this.onLike,
    @required this.onNope,
  }) : super(key: key);

  @override
  _SuggestionCardState createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<SuggestionCard> {
  static const double dampingFactor = 0.2;
  static const int climax = 15; // angle at which nope / like is decided

  Offset _initialOffset;
  double _angle = 0.0;

  bool _goingToLike = false;
  bool _goingToNope = false;

  void _reset() => setState(() {
        _angle = 0;
        _goingToLike = false;
        _goingToNope = false;
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Transform.rotate(
        angle: _angle * pi / 180,
        origin: Offset(0, 300),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: <Widget>[
              ProfileTile(
                user: widget.user,
                description: widget.similarityScore == null
                    ? "Unknown similarity"
                    : "Similarity: ${widget.similarityScore}%",
              ),
              _goingToLike
                  ? Positioned(
                      left: 50.0,
                      top: 50.0,
                      child: Transform.rotate(
                        angle: -pi / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.greenAccent),
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "LIKE",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              _goingToNope
                  ? Positioned(
                      top: 50.0,
                      right: 50.0,
                      child: Transform.rotate(
                        angle: pi / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.redAccent),
                          ),
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "NOPE",
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
      onHorizontalDragStart: (DragStartDetails details) {
        _initialOffset = details.globalPosition;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        setState(() {
          _angle =
              (details.globalPosition.dx - _initialOffset.dx) * dampingFactor;
          _goingToLike = _angle > climax;
          _goingToNope = _angle < -climax;
        });
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_goingToLike)
          widget.onLike();
        else if (_goingToNope) widget.onNope();
        _reset();
      },
      onHorizontalDragCancel: _reset,
      onTap: () => Navigator.pushNamed(
        context,
        "userprofile",
        arguments: widget.user,
      ),
    );
  }
}
