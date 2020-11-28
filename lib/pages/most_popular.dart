import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/repositories/theme_manager.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/loaders/loader.dart';

class MostPopularPage extends StatefulWidget {
  final double width;
  final double height;

  const MostPopularPage({
    Key key,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  @override
  _MostPopularPageState createState() => _MostPopularPageState();
}

class _MostPopularPageState extends State<MostPopularPage> {
  List<Widget> _positionedProfileImages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) => _loadPositionedProfileImages());
  }

  void _loadPositionedProfileImages() async {
    final sortedUsers = await UsersService.getMostPopular();
    if (sortedUsers.isEmpty) {
      setState(() => _positionedProfileImages = []);
      return;
    }

    // average popularity score is always 100
    var devSqSum = 0;
    sortedUsers
        .forEach((user) => devSqSum += pow(user.popularityScore - 100, 2));
    final std = sqrt(devSqSum / sortedUsers.length);

    final tileSize = std / 100;

    final highestScore = sortedUsers.first.popularityScore;
    final tiles = <Rect>[];
    final random = Random();
    setState(() => _positionedProfileImages = List<Widget>.from(
          sortedUsers.map(
            (popUser) {
              final size = popUser.popularityScore /
                  highestScore *
                  min(widget.width, widget.height) *
                  0.5; // * tileSize;
              // TODO: FIXME change tileSize

              var tile = Rect.fromLTWH(
                random.nextDouble() * (widget.width - size),
                random.nextDouble() * (widget.height - size),
                size,
                size,
              );
              var attempts = 0;
              while (_overlapsWithAny(rect: tile, otherRects: tiles) &&
                  attempts < 100) {
                tile = Rect.fromLTWH(
                  random.nextDouble() * (widget.width - size),
                  random.nextDouble() * (widget.height - size),
                  size,
                  size,
                );
                ++attempts;
              }

              tiles.add(tile);
              return Consumer<ThemeManager>(
                builder: (context, themeManager, child) => Positioned(
                  left: tile.left,
                  top: tile.top,
                  child: GestureDetector(
                    child: Container(
                      width: size,
                      height: size,
                      decoration: themeManager.theme == ThemeMode.dark
                          ? BoxDecoration(
                              border: Border.all(
                                  color: MyPalette.white, width: 2.0),
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [MyPalette.secondaryShadow],
                            ),
                      child: ClipRRect(
                        borderRadius: themeManager.theme == ThemeMode.dark
                            ? BorderRadius.zero
                            : BorderRadius.circular(20.0),
                        child: Hero(
                          tag: popUser.profile.profileImageUrl,
                          child:
                              getNetworkImage(popUser.profile.profileImageUrl),
                        ),
                      ),
                    ),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/user_profile',
                      arguments: popUser.profile,
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }

  bool _overlapsWithAny({Rect rect, List<Rect> otherRects}) {
    for (final otherRect in otherRects) {
      if (otherRect.overlaps(rect)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_positionedProfileImages == null) return Center(child: Loader());
    if (_positionedProfileImages.isEmpty) {
      return Center(
        child: Text(
          'There is no one here yet.',
          style: TextStyle(
            color: MyPalette.grey,
            fontSize: 16.0,
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: SizedBox(
        height: widget.height,
        child: Stack(children: _positionedProfileImages),
      ),
    );
  }
}
