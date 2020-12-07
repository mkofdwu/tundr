import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/pages/media/media_view.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/message_option.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/utils/show_my_options_dialog.dart';
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
    final option = await showMyOptionsDialog(
      context: context,
      title: '',
      options: {'Reply to message': MessageOption.referenceMessage},
    );
    if (option == MessageOption.referenceMessage) onReferenceMessage();
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
          width: 50,
          height: 50,
          decoration: fromTheme(
            context,
            dark: BoxDecoration(
              border: Border.all(color: MyPalette.white, width: 1),
            ),
            light: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [MyPalette.primaryShadow],
            ),
          ),
          child: ClipRRect(
            borderRadius: fromTheme(
              context,
              light: BorderRadius.circular(25),
              dark: BorderRadius.zero,
            ),
            child: getNetworkImage(profileImageUrl),
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onLongPress: () => _selectOption(context),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (message.referencedMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      child: ReferencedMessageTile(
                        message: message.referencedMessage,
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
                              light: BorderRadius.circular(10),
                            ),
                            child: MediaThumbnail(message.media),
                          ),
                        ),
                        onTap: () => _openMedia(context),
                      ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    message.text,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Text(
                  DateFormat.jm().format(message.sentOn),
                  style: TextStyle(
                    color: MyPalette.grey,
                    fontSize: 12,
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
