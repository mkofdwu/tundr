import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/models/themenotifier.dart';
import 'package:tundr/models/user.dart';
import 'package:tundr/pages/userprofile/userprofilepersonalinfo.dart';
import 'package:tundr/utils/constants/enums/apptheme.dart';
import 'package:tundr/utils/constants/gradients.dart';
import 'package:tundr/widgets/buttons/tileiconbutton.dart';
import 'package:tundr/widgets/media/mediathumbnail.dart';
import 'package:tundr/widgets/nextpagearrow.dart';

class UserProfileExtraMediaPage extends StatefulWidget {
  final User user;

  UserProfileExtraMediaPage({Key key, @required this.user}) : super(key: key);

  @override
  _UserProfileExtraMediaPageState createState() =>
      _UserProfileExtraMediaPageState();
}

class _UserProfileExtraMediaPageState extends State<UserProfileExtraMediaPage> {
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
      widget.user.interests.isNotEmpty || widget.user.personalInfo.isNotEmpty;

  _nextPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            UserProfilePersonalInfoPage(user: widget.user),
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
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Material(
        child: Stack(
          children: <Widget>[
            ListView.builder(
              padding: const EdgeInsets.symmetric(
                  vertical: 1.0), // to scroll up and down
              controller: _scrollController,
              itemCount: 10,
              itemBuilder: (context, i) {
                if (i == 9) return SizedBox(height: 200.0);
                if (widget.user.extraMedia[i] == null) return SizedBox.shrink();
                return MediaThumbnail(widget.user.extraMedia[i]);
              },
            ),
            TileIconButton(
              icon: Icons.close,
              onPressed: () {
                Navigator.popUntil(
                    context, (route) => route.settings.name == "userprofile");
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
                      Provider.of<ThemeNotifier>(context).theme == AppTheme.dark
                          ? Gradients.transparentToBlack
                          : Gradients.transparentToGold,
                ),
              ),
            ),
            _hasInfoLeft()
                ? Positioned(
                    left: width * 179 / 375,
                    bottom: 20.0,
                    child: NextPageArrow(onNextPage: _nextPage),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
