import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/pages/chats_list/widgets/chat_tile.dart';
import 'package:tundr/pages/chats_list/widgets/match_tile.dart';
import 'package:tundr/repositories/user.dart';

import 'package:tundr/widgets/my_loader.dart';

class ChatsListPage extends StatefulWidget {
  @override
  _ChatsListPageState createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  Widget _buildMatchesList(List<Chat> matchChats) => SingleChildScrollView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List<Widget>.from(
            matchChats.map(
              (uid) => Padding(
                padding: EdgeInsets.only(right: 10),
                child: MatchTile(chat: uid),
              ),
            ),
          ),
        ),
      );

  Widget _buildChatCategoryList(List<Chat> chats) => SingleChildScrollView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List<Widget>.from(
            chats.map(
              (chat) => Padding(
                padding: EdgeInsets.only(right: 20),
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
              return Center(child: MyLoader());
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
            final newMatchChats = snapshot.data
                .where((chat) => chat.type == ChatType.newMatch)
                .toList();
            final starredChats = snapshot.data
                .where((chat) => chat.type == ChatType.starred)
                .toList();
            final normalChats = snapshot.data
                .where((chat) => chat.type == ChatType.normal)
                .toList();
            final unknownChats = snapshot.data
                .where((chat) => chat.type == ChatType.unknown)
                .toList();
            return SingleChildScrollView(
              clipBehavior: Clip.none,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[] +
                        (newMatchChats.isEmpty
                            ? []
                            : [
                                Text(
                                  'New matches',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 18),
                                _buildMatchesList(newMatchChats),
                                SizedBox(height: 34),
                              ]) +
                        (starredChats.isEmpty
                            ? []
                            : [
                                Text(
                                  'Starred',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 18),
                                _buildChatCategoryList(starredChats),
                                SizedBox(height: 34),
                              ]) +
                        (normalChats.isEmpty
                            ? []
                            : [
                                Text(
                                  'Messages',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 18),
                                _buildChatCategoryList(normalChats),
                                SizedBox(height: 34),
                              ]) +
                        (unknownChats.isEmpty
                            ? []
                            : [
                                Text(
                                  'Unknown messages',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 18),
                                _buildChatCategoryList(unknownChats),
                                SizedBox(height: 34),
                              ]),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
