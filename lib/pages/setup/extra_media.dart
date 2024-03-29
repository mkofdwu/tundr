import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tundr/store/registration_info.dart';
import 'package:tundr/store/theme_manager.dart';
import 'package:tundr/widgets/media/extra_media_grid.dart';
import 'package:tundr/widgets/buttons/tile_icon.dart';

class SetupExtraMediaPage extends StatefulWidget {
  @override
  _SetupExtraMediaPageState createState() => _SetupExtraMediaPageState();
}

class _SetupExtraMediaPageState extends State<SetupExtraMediaPage> {
  void _return() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeManager>(context).theme = ThemeMode.dark;
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TileIconButton(
            icon: Icons.arrow_back,
            onPressed: _return,
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Add more photos and videos?',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: 10),
                // Text(
                //   'You can scroll down to skip this step, but it will probably increase your chances of finding a match',
                //   style: TextStyle(fontSize: 12),
                // ),
                SizedBox(height: 50),
                LayoutBuilder(
                  builder: (context, constraints) => ExtraMediaGrid(
                    size: min(constraints.maxWidth,
                        MediaQuery.of(context).size.height - 170),
                    extraMedia:
                        Provider.of<RegistrationInfo>(context, listen: false)
                            .extraMedia,
                    onChangeMedia: (i, media) => setState(() =>
                        Provider.of<RegistrationInfo>(context, listen: false)
                            .extraMedia[i] = media),
                    onRemoveMedia: (i) => setState(() =>
                        Provider.of<RegistrationInfo>(context, listen: false)
                            .extraMedia[i] = null),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
