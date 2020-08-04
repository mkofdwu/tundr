import "package:flutter/widgets.dart";

class AppStateHandler extends StatefulWidget {
  final Widget child;
  final Function onExit;
  final Function onStart;

  AppStateHandler({
    Key key,
    this.child,
    @required this.onExit,
    @required this.onStart,
  }) : super(key: key);

  @override
  _AppStateHandlerState createState() => _AppStateHandlerState();
}

class _AppStateHandlerState extends State<AppStateHandler>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused)
      widget.onExit();
    else if (state == AppLifecycleState.resumed) widget.onStart();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
