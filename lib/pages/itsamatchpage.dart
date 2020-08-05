import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/pages/chat/chatpage.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/utils/constants/enums/chattype.dart';
import 'package:tundr/utils/constants/gradients.dart';

class ItsAMatchPage extends StatelessWidget {
  // FUTURE: create enum `MatchAction` with undo, saySomething, continue, which is popped back to swipingpage which performs the action
  final User user;

  ItsAMatchPage({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top;
    return SafeArea(
      child: Material(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(user.profileImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  color: AppColors.black.withOpacity(0.2),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: Gradients.transparentToBlack,
                ),
              ),
            ),
            Positioned(
              left: width * 100 / 375,
              top: height * 191 / 812,
              child: Container(
                width: width * 248 / 375,
                height: height * 199 / 812,
                color: AppColors.green,
              ),
            ),
            Positioned(
              left: width * 26 / 375,
              top: height * 79 / 812,
              child: Container(
                width: width * 162 / 375,
                height: height * 285 / 812,
                color: AppColors.white,
              ),
            ),
            Positioned(
              left: width * 49 / 375,
              top: height * 90 / 812,
              child: Text(
                "Congratulations",
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 40.0,
                ),
              ),
            ),
            Positioned(
              left: width * 117 / 375,
              top: height * 235 / 812,
              child: Container(
                width: width * 195 / 375,
                height: height * 195 / 812,
                padding: EdgeInsets.all(20.0), // or 10
                color: AppColors.grey,
                child: Text(
                  "${user.name} liked you\ntoo!",
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: "Helvetica Neue",
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              top: height * 524 / 812,
              child: Container(
                width: width * 82 / 375,
                height: height * 96 / 812,
                color: AppColors.grey,
              ),
            ),
            Positioned(
              left: 0.0,
              top: height * 528 / 812,
              child: GestureDetector(
                child: Container(
                  width: width * 224 / 375,
                  height: height * 43 / 812,
                  color: AppColors.gold,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 50.0,
                        top: 10.0,
                        child: Text(
                          "Say something ...",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20.0,
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
                      pageBuilder: (context, animation1, animation2) =>
                          ChatPage(
                        user: user,
                        chat: Chat(
                          id: null,
                          uid: user.uid,
                          wallpaperUrl: "",
                          lastReadTimestamp: null,
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
              left: 0.0,
              top: height * 589 / 812,
              child: Container(
                width: width * 250 / 375,
                height: height * 27 / 812,
                color: AppColors.green,
              ),
            ),
            Positioned(
              left: 0.0,
              top: height * 634 / 812,
              child: GestureDetector(
                child: Container(
                  width: width * 175 / 375,
                  height: height * 29 / 812,
                  color: AppColors.white,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 40.0,
                        top: 2.0,
                        child: Text(
                          "Undo",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.pop(context, true),
              ),
            ),
            Positioned(
              left: 0.0,
              top: height * 666 / 812,
              child: Container(
                width: width * 159 / 375,
                height: height * 6 / 812,
                color: AppColors.white,
              ),
            ),
            Positioned(
              left: 0.0,
              top: height * 687 / 812,
              child: Container(
                width: width * 43 / 375,
                height: height * 30 / 812,
                color: AppColors.white,
              ),
            ),
            Positioned(
              left: 0.0,
              top: height * 689 / 812,
              child: Container(
                width: width * 120 / 375,
                height: height * 12 / 812,
                color: AppColors.green,
              ),
            ),
            Positioned(
              left: 0.0,
              top: height * 703 / 812,
              child: Container(
                width: width * 145 / 375,
                height: height * 4 / 812,
                color: AppColors.gold,
              ),
            ),
            Positioned(
              left: 0.0,
              top: height * 721 / 812,
              child: Container(
                width: width * 32 / 375,
                height: height * 4 / 812,
                color: AppColors.white,
              ),
            ),
            Positioned(
              left: 0.0,
              top: height * 737 / 812,
              child: Container(
                width: width * 101 / 375,
                height: height * 15 / 812,
                color: AppColors.white,
              ),
            ),
            Positioned(
              top: height * 669 / 812,
              right: 0.0,
              child: Container(
                width: width * 33 / 375,
                height: height * 30 / 812,
                color: AppColors.white,
              ),
            ),
            Positioned(
              top: height * 712 / 812,
              right: 0.0,
              child: Container(
                width: width * 40 / 375,
                height: height * 5 / 812,
                color: AppColors.green,
              ),
            ),
            Positioned(
              top: height * 725 / 812,
              right: 0.0,
              child: Container(
                width: width * 32 / 375,
                height: height * 5 / 812,
                color: AppColors.gold,
              ),
            ),
            Positioned(
              top: height * 737 / 812,
              right: 0.0,
              child: Container(
                width: width * 64 / 375,
                height: height * 8 / 812,
                color: AppColors.white,
              ),
            ),
            Positioned(
              top: height * 752 / 812,
              right: 0.0,
              child: GestureDetector(
                child: Container(
                  width: width * 178 / 375,
                  height: height * 28 / 812,
                  color: AppColors.white,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 20.0,
                        top: 0.0,
                        child: Text(
                          "Continue",
                          style:
                              TextStyle(color: AppColors.gold, fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => Navigator.pop(context, false),
              ),
            ),
            Positioned(
              top: height * 784 / 812,
              right: 0.0,
              child: Container(
                width: width * 156 / 375,
                height: height * 5 / 812,
                color: AppColors.white,
              ),
            ),
            Positioned(
              top: height * 792 / 812,
              right: 0.0,
              child: Container(
                width: width * 90 / 375,
                height: height * 11 / 812,
                color: AppColors.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
