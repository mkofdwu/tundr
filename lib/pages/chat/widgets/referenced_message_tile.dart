import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/utils/from_theme.dart';

class ReferencedMessageTile extends StatelessWidget {
  final Message message;
  final double fontSize;
  final double borderRadius;

  ReferencedMessageTile({
    Key key,
    @required this.message,
    this.fontSize = 12,
    this.borderRadius = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: fromTheme(
        context,
        dark: BoxDecoration(
          color: MyPalette.white,
          border: Border.all(color: MyPalette.black, width: 1),
        ),
        light: BoxDecoration(
          color: MyPalette.black,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      padding: EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              message.text,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: fontSize,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 6,
            ),
          ),
          SizedBox(height: 10),
          Text(
            message.sender.uid ==
                    Provider.of<User>(context, listen: false).profile.uid
                ? '- You'
                : '- ${message.sender.name}',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          )
        ],
      ),
    );
  }
}
