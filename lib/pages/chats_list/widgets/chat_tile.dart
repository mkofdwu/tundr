import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/models/user_status.dart';
import 'package:tundr/store/user.dart';
import 'package:tundr/pages/chat/chat.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/format_date.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';

class ChatTile extends StatefulWidget {
  final Chat chat;

  ChatTile({
    Key key,
    @required this.chat,
  }) : super(key: key);

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool _pressed = false;

  void _openChat(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(chat: widget.chat),
        ),
      );

  Widget _buildMessagesPreview() {
    final uid = Provider.of<User>(context, listen: false).profile.uid;
    return StreamBuilder<List<Message>>(
      stream: ChatsService.messagesStream(widget.chat.id, 3),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        final messages = snapshot.data;
        return Column(
          children: List<Widget>.from(
            messages.reversed.map((message) => Align(
                  alignment: message.sender.uid == uid
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      message.text,
                      textAlign: message.sender.uid == uid
                          ? TextAlign.right
                          : TextAlign.left,
                      style: TextStyle(color: MyPalette.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }

  Widget _buildNameAndStatus() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.chat.otherProfile.name,
            style: TextStyle(
              color: MyPalette.white,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 3),
          StreamBuilder<UserStatus>(
              stream: UsersService.getUserStatusStream(
                  widget.chat.otherProfile.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }
                final status = snapshot.data;
                return Text(
                  status.online ? 'online' : formatDate(status.lastSeen),
                  style: TextStyle(color: MyPalette.white),
                );
              }),
        ],
      );

  List<Widget> _radialShadows() => [
        Positioned(
          left: -50,
          bottom: -70,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  MyPalette.black,
                  MyPalette.transparentBlack,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -50,
          right: -100,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  MyPalette.black,
                  MyPalette.transparentBlack,
                ],
              ),
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _openChat(context);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 150,
        height: 250,
        decoration: BoxDecoration(
          boxShadow: fromTheme(
            context,
            dark: [],
            light: [
              _pressed ? MyPalette.primaryShadow : MyPalette.secondaryShadow
            ],
          ),
          borderRadius: fromTheme(
            context,
            dark: BorderRadius.zero,
            light: BorderRadius.circular(20),
          ),
          border: fromTheme(
            context,
            dark: Border.all(color: MyPalette.white, width: 2),
            light: null,
          ),
        ),
        transform: fromTheme(
          context,
          dark: null,
          light: _pressed
              ? Matrix4.translationValues(0, 6, 0)
              : Matrix4.identity(),
        ),
        child: ClipRRect(
          borderRadius: fromTheme(
            context,
            dark: BorderRadius.zero,
            light: BorderRadius.circular(20),
          ),
          child: Stack(
            children: <Widget>[
                  widget.chat.otherProfile.profileImageUrl == null
                      ? null
                      : getNetworkImage(
                          widget.chat.otherProfile.profileImageUrl,
                          width: 150,
                          height: 250,
                        ),
                ] +
                fromTheme(
                  context,
                  dark: <Widget>[
                    Container(
                      color: MyPalette.black.withOpacity(
                        _pressed ? 0.8 : 0.6,
                      ),
                    ),
                  ],
                  light: _radialShadows(),
                ) +
                [
                  Positioned(
                    left: 10,
                    top: 10,
                    right: 10,
                    child: _buildMessagesPreview(),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    right: 10,
                    child: _buildNameAndStatus(),
                  ),
                ],
          ),
        ),
      ),
    );
  }
}
