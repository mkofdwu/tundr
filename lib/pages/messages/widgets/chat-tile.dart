import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/message.dart';
import 'package:tundr/repositories/current-user.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/pages/chat/chat.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/shadows.dart';
import 'package:tundr/utils/format-date.dart';
import 'package:tundr/utils/get-network-image.dart';
import 'package:tundr/widgets/theme-builder.dart';

class ChatTile extends StatelessWidget {
  final Chat chat;

  ChatTile({
    Key key,
    @required this.chat,
  }) : super(key: key);

  _openChat(BuildContext context) async {
    final User user = await DatabaseService.getUser(chat.uid);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => ChatPage(
          user: user,
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
            DatabaseService.getUser(chat.uid),
            DatabaseService.blocked(
                chat.uid, Provider.of<CurrentUser>(context).user.uid),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return SizedBox.shrink();
            final User user = snapshot.data[0];
            final bool blocked = snapshot.data[1];
            return Stack(
              children: <Widget>[
                    Container(
                      width: 150.0,
                      height: 250.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.white),
                        image: DecorationImage(
                          image:
                              CachedNetworkImageProvider(user.profileImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        color: AppColors.black.withOpacity(0.7),
                      ),
                    ),
                  ] +
                  (blocked
                      ? <Widget>[
                          Container(
                            color: AppColors.black.withOpacity(0.8),
                          ),
                          Positioned.fill(
                            top: 20.0,
                            child: Text(
                              "Blocked",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.white,
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
                                    color: AppColors.red, size: 30.0),
                                SizedBox(height: 3.0),
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: AppColors.red,
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
                                  DatabaseService.messagesStream(chat.id, 3),
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
                                        final bool fromMe = message.senderUid ==
                                            Provider.of<CurrentUser>(context)
                                                .user
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
                                                color: AppColors.white,
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
                                    color: AppColors.white,
                                    fontSize: 30.0,
                                  ),
                                ),
                                SizedBox(height: 3.0),
                                Text(
                                  user.online
                                      ? "online"
                                      : formatDate(user.lastSeen),
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16.0,
                                  ),
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
            DatabaseService.getUser(chat.uid),
            DatabaseService.blocked(
                chat.uid, Provider.of<CurrentUser>(context).user.uid),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return SizedBox.shrink();
            final User user = snapshot.data[0];
            final bool blocked = snapshot.data[1];
            return Container(
              decoration: BoxDecoration(boxShadow: [Shadows.secondaryShadow]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Stack(
                  children: <Widget>[
                        Container(
                          width: 150.0,
                          height: 250.0,
                          color: AppColors.black,
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
                                  AppColors.black,
                                  AppColors.transparentBlack,
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
                                  AppColors.black,
                                  AppColors.transparentBlack,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ] +
                      (blocked
                          ? <Widget>[
                              Container(
                                color: AppColors.black.withOpacity(0.8),
                              ),
                              Positioned.fill(
                                top: 20.0,
                                child: Text(
                                  "Blocked",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.white,
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
                                        color: AppColors.red, size: 30.0),
                                    SizedBox(height: 3.0),
                                    Text(
                                      "Delete",
                                      style: TextStyle(
                                        color: AppColors.red,
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
                                  stream: DatabaseService.messagesStream(
                                      chat.uid, 3),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return SizedBox.shrink();
                                    final List<Message> messages = snapshot
                                        .data.docs
                                        .map((messageDoc) =>
                                            Message.fromDoc(messageDoc))
                                        .toList();
                                    return Column(
                                      children: List<Widget>.from(
                                          messages.reversed.map(
                                        (message) {
                                          final bool fromMe = message
                                                  .senderUid ==
                                              Provider.of<CurrentUser>(context)
                                                  .user
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
                                                  color: AppColors.white,
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
                                        color: AppColors.white,
                                        fontSize: 30.0,
                                      ),
                                    ),
                                    SizedBox(height: 3.0),
                                    Text(
                                      user.online
                                          ? "online"
                                          : formatDate(user.lastSeen),
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16.0,
                                      ),
                                    ),
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
