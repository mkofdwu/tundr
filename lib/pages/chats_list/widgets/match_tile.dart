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

  void _openChat(context, profile) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            chat: Chat(
              id: null,
              otherProfile: profile,
              wallpaperUrl: '',
              lastRead: null,
              type: ChatType.newMatch,
            ),
          ),
        ),
      );

  Widget _buildDark(context, profile) => GestureDetector(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: MyPalette.white, width: 1),
          ),
          child:
              profile == null ? null : getNetworkImage(profile.profileImageUrl),
        ),
        onTap: () => _openChat(context, profile),
      );

  Widget _buildLight(context, profile) => GestureDetector(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [MyPalette.secondaryShadow],
          ),
          child: profile == null
              ? null
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: getNetworkImage(profile.profileImageUrl),
                ),
        ),
        onTap: () => _openChat(context, profile),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: UsersService.getUserProfile(uid),
      builder: (context, snapshot) {
        return ThemeBuilder(
          buildDark: () => _buildDark(context, snapshot.data),
          buildLight: () => _buildLight(context, snapshot.data),
        );
      },
    );
  }
}
