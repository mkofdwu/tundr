import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/pages/media/media_view.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/message_option.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/utils/show_options_dialog.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'referenced_message_tile.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  final bool fromMe;
  final Function onViewReferencedMessage;
  final Function onReferenceMessage;
  final Function onDeleteMessage;

  const MessageTile({
    Key key,
    @required this.message,
    @required this.fromMe,
    @required this.onViewReferencedMessage,
    @required this.onReferenceMessage,
    @required this.onDeleteMessage,
  }) : super(key: key);

  Future<void> _selectOption(BuildContext context) async {
    final option = await showOptionsDialog(
      context: context,
      title: '',
      options: fromMe
          ? {
              'Reply to message': MessageOption.referenceMessage,
              'Delete message': MessageOption.deleteMessage,
            }
          : {'Reply to message': MessageOption.referenceMessage},
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

  Widget _buildOtherProfilePic(context) => Container(
        width: 40,
        height: 40,
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
        clipBehavior: Clip.antiAlias,
        child: getNetworkImage(message.sender.profileImageUrl),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!fromMe) _buildOtherProfilePic(context),
        SizedBox(width: 14),
        GestureDetector(
          onLongPress: () => _selectOption(context),
          child: Column(
            crossAxisAlignment:
                fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                padding: fromMe ? const EdgeInsets.all(8) : EdgeInsets.zero,
                decoration: fromMe
                    ? fromTheme(
                        context,
                        dark: BoxDecoration(color: MyPalette.white),
                        light: BoxDecoration(
                          color: MyPalette.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [MyPalette.primaryShadow],
                        ),
                      )
                    : null,
                child: Column(
                  crossAxisAlignment: fromMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: <Widget>[
                    if (message.referencedMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          child: ReferencedMessageTile(
                            message: message.referencedMessage,
                          ),
                          onTap: onViewReferencedMessage,
                        ),
                      ),
                    if (message.media != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          child: Container(
                            child: ClipRRect(
                              borderRadius: fromTheme(
                                context,
                                dark: BorderRadius.zero,
                                light: BorderRadius.circular(6),
                              ),
                              child: MediaThumbnail(message.media),
                            ),
                          ),
                          onTap: () => _openMedia(context),
                        ),
                      ),
                    Text(
                      message.text,
                      style: TextStyle(
                        color: fromMe
                            ? MyPalette.black
                            : Theme.of(context).colorScheme.onPrimary,
                        fontSize: 16,
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
                  SizedBox(width: 3),
                  if (fromMe)
                    Icon(
                      message.readOn == null ? Icons.done : Icons.done_all,
                      size: 16,
                      color: message.readOn == null
                          ? MyPalette.grey
                          : MyPalette.gold,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
