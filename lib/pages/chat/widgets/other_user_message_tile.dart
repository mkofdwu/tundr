import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/pages/media/media_view.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/message_option.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'referenced_message_tile.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';

class OtherUserMessageTile extends StatelessWidget {
  final String chatId;
  final String otherUserName;
  final String profileImageUrl;
  final Message message;
  final Function viewReferencedMessage;
  final Function onReferenceMessage;
  final Function onDeleteMessage;

  OtherUserMessageTile({
    Key key,
    @required this.chatId,
    @required this.otherUserName,
    @required this.profileImageUrl,
    @required this.message,
    @required this.viewReferencedMessage,
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
            onPressed: () =>
                Navigator.pop(context, MessageOption.referenceMessage),
            child: const Text('Reply to message'),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 50.0,
          height: 50.0,
          decoration: fromTheme(
            context,
            dark: BoxDecoration(
              border: Border.all(color: MyPalette.white, width: 1.0),
            ),
            light: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [MyPalette.primaryShadow],
            ),
          ),
          child: ClipRRect(
            borderRadius: fromTheme(
              context,
              light: BorderRadius.circular(25.0),
              dark: BorderRadius.zero,
            ),
            child: getNetworkImage(profileImageUrl),
          ),
        ),
        SizedBox(width: 10.0),
        GestureDetector(
          onLongPress: () => _selectOption(context),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (message.referencedMessageId != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: GestureDetector(
                      child: ReferencedMessageTile(
                        chatId: chatId,
                        messageId: message.referencedMessageId,
                        otherUserName: otherUserName,
                      ),
                      onTap: viewReferencedMessage,
                    ),
                  ),
                message.media == null
                    ? SizedBox.shrink()
                    : GestureDetector(
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    message.text,
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
                Text(
                  DateFormat.jm().format(message.sentTimestamp),
                  style: TextStyle(
                    color: MyPalette.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
