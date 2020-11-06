import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/pages/media/media_view.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/message_option.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'referenced_message_tile.dart';

class OwnMessageTile extends StatelessWidget {
  final String chatId;
  final String otherUserName;
  final Message message;
  final Function onViewReferencedMessage;
  final Function onReferenceMessage;
  final Function onDeleteMessage;

  const OwnMessageTile({
    Key key,
    @required this.chatId,
    @required this.otherUserName,
    @required this.message,
    @required this.onViewReferencedMessage,
    @required this.onReferenceMessage,
    @required this.onDeleteMessage,
  }) : super(key: key);

  Future<void> _selectOption(BuildContext context) async {
    final option = await showDialog(
      // FUTURE: improve on this temporary solution
      context: context,
      child: SimpleDialog(
        children: <Widget>[
          FlatButton(
            child: Text('Reply to message'),
            onPressed: () =>
                Navigator.pop(context, MessageOption.referenceMessage),
          ),
          FlatButton(
            child: Text('Delete message'),
            onPressed: () =>
                Navigator.pop(context, MessageOption.deleteMessage),
          ),
        ],
      ),
    );
    switch (option) {
      case MessageOption.referenceMessage:
        onReferenceMessage();
        break;
      case MessageOption.deleteMessage:
        onDeleteMessage();
        break;
    }
  }

  void _openMedia(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaViewPage(media: message.media),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // FUTURE: improve on this design
    return GestureDetector(
      onLongPress: () => _selectOption(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: 200.0),
            decoration: fromTheme(
              context,
              dark: BoxDecoration(color: MyPalette.white),
              light: BoxDecoration(
                color: MyPalette.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [MyPalette.primaryShadow],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                if (message.referencedMessageId != null)
                  GestureDetector(
                    child: ReferencedMessageTile(
                      chatId: chatId,
                      messageId: message.referencedMessageId,
                      otherUserName: otherUserName,
                    ),
                    onTap: onViewReferencedMessage,
                  ),
                if (message.media != null)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [MyPalette.secondaryShadow],
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
                      onTap: () => _openMedia(context),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: MyPalette.black,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                DateFormat.jm().format(message.sentTimestamp),
                style: TextStyle(
                  color: MyPalette.grey,
                  fontSize: 12.0,
                ),
              ),
              SizedBox(width: 5.0),
              Icon(
                // DESIGN: find another icon
                Icons.done,
                color: message.readTimestamp == null
                    ? MyPalette.grey
                    : MyPalette.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}