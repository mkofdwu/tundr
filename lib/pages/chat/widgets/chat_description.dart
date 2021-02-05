import 'package:flutter/material.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/user_status.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/format_date.dart';

class ChatDescription extends StatelessWidget {
  final Chat chat;

  ChatDescription({@required this.chat});
  Widget _buildUserStatusText() => StreamBuilder<UserStatus>(
        stream: UsersService.getUserStatusStream(chat.otherProfile.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox.shrink();
          final status = snapshot.data;
          return Text(
            status.online ? 'online' : formatDate(status.lastSeen),
            style: TextStyle(fontSize: 12, color: MyPalette.white),
          );
        },
      );
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ChatsService.otherUserIsTypingStream(chat),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();
        if (snapshot.data) {
          return Text(
            'typing',
            style: TextStyle(
              fontSize: 12,
              color: MyPalette.white,
            ),
          );
        }
        return _buildUserStatusText();
      },
    );
  }
}
