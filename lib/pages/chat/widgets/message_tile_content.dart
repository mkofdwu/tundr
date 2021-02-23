import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/pages/media/media_view.dart';
import 'package:tundr/utils/from_theme.dart';

import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'referenced_message_tile.dart';

class MessageTileContent extends StatelessWidget {
  final Message message;
  final bool fromMe;
  final Widget statusIcon;
  final Function onViewReferencedMessage;

  MessageTileContent({
    @required this.message,
    @required this.fromMe,
    @required this.statusIcon,
    @required this.onViewReferencedMessage,
  });

  void _openMedia(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaViewPage(media: message.media),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
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
            crossAxisAlignment:
                fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                    child: SizedBox(
                      width: 200,
                      height: 260,
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
            SizedBox(width: 4),
            if (statusIcon != null) statusIcon,
          ],
        ),
      ],
    );
  }
}
