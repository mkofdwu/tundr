import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/providerdata.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/pages/main/chatpage.dart';
import 'package:tundr/pages/userprofile/userprofileaboutmepage.dart';
import 'package:tundr/pages/userprofile/userprofileextramediapage.dart';
import 'package:tundr/pages/userprofile/userprofilepersonalinfo.dart';
import 'package:tundr/services/databaseservice.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/utils/constants/enums/chattype.dart';
import 'package:tundr/utils/constants/gradients.dart';
import 'package:tundr/utils/fromtheme.dart';
import 'package:tundr/utils/getnetworkimage.dart';
import 'package:tundr/widgets/buttons/darktilebutton.dart';
import 'package:tundr/widgets/nextpagearrow.dart';
import 'package:tundr/widgets/buttons/tileiconbutton.dart';

class UserProfileMainPage extends StatefulWidget {
  @override
  _UserProfileMainPageState createState() => _UserProfileMainPageState();
}

class _UserProfileMainPageState extends State<UserProfileMainPage> {
  bool _hasInfoLeft(User user) =>
      user.aboutMe.isNotEmpty ||
      user.extraMedia.any((media) => media != null) ||
      user.interests.isNotEmpty ||
      user.personalInfo.isNotEmpty;

  _nextPage(User user) {
    Widget page;
    if (user.aboutMe.isNotEmpty)
      page = UserProfileAboutMePage(user: user);
    else if (user.extraMedia.any((media) => media != null))
      page = UserProfileExtraMediaPage(user: user);
    else if (user.interests.isNotEmpty || user.personalInfo.isNotEmpty)
      page = UserProfilePersonalInfoPage(user: user);
    else
      throw Exception("No pages left");

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionsBuilder: (context, animation1, animation2, child) {
          return SlideTransition(
            position:
                Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                    .animate(animation1),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User my = Provider.of<ProviderData>(context).user;
    final User user = ModalRoute.of(context).settings.arguments;
    return GestureDetector(
      child: SafeArea(
        child: Material(
          child: Stack(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(),
                child: Hero(
                  tag: user.profileImageUrl,
                  child: getNetworkImage(user.profileImageUrl),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    gradient: fromTheme(
                      context,
                      dark: Gradients.blackToTransparent,
                      light: Gradients.goldToTransparent,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    gradient: fromTheme(
                      context,
                      dark: Gradients.transparentToBlack,
                      light: Gradients.transparentToGold,
                    ),
                  ),
                ),
              ),
              TileIconButton(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.pop(context),
              ),
              if (user.uid != my.uid)
                Align(
                  alignment: Alignment.topRight,
                  child: FutureBuilder(
                    future: Future.wait([
                      DatabaseService.blocked(my.uid, user.uid),
                      DatabaseService.blocked(user.uid, my.uid),
                      DatabaseService.getChatFromUid(my.uid, user.uid),
                    ]),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return SizedBox.shrink();

                      final bool iBlockedUser = snapshot.data[0];
                      final bool userBlockedMe = snapshot.data[1];
                      final Chat chat = snapshot.data[2];

                      if (iBlockedUser)
                        return DarkTileButton(
                          child: Text(
                            "Unblock",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          color: AppColors.red,
                          onTap: () {
                            DatabaseService.unblockUser(my.uid, user.uid);
                            setState(() {});
                          },
                        );
                      if (userBlockedMe ||
                          (user.blockUnknownMessages &&
                              chat.type == ChatType.nonExistent))
                        return SizedBox.shrink();
                      return TileIconButton(
                        icon: Icons.chat_bubble_outline,
                        onPressed: () {
                          return Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  ChatPage(user: user, chat: chat),
                              transitionsBuilder:
                                  (context, animation1, animation2, child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0.0, 1.0),
                                    end: Offset(0.0, 0.0),
                                  ).animate(animation1),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Hero(
                        tag: user.username,
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            "${user.name}, ${user.ageInYears}",
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "Popularity: ${user.popularityScore}",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 40.0),
                      _hasInfoLeft(user)
                          ? NextPageArrow(
                              dark: fromTheme(
                                context,
                                dark: true,
                                light: false,
                              ),
                              onNextPage: () => _nextPage(user),
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onVerticalDragUpdate: _hasInfoLeft(user)
          ? (DragUpdateDetails details) {
              if (details.delta.dy < -1.0) _nextPage(user);
            }
          : null,
    );
  }
}
