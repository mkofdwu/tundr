import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/utils/from_theme.dart';

class MenuOption extends StatelessWidget {
  final String text;
  final Function onPressed;

  MenuOption({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.centerRight,
          child: Text(text, style: TextStyle(fontSize: 18)),
        ),
        onTap: onPressed,
      ),
    );
  }
}

class MenuDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        width: 70,
        height: 2,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: children,
        ),
      ),
    );
  }
}
