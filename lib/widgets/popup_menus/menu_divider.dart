import 'package:flutter/material.dart';

class MenuDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 70,
        height: 2,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
