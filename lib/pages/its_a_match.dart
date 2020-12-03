import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/user_profile.dart';

import 'package:tundr/pages/chat/chat.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/chat_type.dart';

class ItsAMatchPage extends StatelessWidget {
  // FUTURE: create enum `MatchAction` with undo, saySomething, continue, which is popped back to swipingpage which performs the action
  final UserProfile user;

  ItsAMatchPage({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top;
    return Material(
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: CachedNetworkImage(
              imageUrl: user.profileImageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.9),
                  Color.fromRGBO(0, 0, 0, 0.2)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            top: height * 80 / 736,
            left: 40,
            child: Container(
              width: 120,
              height: 180,
              decoration: BoxDecoration(
                color: MyPalette.darkGrey,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    offset: Offset(0, 30),
                    blurRadius: 30,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: height * 110 / 736,
            left: 65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Congratulations',
                  style: TextStyle(
                    color: MyPalette.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'Donald liked you too!',
                  style: TextStyle(color: MyPalette.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: height * 528 / 812,
            child: GestureDetector(
              child: Container(
                width: width * 207 / 414,
                height: height * 43 / 812,
                color: MyPalette.gold,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 50,
                      top: 10,
                      child: Text(
                        'Say something ...',
                        style: TextStyle(
                          color: MyPalette.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.pop(context, false);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => ChatPage(
                      otherUser: user,
                      chat: Chat(
                        id: null,
                        uid: user.uid,
                        wallpaperUrl: '',
                        lastRead: null,
                        type: ChatType.newMatch,
                      ),
                    ),
                    transitionsBuilder:
                        (context, animation1, animation2, child) {
                      return FadeTransition(
                        opacity: animation1,
                        child: child,
                      ); // FUTURE: better transition?
                    },
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            top: height * 589 / 812,
            child: Container(
              width: width * 250 / 375,
              height: height * 27 / 812,
              color: MyPalette.green,
            ),
          ),
          Positioned(
            left: 0,
            top: height * 634 / 812,
            child: GestureDetector(
              child: Container(
                width: width * 175 / 375,
                height: height * 29 / 812,
                color: MyPalette.white,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 40,
                      top: 2,
                      child: Text(
                        'Undo',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () => Navigator.pop(context, true),
            ),
          ),
          Positioned(
            top: height * 752 / 812,
            right: 0,
            child: GestureDetector(
              child: Container(
                width: width * 178 / 375,
                height: height * 28 / 812,
                color: MyPalette.white,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 20,
                      top: 0,
                      child: Text(
                        'Continue',
                        style: TextStyle(color: MyPalette.gold, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () => Navigator.pop(context, false),
            ),
          ),
        ],
      ),
    );
  }
}
