import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/pages/media/media_view.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/message_option.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/show_options_dialog.dart';
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
    final option = await showOptionsDialog(
      context: context,
      title: '',
      options: {
        'Reply to message': MessageOption.referenceMessage,
        'Delete message': MessageOption.deleteMessage,
      },
    );
    if (option == MessageOption.referenceMessage) {
      onReferenceMessage();
    } else if (option == MessageOption.deleteMessage) {
      onDeleteMessage();
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
            constraints: BoxConstraints(maxWidth: 200),
            decoration: fromTheme(
              context,
              dark: BoxDecoration(color: MyPalette.white),
              light: BoxDecoration(
                color: MyPalette.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [MyPalette.primaryShadow],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                if (message.referencedMessage != null)
                  GestureDetector(
                    child: ReferencedMessageTile(
                      message: message.referencedMessage,
                    ),
                    onTap: onViewReferencedMessage,
                  ),
                if (message.media != null)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [MyPalette.secondaryShadow],
                        ),
                        child: ClipRRect(
                          borderRadius: fromTheme(
                            context,
                            dark: BorderRadius.zero,
                            light: BorderRadius.circular(10),
                          ),
                          child: MediaThumbnail(message.media),
                        ),
                      ),
                      onTap: () => _openMedia(context),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: MyPalette.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                DateFormat.jm().format(message.sentOn),
                style: TextStyle(
                  color: MyPalette.grey,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                // DESIGN: find another icon
                Icons.done,
                color:
                    message.readOn == null ? MyPalette.grey : MyPalette.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
