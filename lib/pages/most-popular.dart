import 'dart:math';

import "package:flutter/material.dart";
import 'package:tundr/models/user.dart';
import 'package:tundr/services/database-service.dart';
import 'package:tundr/constants/colors.dart';
import 'package:tundr/constants/shadows.dart';
import 'package:tundr/utils/from-theme.dart';
import 'package:tundr/utils/get-network-image.dart';
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
    final List<User> sortedUsers = await DatabaseService.getMostPopular(20);
    if (sortedUsers.isEmpty) {
      setState(() => _positionedProfileImages = []);
      return;
    }

    // average popularity score is always 100
    double devSqSum = 0;
    sortedUsers
        .forEach((user) => devSqSum += pow(user.popularityScore - 100, 2));
    final double std = sqrt(devSqSum / sortedUsers.length);

    final double tileSize = std / 100;

    sortedUsers.forEach((user) {});

    final num highestScore = sortedUsers.first.popularityScore;
    List<Rect> tiles = [];
    final Random random = Random();
    setState(() => _positionedProfileImages =
            List<Positioned>.from(sortedUsers.map((user) {
          final double size = user.popularityScore /
              highestScore *
              min(widget.width, widget.height) *
              tileSize;

          Rect tile = Rect.fromLTWH(
            random.nextDouble() * (widget.width - size),
            random.nextDouble() * (widget.height - size),
            size,
            size,
          );
          int attempts = 0;
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
                    border: Border.all(color: AppColors.white, width: 2.0),
                  ),
                  light: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [Shadows.secondaryShadow],
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
                "userprofile",
                arguments: user,
              ),
            ),
          );
        })));
  }

  bool _overlapsWithAny({Rect rect, List<Rect> otherRects}) {
    for (final Rect otherRect in otherRects) {
      if (otherRect.overlaps(rect)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_positionedProfileImages == null) return Center(child: Loader());
    if (_positionedProfileImages.isEmpty)
      return Center(
        child: Text(
          "There is no one here yet.",
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 16.0,
          ),
        ),
      );
    return SingleChildScrollView(
      child: SizedBox(
        height: widget.height,
        child: Stack(children: _positionedProfileImages),
      ),
    );
  }
}
