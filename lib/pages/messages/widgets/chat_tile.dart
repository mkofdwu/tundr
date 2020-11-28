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
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => ChatPage(
          otherUser: user,
          chat: chat,
        ),
        transitionsBuilder: (context, animation1, animation2, child) {
          return FadeTransition(opacity: animation1, child: child);
        },
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
                      width: 150.0,
                      height: 250.0,
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
                            top: 20.0,
                            child: Text(
                              'Blocked',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MyPalette.white,
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            bottom: 20.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(Icons.delete,
                                    color: MyPalette.red, size: 30.0),
                                SizedBox(height: 3.0),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: MyPalette.red,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      : <Widget>[
                          Positioned(
                            left: 10.0,
                            top: 10.0,
                            right: 10.0,
                            child: StreamBuilder/*<QuerySnapshot>*/(
                              stream: ChatsService.messagesStream(chat.id, 3),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return SizedBox.shrink();
                                final List<Message> messages = snapshot
                                    .data.docs
                                    .map((messageDoc) =>
                                        Message.fromDoc(messageDoc))
                                    .toList();
                                return Column(
                                  children: List<Widget>.from(
                                    messages.reversed.map(
                                      (message) {
                                        final fromMe = message.senderUid ==
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
                                                vertical: 2.0),
                                            child: Text(
                                              message.text,
                                              textAlign: fromMe
                                                  ? TextAlign.right
                                                  : TextAlign.left,
                                              style: TextStyle(
                                                color: MyPalette.white,
                                                fontSize: 14.0,
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
                            left: 15.0,
                            bottom: 15.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    color: MyPalette.white,
                                    fontSize: 30.0,
                                  ),
                                ),
                                SizedBox(height: 3.0),
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
                                        fontSize: 16.0,
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
                borderRadius: BorderRadius.circular(20.0),
                child: Stack(
                  children: <Widget>[
                        Container(
                          width: 150.0,
                          height: 250.0,
                          color: MyPalette.black,
                          child: user.profileImageUrl.isEmpty
                              ? null
                              : getNetworkImage(user.profileImageUrl),
                        ),
                        Positioned(
                          left: -50.0,
                          bottom: -70.0,
                          child: Container(
                            width: 200.0,
                            height: 200.0,
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
                          top: -50.0,
                          right: -100.0,
                          child: Container(
                            width: 200.0,
                            height: 200.0,
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
                                top: 20.0,
                                child: Text(
                                  'Blocked',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: MyPalette.white,
                                    fontSize: 24.0,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                bottom: 20.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.delete,
                                        color: MyPalette.red, size: 30.0),
                                    SizedBox(height: 3.0),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: MyPalette.red,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          : <Widget>[
                              Positioned(
                                left: 10.0,
                                top: 10.0,
                                right: 10.0,
                                child: StreamBuilder/*<QuerySnapshot>*/(
                                  stream:
                                      ChatsService.messagesStream(chat.uid, 3),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return SizedBox.shrink();
                                    }
                                    final List<Message> messages = snapshot
                                        .data.docs
                                        .map((messageDoc) =>
                                            Message.fromDoc(messageDoc))
                                        .toList();
                                    return Column(
                                      children: List<Widget>.from(
                                          messages.reversed.map(
                                        (message) {
                                          final fromMe = message.senderUid ==
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
                                                  vertical: 2.0),
                                              child: Text(
                                                message.text,
                                                style: TextStyle(
                                                  color: MyPalette.white,
                                                  fontSize: 14.0,
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
                                left: 15.0,
                                bottom: 15.0,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      user.name,
                                      style: TextStyle(
                                        color: MyPalette.white,
                                        fontSize: 30.0,
                                      ),
                                    ),
                                    SizedBox(height: 3.0),
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
                                              fontSize: 16.0,
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
