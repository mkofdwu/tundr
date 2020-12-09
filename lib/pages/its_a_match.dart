import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/user_profile.dart';

import 'package:tundr/pages/chat/chat.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/chat_type.dart';

class ItsAMatchPage extends StatefulWidget {
  // FUTURE: create enum `MatchAction` with undo, saySomething, continue, which is popped back to swipingpage which performs the action
  final UserProfile profile;

  ItsAMatchPage({
    Key key,
    @required this.profile,
  }) : super(key: key);

  @override
  _ItsAMatchPageState createState() => _ItsAMatchPageState();
}

class _ItsAMatchPageState extends State<ItsAMatchPage> {
  bool _saySomethingPressed = false;
  bool _undoPressed = false;
  bool _continuePressed = false;

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
              imageUrl: widget.profile.profileImageUrl,
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                color: MyPalette.gold,
                padding: const EdgeInsets.only(left: 26, bottom: 10),
                alignment: Alignment.bottomLeft,
                transform: _saySomethingPressed
                    ? Matrix4.translationValues(-14, 0, 0)
                    : Matrix4.identity(),
                child: Text(
                  'Say something...',
                  style: TextStyle(fontSize: 18, color: MyPalette.white),
                ),
              ),
              onTapDown: (_) => setState(() => _saySomethingPressed = true),
              onTapUp: (_) {
                setState(() => _saySomethingPressed = false);
                Navigator.pop(context, false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      otherUser: widget.profile,
                      chat: Chat(
                        id: null,
                        uid: widget.profile.uid,
                        wallpaperUrl: '',
                        lastRead: null,
                        type: ChatType.newMatch,
                      ),
                    ),
                  ),
                );
              },
              onTapCancel: () => setState(() => _saySomethingPressed = false),
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                color: MyPalette.white,
                padding: const EdgeInsets.only(top: 14, left: 36),
                transform: _undoPressed
                    ? Matrix4.translationValues(-10, 0, 0)
                    : Matrix4.identity(),
                child: Text(
                  'Undo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: MyPalette.black,
                  ),
                ),
              ),
              onTapDown: (_) => setState(() => _undoPressed = true),
              onTapUp: (_) {
                setState(() => _undoPressed = false);
                Navigator.pop(context, true);
              },
              onTapCancel: () => setState(() => _undoPressed = false),
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                color: MyPalette.black,
                padding: const EdgeInsets.only(right: 20, bottom: 8),
                alignment: Alignment.bottomRight,
                transform: _continuePressed
                    ? Matrix4.translationValues(10, 0, 0)
                    : Matrix4.identity(),
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, color: MyPalette.white),
                ),
              ),
              onTapDown: (_) => setState(() => _continuePressed = true),
              onTapUp: (_) {
                setState(() => _continuePressed = false);
                Navigator.pop(context, false);
              },
              onTapCancel: () => setState(() => _continuePressed = false),
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
