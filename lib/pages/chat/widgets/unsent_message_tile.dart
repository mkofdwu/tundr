import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/widgets/loaders/loader.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'referenced_message_tile.dart';

class UnsentMessageTile extends StatelessWidget {
  final Message message;

  const UnsentMessageTile({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FUTURE: improve on this design
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Align(
        alignment: Alignment.centerRight,
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
                    ReferencedMessageTile(
                      message: message.referencedMessage,
                    ),
                  if (message.media != null)
                    Padding(
                      padding: const EdgeInsets.all(10),
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
            SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 1),
            ),
          ],
        ),
      ),
    );
  }
}
