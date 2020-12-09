import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/utils/from_theme.dart';

class PopupMenu extends StatelessWidget {
  final List<Widget> children;

  PopupMenu({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        boxShadow: [MyPalette.secondaryShadow],
        borderRadius: fromTheme(
          context,
          dark: BorderRadius.zero,
          light: BorderRadius.circular(15),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: children,
        ),
      ),
    );
  }
}
