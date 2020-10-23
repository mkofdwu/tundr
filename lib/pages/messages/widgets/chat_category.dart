import 'package:flutter/material.dart';

class ChatsGroup extends StatelessWidget {
  final String title;
  final Widget child;

  ChatsGroup({
    Key key,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 24.0,
            fontFamily: 'Helvetica Neue',
          ),
        ),
        SizedBox(height: 10.0),
        child,
      ],
    );
  }
}
