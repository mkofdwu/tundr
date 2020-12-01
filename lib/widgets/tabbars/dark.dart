// FUTURE: implement tabcontroller

import 'package:flutter/widgets.dart';
import 'package:tundr/constants/my_palette.dart';

// FUTURE: remove this
class TabBarDark extends StatefulWidget implements PreferredSizeWidget {
  final List<Widget> tabs;
  final Key defaultTab;
  final Function(Key) onSelected;

  TabBarDark({
    Key key,
    @required this.tabs,
    @required this.defaultTab,
    this.onSelected,
  }) : super(key: key);

  @override
  _TabBarDarkState createState() => _TabBarDarkState();

  @override
  Size get preferredSize => Size.fromHeight(30);
}

class _TabBarDarkState extends State<TabBarDark> {
  Key _currentKey;

  @override
  Widget build(BuildContext context) {
    final tabWidth = MediaQuery.of(context).size.width / widget.tabs.length;
    return Container(child: Row(
      children: List<Widget>.from(widget.tabs.map((tab) {
        if (tab.key == _currentKey) {
          return Container(
            width: tabWidth,
            child: Center(
              child: Column(
                children: <Widget>[
                  tab,
                  SizedBox(height: 10),
                  Container(
                    height: 2,
                    color: MyPalette.gold,
                  ),
                ],
              ),
            ),
          );
        }
        return GestureDetector(
          child: Container(
            width: tabWidth,
            child: Center(child: tab),
          ),
          onTap: () {
            setState(() => _currentKey = tab.key);
            widget.onSelected(tab.key);
          },
        );
      })),
    ));
  }
}
