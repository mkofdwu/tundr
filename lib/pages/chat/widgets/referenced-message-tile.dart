import "package:flutter/widgets.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/repositories/current-user.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/shadows.dart';
import 'package:tundr/utils/from-theme.dart';

class ReferencedMessageTile extends StatelessWidget {
  final String chatId;
  final String messageId;
  final String otherUserName;
  final double borderRadius;

  ReferencedMessageTile({
    Key key,
    @required this.chatId,
    @required this.messageId,
    @required this.otherUserName,
    this.borderRadius = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Message>(
        future: DatabaseService.getMessage(chatId, messageId),
        builder: (context, snapshot) {
          return Container(
            decoration: fromTheme(
              context,
              dark: BoxDecoration(
                color: AppColors.grey,
                boxShadow: [Shadows.secondaryShadow],
              ),
              light: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [Shadows.secondaryShadow],
              ),
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: 20.0,
                          child:
                              Image.asset("assets/images/open-apostrophe.png"),
                        ),
                      ),
                      if (snapshot.hasData)
                        Expanded(
                          child: Text(
                            snapshot.data.text,
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 20.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else
                        Text(
                          "...",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 40.0,
                          ),
                        ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 20.0,
                          child:
                              Image.asset("assets/images/close-apostrophe.png"),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.0),
                Text(
                  snapshot.hasData
                      ? (snapshot.data.senderUid ==
                              Provider.of<CurrentUser>(context).user.uid
                          ? "- You"
                          : "- $otherUserName")
                      : "- ?",
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
          );
        });
  }
}
