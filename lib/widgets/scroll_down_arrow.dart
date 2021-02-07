import 'package:flutter/widgets.dart';

class ScrollDownArrow extends StatefulWidget {
  final bool dark;
  final Function onNextPage;

  ScrollDownArrow({
    Key key,
    this.dark = true,
    @required this.onNextPage,
  }) : super(key: key);

  @override
  _ScrollDownArrowState createState() => _ScrollDownArrowState();
}

class _ScrollDownArrowState extends State<ScrollDownArrow>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _animationController.addListener(() => setState(() {}));
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onNextPage,
      child: SizedBox(
        width: 20,
        height: 40,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: _animationController.value * 10,
              child: Image.asset(
                'assets/images/down-${widget.dark ? 'dark' : 'light'}.png',
                width: 20,
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
