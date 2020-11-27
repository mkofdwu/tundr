import 'package:flutter/material.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';

class MyBackButton extends StatelessWidget {
  final Color iconColor;

  const MyBackButton({this.iconColor});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: TileIconButton(
        icon: Icons.arrow_back,
        iconColor: iconColor,
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
