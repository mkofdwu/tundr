import 'package:flutter/widgets.dart';
import 'package:tundr/constants/my_palette.dart';

class MenuDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      height: 2.0,
      color: MyPalette.black,
    );
  }
}
