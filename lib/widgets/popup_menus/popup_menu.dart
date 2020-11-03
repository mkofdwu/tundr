import 'package:flutter/widgets.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/utils/from_theme.dart';

class PopupMenu extends StatelessWidget {
  final List<Widget> children;

  PopupMenu({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 150.0,
      decoration: BoxDecoration(
        color: MyPalette.white,
        boxShadow: [MyPalette.secondaryShadow],
        borderRadius: fromTheme(
          context,
          dark: BorderRadius.zero,
          light: BorderRadius.circular(20.0),
        ),
      ),
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      ),
    );
  }
}
