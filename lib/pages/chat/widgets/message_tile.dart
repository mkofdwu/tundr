import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/pages/chat/widgets/reply_gesture.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/message_option.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/utils/show_options_dialog.dart';

import 'message_tile_content.dart';

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
            child: MessageTileContent(
              message: widget.message,
              fromMe: widget.fromMe,
              onViewReferencedMessage: widget.onViewReferencedMessage,
              statusIcon: widget.fromMe
                  ? Icon(
                      widget.message.readOn == null
                          ? Icons.done
                          : Icons.done_all,
                      size: 16,
                      color: widget.message.readOn == null ||
                              !widget
                                  .readReceipts // if the user disables read receipts they will also be unable to see
                          ? MyPalette.grey
                          : MyPalette.gold,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
