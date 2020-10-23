import 'package:flutter/widgets.dart';
import 'package:tundr/widgets/pages/page.dart' as page;

class ColumnScrollPage extends StatelessWidget {
  final Color color;
  final List<Widget> children;

  ColumnScrollPage({
    Key key,
    this.color,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return page.Page(
      color: color,
      builder: (context, width, height) => SingleChildScrollView(
        child: Column(children: children),
      ),
    );
  }
}
