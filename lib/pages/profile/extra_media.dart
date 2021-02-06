import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/pages/profile/utils/find_next_route.dart';
import 'package:tundr/store/theme_manager.dart';

import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class ExtraMediaProfilePage extends StatefulWidget {
  @override
  _ExtraMediaProfilePageState createState() => _ExtraMediaProfilePageState();
}

class _ExtraMediaProfilePageState extends State<ExtraMediaProfilePage> {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 1);

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
        if (findNextRoute('/profile/extra_media', profile) != null) {
          _nextPage(profile);
        }
      }
    });
  }

  void _nextPage(profile) {
    Navigator.pushNamed(
      context,
      findNextRoute('/profile/extra_media', profile),
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
          SingleChildScrollView(
            controller: _scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height + 2),
              child: Column(
                children: profile.extraMedia
                    .map((media) => media == null
                        ? SizedBox.shrink()
                        : MediaThumbnail(media))
                    .toList(),
              ),
            ),
          ),
          SafeArea(
            child: TileIconButton(
              icon: Icons.close,
              iconColor: MyPalette.white,
              onPressed: () {
                Navigator.popUntil(
                    context, (route) => route.settings.name == '/profile');
                Navigator.pop(context);
              },
            ),
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
          findNextRoute('/profile/extra_media', profile) != null
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
