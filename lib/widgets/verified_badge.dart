import 'package:flutter/material.dart';

class VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'verified user',
      child: Icon(
        Icons.verified_user,
        color: Theme.of(context).accentColor,
        semanticLabel: 'verified user',
      ),
    );
  }
}
