import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/utils/constants/shadows.dart';
import 'package:tundr/utils/fromtheme.dart';
import './referencedmessagetile.dart';
import 'package:tundr/widgets/loaders/loader.dart';
import 'package:tundr/widgets/media/mediathumbnail.dart';

class UnsentMessageTile extends StatelessWidget {
  final String chatId;
  final String otherUserName;
  final Message message;

  UnsentMessageTile({
    Key key,
    @required this.chatId,
    @required this.otherUserName,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FUTURE: improve on this design
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxWidth: 200.0),
              decoration: fromTheme(
                context,
                dark: BoxDecoration(color: AppColors.white),
                light: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [Shadows.primaryShadow],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  if (message.referencedMessageId != null)
                    ReferencedMessageTile(
                      chatId: chatId,
                      otherUserName: otherUserName,
                      messageId: message.referencedMessageId,
                    ),
                  if (message.media != null)
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [Shadows.secondaryShadow],
                        ),
                        child: ClipRRect(
                          borderRadius: fromTheme(
                            context,
                            dark: BorderRadius.zero,
                            light: BorderRadius.circular(10.0),
                          ),
                          child: MediaThumbnail(message.media),
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0),
            SizedBox(
              width: 10.0,
              height: 10.0,
              child: Loader(),
            ),
          ],
        ),
      ),
    );
  }
}
