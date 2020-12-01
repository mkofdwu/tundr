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
                padding: EdgeInsets.symmetric(horizontal: 10),
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
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ChatTile(chat: chat),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) => StreamBuilder<List<Chat>>(
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
          final starredChats =
              snapshot.data.where((chat) => chat.type == ChatType.starred);
          final normalChats =
              snapshot.data.where((chat) => chat.type == ChatType.normal);
          final unknownChats =
              snapshot.data.where((chat) => chat.type == ChatType.unknown);
          return RefreshIndicator(
            backgroundColor: MyPalette.gold,
            onRefresh: () async => setState(() {}),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('New matches', style: TextStyle(fontSize: 24)),
                        SizedBox(height: 10),
                        _buildMatchesList(user.privateInfo.matches),
                        SizedBox(height: 20),
                        Text('Starred', style: TextStyle(fontSize: 24)),
                        SizedBox(height: 10),
                        _buildChatCategoryList(starredChats),
                        SizedBox(height: 20),
                        Text('Messages', style: TextStyle(fontSize: 24)),
                        SizedBox(height: 10),
                        _buildChatCategoryList(normalChats),
                        SizedBox(height: 20),
                        Text('Unknown messages',
                            style: TextStyle(fontSize: 24)),
                        SizedBox(height: 10),
                        _buildChatCategoryList(unknownChats),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
