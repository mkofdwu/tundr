import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/user.dart';

import 'package:tundr/pages/chat/chat.dart';
import 'package:tundr/pages/other_profile/about_me.dart';
import 'package:tundr/pages/other_profile/extra_media.dart';
import 'package:tundr/pages/other_profile/personal_info.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/buttons/back.dart';
import 'package:tundr/widgets/buttons/dark_tile.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';

class OtherProfileMainPage extends StatefulWidget {
  @override
  _OtherProfileMainPageState createState() => _OtherProfileMainPageState();
}

class _OtherProfileMainPageState extends State<OtherProfileMainPage> {
  bool _hasInfoLeft(UserProfile user) =>
      user.aboutMe.isNotEmpty ||
      user.extraMedia.any((media) => media != null) ||
      user.interests.isNotEmpty ||
      user.personalInfo.isNotEmpty;

  void _nextPage(UserProfile user) {
    Widget page;
    if (user.aboutMe.isNotEmpty) {
      page = OtherProfileAboutMePage(profile: user);
    } else if (user.extraMedia.any((media) => media != null)) {
      page = OtherProfileExtraMediaPage(profile: user);
    } else if (user.interests.isNotEmpty || user.personalInfo.isNotEmpty) {
      page = OtherProfilePersonalInfoPage(profile: user);
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
    final my = Provider.of<User>(context, listen: false).profile;
    final otherProfile =
        ModalRoute.of(context).settings.arguments as UserProfile;
    return ScrollDownPage(
      builder: (context, width, height) => Stack(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(),
            child: Hero(
              tag: otherProfile.profileImageUrl,
              child: getNetworkImage(otherProfile.profileImageUrl),
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
          MyBackButton(),
          if (otherProfile.uid != my.uid)
            Align(
              alignment: Alignment.topRight,
              child: FutureBuilder(
                future: Future.wait([
                  UsersService.allowedToTalkTo(otherProfile.uid),
                  ChatsService.getChatFromUid(my.uid, otherProfile.uid),
                ]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox.shrink();

                  final iBlockedUser = Provider.of<User>(context, listen: false)
                      .privateInfo
                      .blocked
                      .contains(otherProfile.uid);
                  final allowedToTalk = snapshot.data[0];
                  final chat = snapshot.data[1];

                  if (iBlockedUser) {
                    return DarkTileButton(
                      child: Text(
                        'Unblock',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      color: MyPalette.red,
                      onTap: () async {
                        Provider.of<User>(context, listen: false)
                            .privateInfo
                            .blocked
                            .remove(otherProfile.uid);
                        await Provider.of<User>(context, listen: false)
                            .writeField('blocked', UserPrivateInfo);
                        setState(() {});
                      },
                    );
                  }
                  if (allowedToTalk) {
                    return TileIconButton(
                      icon: Icons.chat_bubble_outline,
                      onPressed: () {
                        return Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                ChatPage(otherUser: otherProfile, chat: chat),
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
                  }
                  return SizedBox.shrink();
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
                    tag: otherProfile.username,
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        '${otherProfile.name}, ${otherProfile.ageInYears}',
                        style: TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  _hasInfoLeft(otherProfile)
                      ? ScrollDownArrow(
                          dark: fromTheme(
                            context,
                            dark: true,
                            light: false,
                          ),
                          onNextPage: () => _nextPage(otherProfile),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
      canScrollUp: false,
      canScrollDown: _hasInfoLeft(otherProfile),
      onScrollDown: () => _nextPage(otherProfile),
    );
  }
}
