import "package:flutter/material.dart";
import 'package:tundr/models/user.dart';
import 'package:tundr/utils/constants/colors.dart';
import 'package:tundr/utils/constants/gradients.dart';
import 'package:tundr/utils/constants/shadows.dart';
import 'package:tundr/utils/fromtheme.dart';
import 'package:tundr/utils/getnetworkimage.dart';
import 'package:tundr/widgets/verifiedbadge.dart';

class ProfileTile extends StatelessWidget {
  final User user;
  final double fontSize;
  final String description;

  ProfileTile({
    Key key,
    @required this.user,
    this.fontSize = 30.0,
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
            light: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(),
                decoration: fromTheme(
                  context,
                  dark: BoxDecoration(
                    border: Border.all(color: AppColors.white, width: 2.0),
                  ),
                  light: BoxDecoration(boxShadow: [Shadows.secondaryShadow]),
                ),
                child: Hero(
                  tag: user.profileImageUrl,
                  child: getNetworkImage(user.profileImageUrl),
                ),
              ),
              Positioned(
                bottom: 0.0,
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight / 2,
                  decoration:
                      BoxDecoration(gradient: Gradients.transparentToBlack),
                ),
              ),
              Positioned(
                left: 20.0,
                bottom: constraints.maxHeight / 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: user.username,
                      child: Material(
                        color: Colors.transparent,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth - 100),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${user.name}, ${user.ageInYears}",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: fontSize,
                                  ),
                                ),
                                if (user.verified)
                                  WidgetSpan(
                                    child: VerifiedBadge(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    if (description != null)
                      Text(
                        description,
                        style: TextStyle(
                          color: AppColors.white,
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
