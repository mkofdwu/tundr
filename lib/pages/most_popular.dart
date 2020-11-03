import 'dart:math';

import 'package:flutter/material.dart';

import 'package:tundr/constants/my_palette.dart';
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
  List<Positioned> _positionedProfileImages;

  @override
  void initState() {
    super.initState();
    _loadPositionedProfileImages();
  }

  void _loadPositionedProfileImages() async {
    final sortedUsers = await UsersService.getMostPopular(20);
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

    sortedUsers.forEach((user) {});

    final highestScore = sortedUsers.first.popularityScore;
    final tiles = <Rect>[];
    final random = Random();
    setState(() => _positionedProfileImages =
            List<Positioned>.from(sortedUsers.map((user) {
          final size = user.popularityScore /
              highestScore *
              min(widget.width, widget.height) *
              tileSize;

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
          return Positioned(
            left: tile.left,
            top: tile.top,
            child: GestureDetector(
              child: Container(
                width: size,
                height: size,
                decoration: fromTheme(
                  context,
                  dark: BoxDecoration(
                    border: Border.all(color: MyPalette.white, width: 2.0),
                  ),
                  light: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [MyPalette.secondaryShadow],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: fromTheme(
                    context,
                    dark: BorderRadius.zero,
                    light: BorderRadius.circular(20.0),
                  ),
                  child: Hero(
                    tag: user.profileImageUrl,
                    child: getNetworkImage(user.profileImageUrl),
                  ),
                ),
              ),
              onTap: () => Navigator.pushNamed(
                context,
                'userprofile',
                arguments: user,
              ),
            ),
          );
        })));
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
