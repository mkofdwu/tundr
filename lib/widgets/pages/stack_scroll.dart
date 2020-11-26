import 'package:flutter/widgets.dart';
import 'package:tundr/widgets/pages/page.dart' as page;

class StackScrollPage extends StatefulWidget {
  final Color color;
  final List<Widget> Function(BuildContext context, double width, double height)
      builder;

  StackScrollPage({
    Key key,
    this.color,
    @required this.builder,
  }) : super(key: key);

  @override
  _StackScrollPageState createState() => _StackScrollPageState();
}

class _StackScrollPageState extends State<StackScrollPage> {
  @override
  Widget build(BuildContext context) {
    return page.Page(
      color: widget.color,
      builder: (context, width, height) => SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: height,
          child: Stack(children: widget.builder(context, width, height)),
        ),
      ),
    );
  }
}
