import 'dart:math';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/registration-info.dart';
import 'package:tundr/repositories/theme-notifier.dart';
import 'package:tundr/constants/enums/apptheme.dart';
import 'package:tundr/widgets/media/extra-media-grid.dart';
import 'package:tundr/widgets/buttons/tile-icon.dart';

class SetupExtraMediaPage extends StatefulWidget {
  @override
  _SetupExtraMediaPageState createState() => _SetupExtraMediaPageState();
}

class _SetupExtraMediaPageState extends State<SetupExtraMediaPage> {
  _return() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeNotifier>(context).theme = AppTheme.dark;
    return SafeArea(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TileIconButton(
              icon: Icons.arrow_back,
              onPressed: _return,
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Add more photos and videos?",
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(height: 10.0),
                  // Text(
                  //   "You can scroll down to skip this step, but it will probably increase your chances of finding a match",
                  //   style: TextStyle(fontSize: 12.0),
                  // ),
                  SizedBox(height: 50.0),
                  LayoutBuilder(
                    builder: (context, constraints) => ExtraMediaGrid(
                      size: min(
                          constraints.maxWidth,
                          MediaQuery.of(context).size.height -
                              170), // FIXME: FUTURE: how to get actual available height (by restricting height of column?)
                      extraMedia:
                          Provider.of<RegistrationInfo>(context).extraMedia,
                      onChangeMedia: (i, media) => setState(() =>
                          Provider.of<RegistrationInfo>(context).extraMedia[i] =
                              media),
                      onRemoveMedia: (i) => setState(() =>
                          Provider.of<RegistrationInfo>(context).extraMedia[i] =
                              null),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
