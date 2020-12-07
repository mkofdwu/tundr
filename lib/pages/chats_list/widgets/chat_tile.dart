import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/models/user_status.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/pages/chat/chat.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/format_date.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/theme_builder.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;

  ChatTile({
    Key key,
    @required this.chat,
  }) : super(key: key);

  void _openChat(BuildContext context) async {
    final user = await UsersService.getUserProfile(chat.uid);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(otherUser: user, chat: chat),
      ),
    );
  }

  Widget _buildDark(context) => GestureDetector(
        child: FutureBuilder(
          future: Future.wait([
            UsersService.getUserProfile(chat.uid),
            UsersService.isBlockedBy(chat.uid),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return SizedBox.shrink();
            final UserProfile user = snapshot.data[0];
            final bool blocked = snapshot.data[1];
            return Stack(
              children: <Widget>[
                    Container(
                      width: 150,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: MyPalette.white),
                        image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(user.profileImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        color: MyPalette.black.withOpacity(0.7),
                      ),
                    ),
                  ] +
                  (blocked
                      ? <Widget>[
                          Container(
                            color: MyPalette.black.withOpacity(0.8),
                          ),
                          Positioned.fill(
                            top: 20,
                            child: Text(
                              'Blocked',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MyPalette.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            bottom: 20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(Icons.delete,
                                    color: MyPalette.red, size: 30),
                                SizedBox(height: 3),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: MyPalette.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      : <Widget>[
                          Positioned(
                            left: 10,
                            top: 10,
                            right: 10,
                            child: StreamBuilder<List<Message>>(
                              stream: ChatsService.messagesStream(chat.id, 3),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return SizedBox.shrink();
                                final messages = snapshot.data;
                                return Column(
                                  children: List<Widget>.from(
                                    messages.reversed.map(
                                      (message) {
                                        final fromMe = message.sender.uid ==
                                            Provider.of<User>(context,
                                                    listen: false)
                                                .profile
                                                .uid;
                                        return Align(
                                          alignment: fromMe
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: Text(
                                              message.text,
                                              textAlign: fromMe
                                                  ? TextAlign.right
                                                  : TextAlign.left,
                                              style: TextStyle(
                                                color: MyPalette.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            left: 15,
                            bottom: 15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    color: MyPalette.white,
                                    fontSize: 30,
                                  ),
                                ),
                                SizedBox(height: 3),
                                StreamBuilder<UserStatus>(
                                  stream: UsersService.getUserStatusStream(
                                      user.uid),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return SizedBox.shrink();
                                    }
                                    final status = snapshot.data;
                                    return Text(
                                      status.online
                                          ? 'online'
                                          : formatDate(status.lastSeen),
                                      style: TextStyle(
                                        color: MyPalette.white,
                                        fontSize: 16,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]),
            );
          },
        ),
        onTap: () => _openChat(context),
      );

  Widget _buildLight(context) => GestureDetector(
        child: FutureBuilder(
          future: Future.wait([
            UsersService.getUserProfile(chat.uid),
            UsersService.isBlockedBy(chat.uid),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return SizedBox.shrink();
            final UserProfile user = snapshot.data[0];
            final bool blocked = snapshot.data[1];
            return Container(
              decoration: BoxDecoration(boxShadow: [MyPalette.secondaryShadow]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: <Widget>[
                        Container(
                          width: 150,
                          height: 250,
                          color: MyPalette.black,
                          child: user.profileImageUrl.isEmpty
                              ? null
                              : getNetworkImage(user.profileImageUrl),
                        ),
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
                      ] +
                      (blocked
                          ? <Widget>[
                              Container(
                                color: MyPalette.black.withOpacity(0.8),
                              ),
                              Positioned.fill(
                                top: 20,
                                child: Text(
                                  'Blocked',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: MyPalette.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                bottom: 20,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.delete,
                                        color: MyPalette.red, size: 30),
                                    SizedBox(height: 3),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: MyPalette.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          : <Widget>[
                              Positioned(
                                left: 10,
                                top: 10,
                                right: 10,
                                child: StreamBuilder<List<Message>>(
                                  stream:
                                      ChatsService.messagesStream(chat.uid, 3),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return SizedBox.shrink();
                                    }
                                    final messages = snapshot.data;
                                    return Column(
                                      children: List<Widget>.from(
                                          messages.reversed.map(
                                        (message) {
                                          final fromMe = message.sender.uid ==
                                              Provider.of<User>(context,
                                                      listen: false)
                                                  .profile
                                                  .uid;
                                          return Align(
                                            alignment: fromMe
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2),
                                              child: Text(
                                                message.text,
                                                style: TextStyle(
                                                  color: MyPalette.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                left: 15,
                                bottom: 15,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      user.name,
                                      style: TextStyle(
                                        color: MyPalette.white,
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    StreamBuilder<UserStatus>(
                                        stream:
                                            UsersService.getUserStatusStream(
                                                user.uid),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return SizedBox.shrink();
                                          }
                                          final status = snapshot.data;
                                          return Text(
                                            status.online
                                                ? 'online'
                                                : formatDate(status.lastSeen),
                                            style: TextStyle(
                                              color: MyPalette.white,
                                              fontSize: 16,
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ]),
                ),
              ),
            );
          },
        ),
        onTap: () => _openChat(context),
      );

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      buildDark: () => _buildDark(context),
      buildLight: () => _buildLight(context),
    );
  }
}
