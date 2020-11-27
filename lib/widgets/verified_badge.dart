import 'package:flutter/material.dart';

class VerifiedBadge extends StatelessWidget {
  final Color color;

  const VerifiedBadge({this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Tooltip(
        message: 'verified user',
        child: Icon(
          Icons.verified_user,
          color: color ?? Theme.of(context).accentColor,
          semanticLabel: 'verified user',
        ),
      ),
    );
  }
}
