import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/pages/chat/widgets/reply_gesture.dart';
import 'package:tundr/pages/media/media_view.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/message_option.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/utils/show_options_dialog.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'referenced_message_tile.dart';

class MessageTile extends StatefulWidget {
  final Message message;
  final bool fromMe;
  final bool readReceipts;
  final Function onViewReferencedMessage;
  final Function onReferenceMessage;
  final Function onDeleteMessage;

  const MessageTile({
    Key key,
    @required this.message,
    @required this.fromMe,
    @required this.readReceipts,
    @required this.onViewReferencedMessage,
    @required this.onReferenceMessage,
    @required this.onDeleteMessage,
  }) : super(key: key);

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  Future<void> _showMessageOptions(BuildContext context) async {
    final option = await showOptionsDialog(
      context: context,
      title: '',
      options: widget.fromMe
          ? {
              'Reply to message': MessageOption.referenceMessage,
              'Delete message': MessageOption.deleteMessage,
            }
          : {'Reply to message': MessageOption.referenceMessage},
    );
    if (option == MessageOption.referenceMessage) {
      widget.onReferenceMessage();
    } else if (option == MessageOption.deleteMessage) {
      widget.onDeleteMessage();
    }
  }

  void _openMedia(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaViewPage(media: widget.message.media),
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
        child: getNetworkImage(widget.message.sender.profileImageUrl),
      );

  @override
  Widget build(BuildContext context) {
    return ReplyGesture(
      accountForWidth: !widget.fromMe,
      onReply: widget.onReferenceMessage,
      child: Row(
        mainAxisAlignment:
            widget.fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.fromMe) _buildOtherProfilePic(context),
          SizedBox(width: 14),
          GestureDetector(
            onLongPress: () => _showMessageOptions(context),
            child: Column(
              crossAxisAlignment: widget.fromMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  padding:
                      widget.fromMe ? const EdgeInsets.all(8) : EdgeInsets.zero,
                  decoration: widget.fromMe
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
                    crossAxisAlignment: widget.fromMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      if (widget.message.referencedMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            child: ReferencedMessageTile(
                              message: widget.message.referencedMessage,
                            ),
                            onTap: widget.onViewReferencedMessage,
                          ),
                        ),
                      if (widget.message.media != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            child: SizedBox(
                              width: 200,
                              height: 260,
                              child: ClipRRect(
                                borderRadius: fromTheme(
                                  context,
                                  dark: BorderRadius.zero,
                                  light: BorderRadius.circular(6),
                                ),
                                child: MediaThumbnail(widget.message.media),
                              ),
                            ),
                            onTap: () => _openMedia(context),
                          ),
                        ),
                      Text(
                        widget.message.text,
                        style: TextStyle(
                          color: widget.fromMe
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
                      DateFormat.jm().format(widget.message.sentOn),
                      style: TextStyle(
                        color: MyPalette.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 3),
                    if (widget.fromMe)
                      Icon(
                        widget.message.readOn == null
                            ? Icons.done
                            : Icons.done_all,
                        size: 16,
                        color: widget.message.readOn == null ||
                                !widget
                                    .readReceipts // if the user disables read receipts they will also be unable to see
                            ? MyPalette.grey
                            : MyPalette.gold,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
