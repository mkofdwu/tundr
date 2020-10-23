import 'package:flutter/material.dart';
import 'package:tundr/models/chat.dart';
import 'package:tundr/pages/chat/chat.dart';
import 'package:tundr/services/database_service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/enums/chat_type.dart';
import 'package:tundr/constants/shadows.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/theme_builder.dart';

class MatchTile extends StatelessWidget {
  final String uid;

  MatchTile({Key key, @required this.uid}) : super(key: key);

  Future<dynamic> _openChat(BuildContext context) async {
    final user = await DatabaseService.getUser(uid);
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => ChatPage(
          user: user,
          chat: Chat(
            id: null,
            uid: uid,
            wallpaperUrl: '',
            lastReadTimestamp: null,
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
        child: FutureBuilder(
          future: DatabaseService.getUserField(uid, 'profileImageUrl'),
          builder: (context, snapshot) {
            return Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.white, width: 1.0),
              ),
              child: snapshot.hasData ? getNetworkImage(snapshot.data) : null,
            );
          },
        ),
        onTap: () => _openChat(context),
      );

  Widget _buildLight(BuildContext context) => GestureDetector(
        child: FutureBuilder(
          future: DatabaseService.getUserField(uid, 'profileImageUrl'),
          builder: (context, snapshot) {
            return Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [Shadows.secondaryShadow],
              ),
              child: snapshot.hasData
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: getNetworkImage(snapshot.data),
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
