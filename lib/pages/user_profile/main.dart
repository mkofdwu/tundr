import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/current_user.dart';

import 'package:tundr/pages/chat/chat.dart';
import 'package:tundr/pages/user_profile/about_me.dart';
import 'package:tundr/pages/user_profile/extra_media.dart';
import 'package:tundr/pages/user_profile/personal_info.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/buttons/dark_tile.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';

class UserProfileMainPage extends StatefulWidget {
  @override
  _UserProfileMainPageState createState() => _UserProfileMainPageState();
}

class _UserProfileMainPageState extends State<UserProfileMainPage> {
  bool _hasInfoLeft(UserProfile user) =>
      user.aboutMe.isNotEmpty ||
      user.extraMedia.any((media) => media != null) ||
      user.interests.isNotEmpty ||
      user.personalInfo.isNotEmpty;

  void _nextPage(UserProfile user) {
    Widget page;
    if (user.aboutMe.isNotEmpty) {
      page = UserProfileAboutMePage(profile: user);
    } else if (user.extraMedia.any((media) => media != null)) {
      page = UserProfileExtraMediaPage(profile: user);
    } else if (user.interests.isNotEmpty || user.personalInfo.isNotEmpty) {
      page = UserProfilePersonalInfoPage(profile: user);
    } else {
      throw Exception('No pages left');
    }

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
    final my = Provider.of<CurrentUser>(context).profile;
    final profile = ModalRoute.of(context).settings.arguments;
    return GestureDetector(
      child: SafeArea(
        child: Material(
          child: Stack(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(),
                child: Hero(
                  tag: profile.profileImageUrl,
                  child: getNetworkImage(profile.profileImageUrl),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    gradient: fromTheme(
                      context,
                      dark: MyPalette.blackToTransparent,
                      light: MyPalette.goldToTransparent,
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
                      dark: MyPalette.transparentToBlack,
                      light: MyPalette.transparentToGold,
                    ),
                  ),
                ),
              ),
              TileIconButton(
                icon: Icons.arrow_back,
                onPressed: () => Navigator.pop(context),
              ),
              if (profile.uid != my.uid)
                Align(
                  alignment: Alignment.topRight,
                  child: FutureBuilder(
                    future: Future.wait([
                      UsersService.blocked(my.uid, profile.uid),
                      UsersService.blocked(profile.uid, my.uid),
                      ChatsService.getChatFromUid(my.uid, profile.uid),
                    ]),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return SizedBox.shrink();

                      final bool iBlockedUser = snapshot.data[0];
                      final bool userBlockedMe = snapshot.data[1];
                      final Chat chat = snapshot.data[2];

                      if (iBlockedUser) {
                        return DarkTileButton(
                          child: Text(
                            'Unblock',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          color: MyPalette.red,
                          onTap: () {
                            UsersService.unblockUser(my.uid, profile.uid);
                            setState(() {});
                          },
                        );
                      }
                      if (userBlockedMe ||
                          (profile.blockUnknownMessages &&
                              chat.type == ChatType.nonExistent)) {
                        return SizedBox.shrink();
                      }
                      return TileIconButton(
                        icon: Icons.chat_bubble_outline,
                        onPressed: () {
                          return Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  ChatPage(otherUser: profile, chat: chat),
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
                        tag: profile.username,
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            '${profile.name}, ${profile.ageInYears}',
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      _hasInfoLeft(profile)
                          ? NextPageArrow(
                              dark: fromTheme(
                                context,
                                dark: true,
                                light: false,
                              ),
                              onNextPage: () => _nextPage(profile),
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
      onVerticalDragUpdate: _hasInfoLeft(profile)
          ? (DragUpdateDetails details) {
              if (details.delta.dy < -1.0) _nextPage(profile);
            }
          : null,
    );
  }
}
