import "package:flutter/widgets.dart";
import 'package:tundr/widgets/pages/page.dart' as page;

class StackScrollPage extends StatefulWidget {
  final Color color;
  final List<Widget> Function(BuildContext context, double width, double height)
      builder;
  // final Function onNextPage;

  StackScrollPage({
    Key key,
    this.color,
    @required this.builder,
    // @required this.onNextPage,
  }) : super(key: key);

  @override
  _StackScrollPageState createState() => _StackScrollPageState();
}

class _StackScrollPageState extends State<StackScrollPage> {
  // final ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(() {
  //     // print("out of range: ${_scrollController.position.outOfRange}");
  //     if (MediaQuery.of(context).viewInsets.bottom == 0) {
  //       print(
  //           "max scroll extent: ${_scrollController.position.maxScrollExtent}");
  //       print("scroll offset: " + _scrollController.offset.toString());
  //       if (_scrollController.offset == 0)
  //         Navigator.pop(context);
  //       else if (_scrollController.offset ==
  //           _scrollController.position.maxScrollExtent) widget.onNextPage();
  //       // if (_scrollController.offset < 0)
  //       //   Navigator.pop(context);
  //       // else if (_scrollController.offset > 0) widget.onNextPage();
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return page.Page(
      color: widget.color,
      builder: (context, width, height) => SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 1.0,
          bottom: MediaQuery.of(context).viewInsets.bottom +
              1, // add 1 so that scroll is triggered when there is no bottom padding
        ),
        // controller: _scrollController,
        child: SizedBox(
          height: height,
          child: Stack(children: widget.builder(context, width, height)),
        ),
      ),
    );
  }
}
