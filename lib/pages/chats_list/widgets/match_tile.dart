import 'package:flutter/material.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/pages/chat/chat.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/theme_builder.dart';

class MatchTile extends StatefulWidget {
  final String uid;

  MatchTile({Key key, @required this.uid}) : super(key: key);

  @override
  _MatchTileState createState() => _MatchTileState();
}

class _MatchTileState extends State<MatchTile> {
  bool _pressed = false;

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

  Widget _buildDark(context, profile) => Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: MyPalette.white, width: 2),
        ),
        child:
            profile == null ? null : getNetworkImage(profile.profileImageUrl),
      );

  Widget _buildLight(context, profile) => AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            _pressed ? MyPalette.primaryShadow : MyPalette.secondaryShadow
          ],
        ),
        transform:
            _pressed ? Matrix4.translationValues(0, 4, 0) : Matrix4.identity(),
        child: profile == null
            ? null
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: getNetworkImage(profile.profileImageUrl),
              ),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: UsersService.getUserProfile(widget.uid),
      builder: (context, snapshot) {
        final profile = snapshot.data;
        return GestureDetector(
          child: ThemeBuilder(
            buildDark: () => _buildDark(context, profile),
            buildLight: () => _buildLight(context, profile),
          ),
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            _openChat(context, profile);
          },
          onTapCancel: () => setState(() => _pressed = false),
        );
      },
    );
  }
}
