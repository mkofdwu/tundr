import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tundr/pages/chat/chat.dart';
import 'package:tundr/pages/its_a_match.dart';
import 'package:tundr/repositories/user.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/notifications_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/show_info_dialog.dart';

class NotificationHandler extends StatefulWidget {
  final Widget child;

  NotificationHandler({Key key, this.child}) : super(key: key);

  @override
  _NotificationHandlerState createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  final _fcm = FirebaseMessaging();

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
        print('MESSAGE RECEIVED: $message');
        // i've deemed the appropriate behaviour to do nothing
      },
      onResume: _handleNotificationClick,
      onLaunch: _handleNotificationClick,
    );
  }

  Future<void> _handleNotificationClick(Map<String, dynamic> message) async {
    print('notification received: $message');
    final messageType = message['data']['type'];
    if (messageType == 'newMatch') {
      final otherProfile =
          await UsersService.getUserProfile(message['data']['uid']);
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItsAMatchPage(profile: otherProfile),
        ),
      );
    } else if (messageType == 'newMessage') {
      final uid = Provider.of<User>(context, listen: false).profile.uid;
      final chat = await ChatsService.getChat(uid, message['data']['chatId']);
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatPage(chat: chat)),
      );
    }
  }

  void _saveDeviceToken() async {
    final token = await _fcm.getToken();
    if (token != null) {
      print('fcm token: ' + token);
      Provider.of<User>(context, listen: false).fcmToken = token;
      final uid = auth.FirebaseAuth.instance.currentUser.uid;
      await NotificationsService.saveToken(uid, token);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
