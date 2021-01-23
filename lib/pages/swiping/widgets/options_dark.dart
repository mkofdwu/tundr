import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class SwipingOptionsDark extends StatelessWidget {
  final bool canUndo;
  final Function onLike;
  final Function onNope;
  final Function onUndo;

  SwipingOptionsDark({
    @required this.canUndo,
    @required this.onLike,
    @required this.onNope,
    @required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
            GestureDetector(
              child: Icon(Icons.close, size: 30),
              onTap: onNope,
            ),
          ] +
          (canUndo
              ? [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 10, right: 20),
                    child: Container(
                      width: 2,
                      height: 60,
                      color: MyPalette.gold,
                    ),
                  ),
                  GestureDetector(
                    key: ValueKey('undoBtn'),
                    child: Icon(Icons.undo, size: 30),
                    onTap: onUndo,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Container(
                      width: 2,
                      height: 60,
                      color: MyPalette.gold,
                    ),
                  ),
                ]
              : [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Container(
                      width: 2,
                      height: 60,
                      color: MyPalette.gold,
                    ),
                  ),
                ]) +
          [
            GestureDetector(
              child: Icon(Icons.done, size: 30),
              onTap: onLike,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Container(
                  width: 2,
                  height: 60,
                  color: MyPalette.gold,
                )),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/settings/filters'),
              child: Icon(Icons.filter_alt),
            ),
          ],
    );
  }
}
