// couldn't think of a better name

import 'package:flutter/widgets.dart';
import 'package:tundr/constants/my_palette.dart';

class SimpleTabBar extends StatefulWidget {
  final Color color;
  final List<String> tabNames;
  final String defaultTab;
  final Function(String) onSelected;

  SimpleTabBar({
    Key key,
    this.color,
    @required this.tabNames,
    @required this.defaultTab,
    this.onSelected,
  }) : super(key: key);

  @override
  _SimpleTabBarState createState() => _SimpleTabBarState();
}

class _SimpleTabBarState extends State<SimpleTabBar> {
  String _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.defaultTab;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.from(widget.tabNames.map((name) {
          if (name == _currentTab) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      color: MyPalette.gold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 50,
                    height: 3,
                    color: MyPalette.gold,
                  )
                ],
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              child: Text(
                name,
                style: TextStyle(color: widget.color, fontSize: 20),
              ),
              onTap: () {
                setState(() => _currentTab = name);
                widget.onSelected(name);
              },
            ),
          );
        })),
      ),
    );
  }
}
