import 'package:flutter/widgets.dart';
import 'match_tile.dart';

class MatchList extends StatelessWidget {
  final List<String> matches;

  MatchList({Key key, this.matches}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List<Widget>.from(matches.map(
          (uid) => Padding(
            padding: EdgeInsets.all(10.0),
            child: MatchTile(uid: uid),
          ),
        )),
      ),
    );
  }
}
