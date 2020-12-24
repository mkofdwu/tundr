import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';

class VerifiedBadge extends StatelessWidget {
  final Color color;
  final double size;

  const VerifiedBadge({this.color = MyPalette.white, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Tooltip(
        message: 'verified user',
        child: Icon(
          Icons.verified_user,
          color: color,
          size: size,
          semanticLabel: 'verified user',
        ),
      ),
    );
  }
}
