import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/widgets.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/current-user.dart';
import 'package:tundr/services/database-service.dart';

class NotificationHandler extends StatefulWidget {
  final Widget child;

  NotificationHandler({Key key, this.child}) : super(key: key);

  @override
  _NotificationHandlerState createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      _fcm.onIosSettingsRegistered.listen((data) => _saveDeviceToken());
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _saveDeviceToken();
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        // switch (message["data"]["type"]) {
        //   case "newMatch":
        //     _openItsAMatch(message["data"]["uid"]);
        //     break;
        //   case "newMessage":
        //     final String currentUid =
        //         Provider.of<CurrentUser>(context).user.uid;
        //     final LocalDatabaseService localDatabaseService =
        //         DatabaseService;

        //     final Message userMessage = await DatabaseService.retrieveMessage(
        //         currentUid, message["data"]["id"]);
        //     localDatabaseService.saveMessage(userMessage);
        //     DatabaseService.clearMessage(currentUid, userMessage.id);

        //     if (await localDatabaseService.chatExists(userMessage.uid)) {
        //       localDatabaseService.setChatUpdated(userMessage.uid);
        //     } else {
        //       localDatabaseService.saveUnknownChat(userMessage.uid);
        //     }

        //     break;
        // }
      },
      onResume: _handleNotificationClick,
      onLaunch: _handleNotificationClick,
    );
  }

  // _match(String uid) async {
  //   DatabaseService.saveMatch(uid);
  //   final User user = await DatabaseService.getUser(uid);
  //   Navigator.push(
  //     context,
  //     PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) =>
  //           ItsAMatchPage(user: user),
  //     ),
  //   );
  // }

  Future<void> _handleNotificationClick(Map<String, dynamic> message) async {
    // switch (message["data"]["type"]) {
    //   case "newMatch":
    //     _openItsAMatch(message["data"]["uid"]);
    //     break;
    //   case "newMessage":
    //     final String currentUid = Provider.of<CurrentUser>(context).user.uid;
    //     final LocalDatabaseService localDatabaseService =
    //         DatabaseService;

    //     final Message userMessage = await DatabaseService.retrieveMessage(
    //         currentUid, message["data"]["id"]);
    //     localDatabaseService.saveMessage(userMessage);
    //     DatabaseService.clearMessage(currentUid, userMessage.id);

    //     ChatType chatType;
    //     if (await localDatabaseService.chatExists(userMessage.uid)) {
    //       localDatabaseService.setChatUpdated(userMessage.uid);
    //       chatType = await localDatabaseService.getChatType(userMessage.uid);
    //     } else {
    //       localDatabaseService.saveUnknownChat(userMessage.uid);
    //       chatType = ChatType.unknown;
    //     }

    //     Navigator.push(
    //       context,
    //       PageRouteBuilder(
    //         pageBuilder: (context, animation1, animation2) => ChatPage(
    //           uid: message["data"]["uid"],
    //           chatType: chatType,
    //         ),
    //       ),
    //     );
    //     break;
    // }
  }

  _saveDeviceToken() async {
    final String token = await _fcm.getToken();
    if (token != null) {
      Provider.of<CurrentUser>(context).fcmToken = token;
      final String uid = (await FirebaseAuth.instance.currentUser()).uid;
      DatabaseService.saveToken(uid, token);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
