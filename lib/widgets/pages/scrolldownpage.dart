import 'package:flutter/material.dart';
import "package:flutter/rendering.dart";
import 'package:tundr/widgets/pages/page.dart' as page;

class ScrollDownPage extends StatefulWidget {
  final Color color;
  final Function(BuildContext, double, double) builder;
  final Function onNextPage;

  ScrollDownPage({
    Key key,
    this.color,
    @required this.builder,
    @required this.onNextPage,
  }) : super(key: key);

  @override
  _ScrollDownPageState createState() => _ScrollDownPageState();
}

class _ScrollDownPageState extends State<ScrollDownPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // FUTURE: find a better solution?
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse)
          widget.onNextPage();
        else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward)
          Navigator.pop(context);
        else
          _scrollController.jumpTo(
              1.0); // at this offset of 1.0 there is a distance of 1 pixel from both the top and bottom of the scrollview, thus allowing the user to scroll in both directions.
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return page.Page(
      color: widget.color,
      builder: (context, width, height) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 1.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 1,
          ), // add 1 so that scroll is triggered when there is no top / bottom padding
          controller: _scrollController,
          child: SizedBox(
            height: height,
            child: widget.builder(context, width, height),
          ),
        );
      },
    );
  }
}
