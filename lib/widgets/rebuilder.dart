import 'package:flutter/widgets.dart';

class Rebuilder extends StatefulWidget {
  final Widget child;

  Rebuilder({@required this.child});

  @override
  _RebuilderState createState() => _RebuilderState();

  static void rebuild(BuildContext context) =>
      context.findAncestorStateOfType<_RebuilderState>().rebuild();
}

class _RebuilderState extends State<Rebuilder> {
  Key _key = UniqueKey();

  void rebuild() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
