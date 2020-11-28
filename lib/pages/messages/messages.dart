import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/repositories/user.dart';

import 'package:tundr/widgets/loaders/loader.dart';

import 'widgets/chat_category.dart';
import 'widgets/chat_list.dart';
import 'widgets/match_list.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // Future<void> _loadMessages() {
  //   final LocalDatabaseService localDatabaseService =
  //       DatabaseService;
  //   return DatabaseService.saveNewMessages(
  //     uid: Provider.of<User>(context, listen: false).profile.uid,
  //     saveMessage: localDatabaseService.saveMessage,
  //     addChatIfDoesNotExistElseSetUpdated: (uid) async {
  //       if (await localDatabaseService.chatExists(uid)) {
  //         localDatabaseService.setChatUpdated(uid);
  //       } else {
  //         localDatabaseService.saveUnknownChat(uid);
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Chat>>(
      stream: Provider.of<User>(context, listen: false).chatsStream(),
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
                fontSize: 18.0,
              ),
            ),
          );
        }
        final normalChats =
            snapshot.data.where((chat) => chat.type == ChatType.normal);
        final unknownChats =
            snapshot.data.where((chat) => chat.type == ChatType.unknown);
        return RefreshIndicator(
          backgroundColor: MyPalette.gold,
          onRefresh: () async => setState(() {}),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ChatsGroup(
                        title: 'New Matches',
                        child: MatchList(
                          matches: Provider.of<User>(context, listen: false)
                              .privateInfo
                              .matches,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ChatsGroup(
                        title: 'Messages',
                        child: ChatList(chats: normalChats),
                      ),
                      SizedBox(height: 20.0),
                      ChatsGroup(
                        title: 'Unknown messages',
                        child: ChatList(chats: unknownChats),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
