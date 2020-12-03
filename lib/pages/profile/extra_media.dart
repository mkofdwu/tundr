import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/theme_manager.dart';

import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class ExtraMediaProfilePage extends StatefulWidget {
  @override
  _ExtraMediaProfilePageState createState() => _ExtraMediaProfilePageState();
}

class _ExtraMediaProfilePageState extends State<ExtraMediaProfilePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset == 0) {
        Navigator.pop(context);
      } else if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        final profile =
            ModalRoute.of(context).settings.arguments as UserProfile;
        if (_hasInfoLeft(profile)) {
          _nextPage(profile);
        }
      }
    });
  }

  bool _hasInfoLeft(profile) =>
      profile.interests.isNotEmpty || profile.personalInfo.isNotEmpty;

  void _nextPage(profile) {
    Navigator.pushNamed(
      context,
      '/profile/personal_info',
      arguments: profile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final profile = ModalRoute.of(context).settings.arguments as UserProfile;
    return Material(
      child: Stack(
        children: <Widget>[
          ListView.builder(
            padding: const EdgeInsets.symmetric(
                vertical: 1), // to scroll up and down
            controller: _scrollController,
            itemCount: 10,
            itemBuilder: (context, i) {
              if (i == 9) return SizedBox(height: 200);
              if (profile.extraMedia[i] == null) {
                return SizedBox.shrink();
              }
              return MediaThumbnail(profile.extraMedia[i]);
            },
          ),
          TileIconButton(
            icon: Icons.close,
            onPressed: () {
              Navigator.popUntil(
                  context, (route) => route.settings.name == '/profile');
              Navigator.pop(context);
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: 150,
              decoration: BoxDecoration(
                gradient:
                    Provider.of<ThemeManager>(context).theme == ThemeMode.dark
                        ? MyPalette.transparentToBlack
                        : MyPalette.transparentToGold,
              ),
            ),
          ),
          _hasInfoLeft(profile)
              ? Positioned(
                  left: width * 179 / 375,
                  bottom: 20,
                  child: ScrollDownArrow(onNextPage: () => _nextPage(profile)),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
