import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:tundr/repositories/theme-notifier.dart';
import 'package:tundr/enums/apptheme.dart';
import 'package:tundr/widgets/buttons/tile-icon.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Material(
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            TileIconButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
            Positioned(
              top: height * 100 / 812,
              right: 50,
              child: Text(
                "About",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 60.0,
                ),
              ),
            ),
            Positioned(
              top: height * 180 / 812,
              right: 20,
              width: 150.0,
              child: Image.asset(
                  "assets/images/logo-${Provider.of<ThemeNotifier>(context).theme == AppTheme.dark ? 'dark' : 'light'}.png"),
            ),
            Positioned(
              left: 40.0,
              top: height * 380 / 812,
              width: 200.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Primarily made as a dating app for my high school. I can't really remember what motivated me to create this.",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Developed by Jia Jie",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    "Version: 0.1.0a",
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 14.0,
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
