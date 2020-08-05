import "package:flutter/widgets.dart";
import 'package:tundr/models/chat.dart';
import './chat-tile.dart';

class ChatList extends StatelessWidget {
  final List<Chat> chats; // list of chat uids

  ChatList({
    Key key,
    @required this.chats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List<Widget>.from(
          chats.map(
            (chat) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: ChatTile(chat: chat),
            ),
          ),
        ),
      ),
    );
  }
}
