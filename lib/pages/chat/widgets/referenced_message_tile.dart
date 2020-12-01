import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/utils/from_theme.dart';

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
    this.borderRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Message>(
        future: ChatsService.getMessage(chatId, messageId),
        builder: (context, snapshot) {
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
                          child:
                              Image.asset('assets/images/open-apostrophe.png'),
                        ),
                      ),
                      if (snapshot.hasData)
                        Expanded(
                          child: Text(
                            snapshot.data.text,
                            style: TextStyle(
                              color: MyPalette.black,
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      else
                        Text(
                          '...',
                          style: TextStyle(
                            color: MyPalette.black,
                            fontSize: 40,
                          ),
                        ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 20,
                          child:
                              Image.asset('assets/images/close-apostrophe.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  snapshot.hasData
                      ? (snapshot.data.senderUid ==
                              Provider.of<User>(context, listen: false)
                                  .profile
                                  .uid
                          ? '- You'
                          : '- $otherUserName')
                      : '- ?',
                  style: TextStyle(
                    color: MyPalette.black,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                )
              ],
            ),
          );
        });
  }
}
