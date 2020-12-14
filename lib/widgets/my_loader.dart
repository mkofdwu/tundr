import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor:
          AlwaysStoppedAnimation(Theme.of(context).colorScheme.onPrimary),
    );
  }
}
