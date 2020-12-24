import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/models/user_private_info.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/user.dart';

import 'package:tundr/pages/chat/chat.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/services/chats_service.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/buttons/back.dart';
import 'package:tundr/widgets/buttons/text.dart';
import 'package:tundr/widgets/pages/scroll_down.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/verified_badge.dart';

class MainProfilePage extends StatefulWidget {
  @override
  _MainProfilePageState createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  bool _hasInfoLeft(UserProfile profile) =>
      profile.aboutMe.isNotEmpty ||
      profile.extraMedia.any((media) => media != null) ||
      profile.interests.isNotEmpty ||
      profile.personalInfo.isNotEmpty;

  void _nextPage(UserProfile profile) {
    String route;
    if (profile.aboutMe.isNotEmpty) {
      route = '/profile/about_me';
    } else if (profile.extraMedia.any((media) => media != null)) {
      route = '/profile/extra_media';
    } else if (profile.interests.isNotEmpty ||
        profile.personalInfo.isNotEmpty) {
      route = '/profile/personal_info';
    } else {
      throw Exception('No pages left');
    }
    Navigator.pushNamed(context, route, arguments: profile);
  }

  Widget _buildUserAction(myProfile, otherProfile) => SafeArea(
        child: Align(
          alignment: Alignment.topRight,
          child: Provider.of<User>(context, listen: false)
                  .privateInfo
                  .blocked
                  .contains(otherProfile.uid)
              ? SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: MyTextButton(
                        text: 'Unblock',
                        onTap: () async {
                          Provider.of<User>(context, listen: false)
                              .privateInfo
                              .blocked
                              .remove(otherProfile.uid);
                          await Provider.of<User>(context, listen: false)
                              .writeField('blocked', UserPrivateInfo);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                )
              : FutureBuilder(
                  future: UsersService.canTalkTo(otherProfile.uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !snapshot.data) {
                      return SizedBox.shrink();
                    }
                    return TileIconButton(
                      icon: Icons.chat_bubble_outline,
                      iconColor: MyPalette.white,
                      onPressed: () async {
                        final chat = await ChatsService.getChatFromProfile(
                          myProfile.uid,
                          otherProfile,
                        );
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(chat: chat),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final myProfile = Provider.of<User>(context).profile;
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
              height: 200,
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
              height: 200,
              decoration: BoxDecoration(
                gradient: fromTheme(
                  context,
                  dark: MyPalette.transparentToBlack,
                  light: MyPalette.transparentToGold,
                ),
              ),
            ),
          ),
          MyBackButton(iconColor: MyPalette.white),
          if (otherProfile.uid != myProfile.uid)
            _buildUserAction(myProfile, otherProfile),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Hero(
                    tag: otherProfile.username,
                    child: Material(
                      color: Colors.transparent,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${otherProfile.name}, ${otherProfile.ageInYears}',
                              style: TextStyle(
                                color: MyPalette.white,
                                fontSize: 40,
                              ),
                            ),
                            if (otherProfile.verified)
                              WidgetSpan(
                                child: VerifiedBadge(
                                  color: MyPalette.white,
                                  size: 34,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  _hasInfoLeft(otherProfile)
                      ? ScrollDownArrow(
                          dark: true,
                          onNextPage: () => _nextPage(otherProfile),
                        )
                      : SizedBox.shrink(),
                  SizedBox(height: 20),
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
