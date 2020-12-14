import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/repositories/theme_manager.dart';
import 'package:tundr/services/users_service.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/my_loader.dart';

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
      if (mounted) setState(() => _positionedProfileImages = []);
      return;
    }

    var totalArea = 0.0;
    for (final user in sortedUsers) {
      totalArea += pow(user.popularityScore, 2);
    }
    final availableArea = widget.width * widget.height;
    // 0.4 to give a lot of breathing space, size is the length so it needs to be rooted
    final sizeFactor = pow((availableArea * 0.4) / totalArea, 0.5);

    final tiles = <Rect>[];
    final random = Random();
    if (mounted) {
      setState(() => _positionedProfileImages = List<Widget>.from(
            sortedUsers.map(
              (popUser) {
                final size = popUser.popularityScore * sizeFactor;

                var tile = Rect.fromLTWH(
                  random.nextDouble() * (widget.width - size),
                  random.nextDouble() * (widget.height - size),
                  size,
                  size,
                );
                var attempts = 0;
                while (_overlapsWithAny(rect: tile, otherRects: tiles) &&
                    attempts < 500) {
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
                                    color: MyPalette.white, width: 2),
                              )
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(size / 8),
                                boxShadow: [MyPalette.secondaryShadow],
                              ),
                        child: ClipRRect(
                          borderRadius: themeManager.theme == ThemeMode.dark
                              ? BorderRadius.zero
                              : BorderRadius.circular(size / 8),
                          child: Hero(
                            tag: popUser.profile.profileImageUrl,
                            child: getNetworkImage(
                                popUser.profile.profileImageUrl),
                          ),
                        ),
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/profile',
                        arguments: popUser.profile,
                      ),
                    ),
                  ),
                );
              },
            ),
          ));
    }
  }

  bool _overlapsWithAny({Rect rect, List<Rect> otherRects}) {
    for (final otherRect in otherRects) {
      if (otherRect.overlaps(rect)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_positionedProfileImages == null) return Center(child: MyLoader());
    if (_positionedProfileImages.isEmpty) {
      return Center(
        child: Text(
          'There is no one here yet.',
          style: TextStyle(
            color: MyPalette.grey,
            fontSize: 16,
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
