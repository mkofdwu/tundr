import 'package:flutter/material.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/pages/chat/chat.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/theme_builder.dart';

class MatchTile extends StatelessWidget {
  final String uid;

  MatchTile({Key key, @required this.uid}) : super(key: key);

  Future<dynamic> _openChat(BuildContext context) async {
    final user = await UsersService.getUserProfile(uid);
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => ChatPage(
          otherUser: user,
          chat: Chat(
            id: null,
            uid: uid,
            wallpaperUrl: '',
            lastRead: null,
            type: ChatType.newMatch,
          ),
        ),
        transitionsBuilder: (context, animation1, animation2, child) {
          return FadeTransition(opacity: animation1, child: child);
        },
      ),
    );
  }

  Widget _buildDark(BuildContext context) => GestureDetector(
        child: FutureBuilder<UserProfile>(
          future: UsersService.getUserProfile(uid),
          builder: (context, snapshot) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: MyPalette.white, width: 1),
              ),
              child: snapshot.hasData
                  ? getNetworkImage(snapshot.data.profileImageUrl)
                  : null,
            );
          },
        ),
        onTap: () => _openChat(context),
      );

  Widget _buildLight(BuildContext context) => GestureDetector(
        child: FutureBuilder<UserProfile>(
          future: UsersService.getUserProfile(uid),
          builder: (context, snapshot) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [MyPalette.secondaryShadow],
              ),
              child: snapshot.hasData
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: getNetworkImage(snapshot.data.profileImageUrl),
                    )
                  : null,
            );
          },
        ),
        onTap: () => _openChat(context),
      );

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      buildDark: () => _buildDark(context),
      buildLight: () => _buildLight(context),
    );
  }
}
