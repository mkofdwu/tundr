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
  final Chat chat;

  MatchTile({Key key, @required this.chat}) : super(key: key);

  @override
  _MatchTileState createState() => _MatchTileState();
}

class _MatchTileState extends State<MatchTile> {
  bool _pressed = false;

  void _openChat() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(chat: widget.chat),
        ),
      );

  Widget _buildDark() => Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: MyPalette.white, width: 2),
        ),
        child: getNetworkImage(widget.chat.otherProfile.profileImageUrl),
      );

  Widget _buildLight() => AnimatedContainer(
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: getNetworkImage(widget.chat.otherProfile.profileImageUrl),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ThemeBuilder(
        buildDark: _buildDark,
        buildLight: _buildLight,
      ),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _openChat();
      },
      onTapCancel: () => setState(() => _pressed = false),
    );
  }
}
