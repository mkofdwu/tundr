import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/repositories/current_user.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/suggestions_service.dart';

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
  //     uid: Provider.of<CurrentUser>(context).profile.uid,
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
    final uid = Provider.of<CurrentUser>(context).profile.uid;
    return FutureBuilder<bool>(
      future: ChatsService.noChats(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: Loader());
        if (snapshot.data) {
          return Center(
            child: Text(
              'Matches and chats will appear here.',
              style: TextStyle(
                color: MyPalette.grey,
                fontSize: 16.0,
              ),
            ),
          );
        }
        return RefreshIndicator(
          color: Theme.of(context).accentColor,
          backgroundColor: MyPalette.gold,
          onRefresh: () async => setState(() {}), // _loadMessages,
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
                      FutureBuilder<List<String>>(
                        future: SuggestionsService.getMatches(uid),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return SizedBox.shrink();
                          if (snapshot.data.isEmpty) return SizedBox.shrink();
                          return ChatsGroup(
                            title: 'New Matches',
                            child: MatchList(
                              matches: snapshot.data,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20.0),
                      FutureBuilder<List<Chat>>(
                        future:
                            ChatsService.getChatsOfType(uid, ChatType.normal),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return SizedBox.shrink();
                          if (snapshot.data.isEmpty) return SizedBox.shrink();
                          return ChatsGroup(
                            title: 'Messages',
                            child: ChatList(chats: snapshot.data),
                          );
                        },
                      ),
                      SizedBox(height: 20.0),
                      FutureBuilder<List<Chat>>(
                        future: ChatsService.getUnknownChats(uid),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return SizedBox.shrink();
                          if (snapshot.data.isEmpty) return SizedBox.shrink();
                          return ChatsGroup(
                            title: 'Unknown messages',
                            child: ChatList(chats: snapshot.data),
                          );
                        },
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
