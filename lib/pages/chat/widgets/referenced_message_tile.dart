import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/utils/from_theme.dart';

class ReferencedMessageTile extends StatelessWidget {
  final Message message;
  final double borderRadius;

  ReferencedMessageTile({
    Key key,
    @required this.message,
    this.borderRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: fromTheme(
        context,
        dark: BoxDecoration(
          color: MyPalette.grey,
          boxShadow: [MyPalette.secondaryShadow],
        ),
        light: BoxDecoration(
          color: MyPalette.grey,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [MyPalette.secondaryShadow],
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 20,
                    child: Image.asset('assets/images/open-apostrophe.png'),
                  ),
                ),
                Expanded(
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: MyPalette.black,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 20,
                    child: Image.asset('assets/images/close-apostrophe.png'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(
            message.sender.uid ==
                    Provider.of<User>(context, listen: false).profile.uid
                ? '- You'
                : '- ${message.sender.name}',
            style: TextStyle(
              color: MyPalette.black,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          )
        ],
      ),
    );
  }
}
