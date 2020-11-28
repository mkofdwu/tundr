import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/repositories/theme_manager.dart';

import 'package:tundr/pages/other_profile/personal_info.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';
import 'package:tundr/widgets/media/media_thumbnail.dart';
import 'package:tundr/widgets/scroll_down_arrow.dart';

class OtherProfileExtraMediaPage extends StatefulWidget {
  final UserProfile profile;

  OtherProfileExtraMediaPage({Key key, @required this.profile})
      : super(key: key);

  @override
  _OtherProfileExtraMediaPageState createState() =>
      _OtherProfileExtraMediaPageState();
}

class _OtherProfileExtraMediaPageState
    extends State<OtherProfileExtraMediaPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset == 0) {
        Navigator.pop(context);
      } else if (_scrollController.offset ==
          _scrollController.position.maxScrollExtent) {
        if (_hasInfoLeft()) {
          _nextPage();
        }
      }
    });
  }

  bool _hasInfoLeft() =>
      widget.profile.interests.isNotEmpty ||
      widget.profile.personalInfo.isNotEmpty;

  void _nextPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            OtherProfilePersonalInfoPage(profile: widget.profile),
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
    final width = MediaQuery.of(context).size.width;
    return Material(
      child: Stack(
        children: <Widget>[
          ListView.builder(
            padding: const EdgeInsets.symmetric(
                vertical: 1.0), // to scroll up and down
            controller: _scrollController,
            itemCount: 10,
            itemBuilder: (context, i) {
              if (i == 9) return SizedBox(height: 200.0);
              if (widget.profile.extraMedia[i] == null) {
                return SizedBox.shrink();
              }
              return MediaThumbnail(widget.profile.extraMedia[i]);
            },
          ),
          TileIconButton(
            icon: Icons.close,
            onPressed: () {
              Navigator.popUntil(
                  context, (route) => route.settings.name == '/user_profile');
              Navigator.pop(context);
            },
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              width: width,
              height: 150.0,
              decoration: BoxDecoration(
                gradient:
                    Provider.of<ThemeManager>(context).theme == ThemeMode.dark
                        ? MyPalette.transparentToBlack
                        : MyPalette.transparentToGold,
              ),
            ),
          ),
          _hasInfoLeft()
              ? Positioned(
                  left: width * 179 / 375,
                  bottom: 20.0,
                  child: ScrollDownArrow(onNextPage: _nextPage),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
