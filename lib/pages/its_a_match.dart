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
                  Color.fromRGBO(0, 0, 0, 0.8),
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
            top: height * 345 / 736,
            width: width * 104 / 414,
            height: 4,
            child: Container(color: MyPalette.black),
          ),
          Positioned(
            top: height * 365 / 736,
            width: width * 217 / 414,
            height: height * 46 / 736,
            child: GestureDetector(
              child: Container(
                color: MyPalette.gold,
                padding: const EdgeInsets.only(left: 26, bottom: 10),
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Say something...',
                  style: TextStyle(fontSize: 18, color: MyPalette.white),
                ),
              ),
              onTap: () {
                Navigator.pop(context, false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      otherUser: user,
                      chat: Chat(
                        id: null,
                        uid: user.uid,
                        wallpaperUrl: '',
                        lastRead: null,
                        type: ChatType.newMatch,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: height * 425 / 736,
            width: width * 156 / 414,
            height: height * 16 / 736,
            child: Container(color: MyPalette.white),
          ),
          Positioned(
            top: height * 448 / 736,
            width: width * 194 / 414,
            height: 3,
            child: Container(color: Color(0xFF848484)),
          ),
          Positioned(
            top: height * 488 / 736,
            width: width * 86 / 414,
            height: 8,
            child: Container(color: Color(0xFFC4C4C4)),
          ),
          Positioned(
            top: height * 503 / 736,
            width: width * 114 / 414,
            height: height * 39 / 736,
            child: GestureDetector(
              child: Container(
                color: MyPalette.white,
                padding: const EdgeInsets.only(top: 14, left: 36),
                child: Text(
                  'Undo',
                  style: TextStyle(fontSize: 14, color: MyPalette.black),
                ),
              ),
              onTap: () => Navigator.pop(context, true),
            ),
          ),
          Positioned(
            top: height * 551 / 736,
            width: width * 67 / 414,
            height: height * 17 / 736,
            child: Container(color: MyPalette.black),
          ),
          Positioned(
            right: 0,
            top: height * 590 / 736,
            width: width * 70 / 414,
            height: height * 12 / 736,
            child: Container(color: MyPalette.gold),
          ),
          Positioned(
            right: 0,
            top: height * 608 / 736,
            width: width * 134 / 414,
            height: height * 35 / 736,
            child: GestureDetector(
              child: Container(
                color: MyPalette.black,
                padding: const EdgeInsets.only(right: 20, bottom: 8),
                alignment: Alignment.bottomRight,
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, color: MyPalette.white),
                ),
              ),
              onTap: () => Navigator.pop(context, false),
            ),
          ),
          Positioned(
            right: 0,
            top: height * 648 / 736,
            width: width * 121 / 414,
            height: 3,
            child: Container(color: MyPalette.black),
          ),
        ],
      ),
    );
  }
}
