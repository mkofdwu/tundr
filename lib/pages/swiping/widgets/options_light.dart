import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class SwipingOptionsLight extends StatelessWidget {
  final bool canUndo;
  final Function onLike;
  final Function onNope;
  final Function onUndo;

  SwipingOptionsLight({
    @required this.canUndo,
    @required this.onLike,
    @required this.onNope,
    @required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(width: 40),
        GestureDetector(
          child: Container(
            width: 70,
            height: 70,
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: MyPalette.gold,
              shadows: [MyPalette.primaryShadow],
            ),
            child: Icon(
              Icons.close,
              color: MyPalette.white,
              size: 30,
            ),
          ),
          onTap: onNope,
        ),
        canUndo
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                  key: ValueKey('undoBtn'),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      color: MyPalette.white,
                      shadows: [MyPalette.primaryShadow],
                    ),
                    child: Icon(Icons.undo, color: MyPalette.black, size: 24),
                  ),
                  onTap: onUndo,
                ),
              )
            : SizedBox(width: 50),
        GestureDetector(
          child: Container(
            width: 70,
            height: 70,
            decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: MyPalette.gold,
              shadows: [MyPalette.primaryShadow],
            ),
            child: Icon(
              Icons.done,
              color: MyPalette.white,
              size: 30,
            ),
          ),
          onTap: onLike,
        ),
        SizedBox(width: 10),
        SizedBox(
          height: 70,
          child: Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              child: Container(
                width: 30,
                height: 30,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: MyPalette.grey,
                  shadows: [MyPalette.primaryShadow],
                ),
                child: Icon(
                  Icons.filter_alt,
                  color: MyPalette.white,
                  size: 16,
                ),
              ),
              onTap: () => Navigator.pushNamed(context, '/settings/filters'),
            ),
          ),
        ),
      ],
    );
  }
}
