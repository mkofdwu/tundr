import "package:flutter/widgets.dart";
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/utils/constants/shadows.dart';
import 'package:tundr/utils/fromtheme.dart';

class PopupMenu extends StatelessWidget {
  final List<Widget> children;

  PopupMenu({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 150.0,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [Shadows.secondaryShadow],
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
