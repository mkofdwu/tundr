import 'package:flutter/material.dart';

import 'package:tundr/constants/my_palette.dart';
import 'package:tundr/models/user_profile.dart';
import 'package:tundr/utils/from_theme.dart';
import 'package:tundr/utils/get_network_image.dart';
import 'package:tundr/widgets/verified_badge.dart';

class ProfileTile extends StatelessWidget {
  final UserProfile profile;
  final double fontSize;
  final String description;

  ProfileTile({
    Key key,
    @required this.profile,
    this.fontSize = 30,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) => ClipRRect(
          borderRadius: fromTheme(
            context,
            dark: BorderRadius.zero,
            light: BorderRadius.circular(20),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(),
                decoration: fromTheme(
                  context,
                  dark: BoxDecoration(
                    border: Border.all(color: MyPalette.white, width: 2),
                  ),
                  light: BoxDecoration(boxShadow: [MyPalette.secondaryShadow]),
                ),
                child: Hero(
                  tag: profile.profileImageUrl,
                  child: getNetworkImage(profile.profileImageUrl),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight / 2,
                  decoration:
                      BoxDecoration(gradient: MyPalette.transparentToBlack),
                ),
              ),
              Positioned(
                left: 30,
                bottom: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: profile.username,
                      child: Material(
                        color: Colors.transparent,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth - 100),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${profile.name}, ${profile.ageInYears}',
                                  style: TextStyle(
                                    color: MyPalette.white,
                                    fontSize: fontSize,
                                  ),
                                ),
                                if (profile.verified)
                                  WidgetSpan(
                                    child:
                                        VerifiedBadge(color: MyPalette.white),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    if (description != null)
                      Text(
                        description,
                        style: TextStyle(
                          color: MyPalette.white,
                          fontSize: fontSize / 2,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
