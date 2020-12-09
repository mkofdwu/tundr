import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/pages/chats_list/widgets/chat_tile.dart';
import 'package:tundr/pages/chats_list/widgets/match_tile.dart';
import 'package:tundr/repositories/user.dart';

import 'package:tundr/widgets/loaders/loader.dart';

class ChatsListPage extends StatefulWidget {
  @override
  _ChatsListPageState createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  Widget _buildMatchesList(List<String> matches) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List<Widget>.from(
            matches.map(
              (uid) => Padding(
                padding: EdgeInsets.only(right: 10),
                child: MatchTile(uid: uid),
              ),
            ),
          ),
        ),
      );

  Widget _buildChatCategoryList(List<Chat> chats) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List<Widget>.from(
            chats.map(
              (chat) => Padding(
                padding: EdgeInsets.only(right: 10),
                child: ChatTile(chat: chat),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        return StreamBuilder<List<Chat>>(
          stream: user.chatsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Loader());
            }
            if (!snapshot.hasData || snapshot.data.isEmpty) {
              return Center(
                child: Text(
                  'Matches and chats will appear here.',
                  style: TextStyle(
                    color: MyPalette.grey,
                    fontSize: 18,
                  ),
                ),
              );
            }
            final starredChats = snapshot.data
                .where((chat) => chat.type == ChatType.starred)
                .toList();
            final normalChats = snapshot.data
                .where((chat) => chat.type == ChatType.normal)
                .toList();
            final unknownChats = snapshot.data
                .where((chat) => chat.type == ChatType.unknown)
                .toList();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[] +
                          (user.privateInfo.matches.isEmpty
                              ? []
                              : [
                                  Text(
                                    'New matches',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  _buildMatchesList(user.privateInfo.matches),
                                  SizedBox(height: 30),
                                ]) +
                          (starredChats.isEmpty
                              ? []
                              : [
                                  Text('Starred',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                  _buildChatCategoryList(starredChats),
                                  SizedBox(height: 30),
                                ]) +
                          (normalChats.isEmpty
                              ? []
                              : [
                                  Text('Messages',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                  _buildChatCategoryList(normalChats),
                                  SizedBox(height: 30),
                                ]) +
                          (unknownChats.isEmpty
                              ? []
                              : [
                                  Text('Unknown messages',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                  _buildChatCategoryList(unknownChats),
                                ]),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
